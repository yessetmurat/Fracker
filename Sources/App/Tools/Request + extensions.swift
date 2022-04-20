//
//  File.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor
import Fluent

extension Request {

    var user: User {
        get async throws {
            let token = try auth.require(AuthorizationToken.self)
            guard let user = try await User.find(token.userId, on: db) else {
                throw Abort(.badRequest, reason: "User not found")
            }
            return user
        }
    }
}
