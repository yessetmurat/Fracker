//
//  UserController.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor
import Fluent

struct UserController {

    func signUp(request: Request) async throws -> HTTPStatus {
        let user = try request.content.decode(User.self)

        guard try await User.query(on: request.db).filter(\.$email == user.email).first() == nil else {
            throw Abort(.badRequest, reason: "A user with email \(user.email) already exists")
        }

        guard let password = user.password else { throw Abort(.badRequest, reason: "Password is required") }

        let passwordHash = try await request.password.async.hash(password)
        let name = Name.random.components(separatedBy: " ")
        let firstName = name.first
        let lastName = name.last
        let persistedUser = User(email: user.email, password: passwordHash, firstName: firstName, lastName: lastName)

        try await persistedUser.create(on: request.db)

        return .created
    }

    func signIn(request: Request) async throws -> AuthResponse {
        let user = try request.content.decode(User.self)

        guard let password = user.password else { throw Abort(.badRequest, reason: "Password is required") }

        guard let persistedUser = try await User.query(on: request.db).filter(\.$email == user.email).first() else {
            throw Abort(.badRequest, reason: "A user with email \(user.email) not found")
        }

        guard let passwordHash = persistedUser.password,
              try await request.password.async.verify(password, created: passwordHash) else {
            throw Abort(.badRequest, reason: "Incorrect user password")
        }

        let payload = try AuthorizationToken(user: persistedUser)
        let token = try request.jwt.sign(payload, kid: .private)

        return AuthResponse(token: token)
    }
}

extension UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("api", "users")

        group.post("sign-up", use: signUp)
        group.post("sign-in", use: signIn)
    }
}
