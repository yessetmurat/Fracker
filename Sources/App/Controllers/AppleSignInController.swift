//
//  AppleSignInController.swift
//  
//
//  Created by Yesset Murat on 4/25/22.
//

import Vapor
import Fluent
import JWT

struct AppleSignInController {

    func auth(request: Request) async throws -> AuthResponse {
        let requestBody = try request.content.decode(SignInRequestBody.self)
        let appleIdentityToken = try await request.jwt.apple.verify(requestBody.idToken)
        return try await appleAuthorization(
            request: request,
            appleIdentityToken: appleIdentityToken,
            givenName: requestBody.firstName,
            familyName: requestBody.lastName
        )
    }

    func appleAuthorization(
        request: Request,
        appleIdentityToken: AppleIdentityToken,
        givenName: String? = nil,
        familyName: String? = nil
    ) async throws -> AuthResponse {
        guard let email = appleIdentityToken.email else {
            throw Abort(.badRequest, reason: Reason.emailError.description(for: request))
        }

        let userIdentifier = appleIdentityToken.subject.value

        if let user = try await User.query(on: request.db).filter(\.$appleUserIdentifier == userIdentifier).first() {
            return try authResponse(request: request, for: user)
        } else {
            let name = Name.random.components(separatedBy: " ")
            let firstName = name.first
            let lastName = name.last

            let user = User(
                email: email,
                appleUserIdentifier: userIdentifier,
                firstName: givenName ?? firstName,
                lastName: familyName ?? lastName
            )

            try await user.create(on: request.db)

            return try authResponse(request: request, for: user)
        }
    }

    private func authResponse(request: Request, for user: User) throws -> AuthResponse {
        let payload = try AuthorizationToken(user: user)
        let token = try request.jwt.sign(payload, kid: .private)
        return AuthResponse(token: token)
    }
}

extension AppleSignInController {

    enum Reason: ReasonProtocol {

        case emailError

        func description(for request: Request) -> String {
            switch self {
            case .emailError: return "Apple.emailError".localized(for: request)
            }
        }
    }
}

extension AppleSignInController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("api", "auth", "apple")

        group.post(use: auth)
    }
}
