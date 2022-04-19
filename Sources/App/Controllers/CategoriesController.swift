//
//  CategoriesController.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor

struct CategoriesController {

    struct CreateRequestBody: Content {

        let emoji: String
        let name: String
    }

    func all(req: Request) async throws -> [Category] {
        return try await Category.query(on: req.db).all()
    }

    func category(req: Request) async throws -> Category {
        guard let category = try await Category.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return category
    }

    func create(req: Request) async throws -> HTTPStatus {
        let requestBody = try req.content.decode(CreateRequestBody.self)
        let category = Category(emoji: requestBody.emoji, name: requestBody.name)
        try await category.save(on: req.db)
        return .created
    }
}
