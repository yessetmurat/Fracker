//
//  ApiKeyMiddleware.swift
//  
//
//  Created by Yesset Murat on 6/6/22.
//

import Vapor

struct ApiKeyMiddleware: AsyncMiddleware {

    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let apiKey = try request.query.get(String.self, at: "api_key")

        guard apiKey == request.application.apiKey else {
            throw Abort(.badRequest, reason: "The provided API key is not valid")
        }

        return try await next.respond(to: request)
    }
}
