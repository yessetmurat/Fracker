//
//  CategoriesService.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor
import Fluent

struct CategoriesService: CategoriesServiceProtocol {

    struct CreateRequestBody: Content {

        let emoji: String
        let name: String
    }

    func create(request: Request) async throws -> HTTPStatus {
        let user = try await request.user
        let category = try request.content.decode(CreateRequestBody.self)
        let persistedCategory = try Category(emoji: category.emoji, name: category.name, user: user.requireID())

        try await persistedCategory.save(on: request.db)
        return .created
    }

    func category(request: Request) async throws -> CategoryResponse {
        guard let category = try await Category.find(request.parameters.get("id"), on: request.db) else {
            throw Abort(.badRequest, reason: "Category with specified id wasn't found")
        }

        return try CategoryResponse(id: category.requireID(), emoji: category.emoji, name: category.name)
    }

    func all(request: Request) async throws -> [CategoryResponse] {
        return try await request.user.$categories.get(on: request.db).map { category in
            try CategoryResponse(id: category.requireID(), emoji: category.emoji, name: category.name)
        }
    }
}
