//
//  UserService.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor
import Fluent

struct UserService: UserServiceProtocol {

    func signUp(request: Request) async throws -> HTTPStatus {
        try User.validate(content: request)
        let user = try request.content.decode(User.self)

        guard try await User.query(on: request.db).filter(\.$email == user.email).first() == nil else {
            throw Abort(.badRequest, reason: "A user with email \(user.email) already exists")
        }

        let password = try await request.password.async.hash(user.password)
        let persistedUser = User(email: user.email, password: password)

        try await persistedUser.create(on: request.db)

        return .created
    }

    func signIn(request: Request) async throws -> AuthResponse {
        let user = try request.content.decode(User.self)

        guard let persistedUser = try await User.query(on: request.db).filter(\.$email == user.email).first() else {
            throw Abort(.badRequest, reason: "A user with email \(user.email) not found")
        }

        guard try await request.password.async.verify(user.password, created: persistedUser.password) else {
            throw Abort(.badRequest, reason: "Incorrect user password")
        }

        let payload = try AuthorizationToken(user: persistedUser)
        let token = try request.jwt.sign(payload, kid: .private)

        return AuthResponse(token: token)
    }
}
