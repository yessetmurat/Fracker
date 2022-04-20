//
//  UserController.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor

struct UserController {

    private let service: UserServiceProtocol

    init(service: UserServiceProtocol) {
        self.service = service
    }

    func signUp(_ request: Request) async throws -> HTTPStatus {
        try await service.signUp(request: request)
    }

    func signIn(_ request: Request) async throws -> AuthResponse {
        try await service.signIn(request: request)
    }
}

extension UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("api", "users")

        group.post("sign-up", use: signUp)
        group.post("sign-in", use: signIn)
    }
}
