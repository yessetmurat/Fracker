//
//  ProfileController.swift
//  
//
//  Created by Yesset Murat on 5/8/22.
//

import Vapor

struct ProfileController {

    func profile(request: Request) async throws -> ProfileResponse {
        let user = try await request.user
        return try ProfileResponse(
            id: user.requireID(),
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName
        )
    }
}

extension ProfileController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes
            .grouped("api", "profile")
            .grouped(AuthorizationToken.authenticator(), AuthorizationToken.guardMiddleware())

        group.get(use: profile)
    }
}
