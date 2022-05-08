//
//  CategoriesController.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent

struct CategoriesController {

    struct CreateRequestBody: Decodable {

        let id: UUID?
        let emoji: String
        let name: String
        let createdAt: Date?
        let deletedAt: Date?
    }

    func create(request: Request) async throws -> HTTPStatus {
        let user = try await request.user
        let category = try request.content.decode(CreateRequestBody.self)
        let persistedCategory = try Category(
            id: category.id,
            emoji: category.emoji,
            name: category.name,
            user: user.requireID()
        )

        try await persistedCategory.save(on: request.db)
        return .created
    }

    func batchCreate(request: Request) async throws -> HTTPStatus {
        let user = try await request.user

        let requestData = try request.content.decode([CreateRequestBody].self)
        var categories: [Category] = []

        for object in requestData where try await Category.find(object.id, on: request.db) == nil {
            if let category = try await Category.query(on: request.db)
                .filter(\.$emoji == object.emoji)
                .filter(\.$name == object.name)
                .first() {
                try await category.delete(on: request.db)
            }

            do {
                let category = try Category(
                    id: object.id,
                    emoji: object.emoji,
                    name: object.name,
                    createdAt: object.createdAt,
                    deletedAt: object.deletedAt,
                    user: user.requireID()
                )
                categories.append(category)
            } catch {
                continue
            }
        }

        try await categories.create(on: request.db)
        return .created
    }

    func category(request: Request) async throws -> CategoryResponse {
        guard let category = try await Category.find(request.parameters.get("id"), on: request.db) else {
            throw Abort(.badRequest, reason: "Category with specified id wasn't found")
        }

        return try CategoryResponse(
            id: category.requireID(),
            emoji: category.emoji,
            name: category.name,
            createdAt: category.createdAt,
            deletedAt: category.deletedAt
        )
    }

    func delete(request: Request) async throws -> HTTPStatus {
        guard let category = try await Category.find(request.parameters.get("id"), on: request.db) else {
            throw Abort(.badRequest, reason: "Category with specified id wasn't found")
        }

        try await category.delete(on: request.db)
        return .ok
    }

    func all(request: Request) async throws -> [CategoryResponse] {
        return try await request.user.$categories.query(on: request.db)
            .withDeleted()
            .sort(\.$createdAt)
            .all()
            .map { category in
                try CategoryResponse(
                    id: category.requireID(),
                    emoji: category.emoji,
                    name: category.name,
                    createdAt: category.createdAt,
                    deletedAt: category.deletedAt
                )
        }
    }
}

extension CategoriesController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes
            .grouped("api", "categories")
            .grouped(AuthorizationToken.authenticator(), AuthorizationToken.guardMiddleware())

        group.get(use: all)
        group.get(":id", use: category)
        group.delete(":id", use: delete)
        group.post(use: create)
        group.post("batch", use: batchCreate)
    }
}
