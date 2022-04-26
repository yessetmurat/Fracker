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

    struct RequestBody: Decodable {

        let appleIdentityToken: String
        let firstName: String?
        let lastName: String?
    }

    func auth(request: Request) async throws -> AuthResponse {
        let requestBody = try request.content.decode(RequestBody.self)
        let appleIdentityToken = try await request.jwt.apple.verify(requestBody.appleIdentityToken)
        return try await appleAuthorization(
            request: request,
            appleIdentityToken: appleIdentityToken,
            firstName: requestBody.firstName,
            lastName: requestBody.lastName
        )
    }

    func appleAuthorization(
        request: Request,
        appleIdentityToken: AppleIdentityToken,
        firstName: String? = nil,
        lastName: String? = nil
    ) async throws -> AuthResponse {
        guard let email = appleIdentityToken.email else {
            throw Abort(.badRequest, reason: "Unable to get email from Apple")
        }

        if let user = try await User.query(on: request.db).filter(\.$email == email).first() {
            return try authResponse(request: request, for: user)
        } else {
            let user = User(
                email: email,
                appleUserIdentifier: appleIdentityToken.subject.value,
                firstName: firstName,
                lastName: lastName
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

extension AppleSignInController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("api", "auth", "apple")

        group.post(use: auth)
    }
}
