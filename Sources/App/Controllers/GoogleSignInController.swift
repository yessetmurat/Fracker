//
//  GoogleSignInController.swift
//  
//
//  Created by Yesset Murat on 4/27/22.
//

import Vapor
import Fluent
import JWT

struct GoogleSignInController {

    func auth(request: Request) async throws -> AuthResponse {
        let requestBody = try request.content.decode(SignInRequestBody.self)
        let googleIdentityToken = try await request.jwt.google.verify(requestBody.idToken)
        return try await googleAuthorization(request: request, googleIdentityToken: googleIdentityToken)
    }

    func googleAuthorization(request: Request, googleIdentityToken: GoogleIdentityToken) async throws -> AuthResponse {
        guard let email = googleIdentityToken.email else {
            throw Abort(.badRequest, reason: "Unable to get email from Google")
        }

        let userIdentifier = googleIdentityToken.subject.value

        if let user = try await User.query(on: request.db).filter(\.$googleUserIdentifier == userIdentifier).first() {
            return try authResponse(request: request, for: user)
        } else {
            let user = User(
                email: email,
                googleUserIdentifier: userIdentifier,
                firstName: googleIdentityToken.givenName,
                lastName: googleIdentityToken.familyName
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

extension GoogleSignInController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("api", "auth", "google")

        group.post(use: auth)
    }
}
