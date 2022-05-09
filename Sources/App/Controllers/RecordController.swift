//
//  RecordsController.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent

struct RecordsContorller {

    struct CreateRequestBody: Decodable {

        let id: UUID?
        let amount: Decimal
        let createdAt: Date?
        let category: UUID
    }

    func create(request: Request) async throws -> HTTPStatus {
        let user = try await request.user
        let requestData = try request.content.decode(CreateRequestBody.self)

        guard let category = try await
                request.user.$categories.query(on: request.db).filter(\.$id == requestData.category).first() else {
            throw Abort(.badRequest, reason: CategoriesController.Reason.categoryNotFound.description(for: request))
        }

        let record = try Record(
            id: requestData.id,
            createdAt: requestData.createdAt,
            amount: requestData.amount,
            category: category.requireID(),
            user: user.requireID()
        )

        try await record.save(on: request.db)
        return .created
    }

    func batchCreate(request: Request) async throws -> HTTPStatus {
        let user = try await request.user
        let requestData = try request.content.decode([CreateRequestBody].self)
        var records: [Record] = []

        for object in requestData where try await Record.find(object.id, on: request.db) == nil {
            let category = try await request.user.$categories.query(on: request.db)
                .filter(\.$id == object.category)
                .withDeleted()
                .first()

            if let category = category {
                do {
                    let record = try Record(
                        id: object.id,
                        createdAt: object.createdAt,
                        amount: object.amount,
                        category: category.requireID(),
                        user: user.requireID()
                    )
                    records.append(record)
                } catch {
                    continue
                }
            }
        }

        try await records.create(on: request.db)
        return .created
    }

    func record(request: Request) async throws -> RecordResponse {
        guard let id = request.parameters.get("id"), let uuid = UUID(uuidString: id) else {
            throw Abort(.badRequest, reason: "Parameter id isn't UUID type")
        }

        guard let record = try await
                request.user.$records.query(on: request.db).filter(\.$id == uuid).with(\.$category).first() else {
            throw Abort(.badRequest, reason: "Record with specified id wasn't found")
        }

        let category = try CategoryResponse(
            id: record.category.requireID(),
            emoji: record.category.emoji,
            name: record.category.name,
            createdAt: record.category.createdAt,
            deletedAt: record.category.deletedAt
        )

        return try RecordResponse(
            id: record.requireID(),
            createdAt: record.createdAt,
            amount: record.amount,
            category: category
        )
    }

    // TODO: - Fix removed parent
    func all(request: Request) async throws -> Page<RecordResponse> {
        let records = try await request.user.$records.query(on: request.db).with(\.$category).paginate(for: request)
        return try records.map { record in
            let category = try CategoryResponse(
                id: record.category.requireID(),
                emoji: record.category.emoji,
                name: record.category.name,
                createdAt: record.category.createdAt,
                deletedAt: record.category.deletedAt
            )
            return try RecordResponse(
                id: record.requireID(),
                createdAt: record.createdAt,
                amount: record.amount,
                category: category
            )
        }
    }
}

extension RecordsContorller: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes
            .grouped("api", "records")
            .grouped(AuthorizationToken.authenticator(), AuthorizationToken.guardMiddleware())

        group.get(use: all)
        group.get(":id", use: record)
        group.post(use: create)
        group.post("batch", use: batchCreate)
    }
}
