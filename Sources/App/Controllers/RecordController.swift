//
//  RecordsController.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent

struct RecordsContorller {

    struct CreateRequestBody: Content {

        let amount: Decimal
        let category: UUID
    }

    func all(req: Request) async throws -> Page<Record> {
        try await Record.query(on: req.db).with(\.$category).paginate(for: req)
    }

    func create(req: Request) async throws -> HTTPStatus {
        let requestBody = try req.content.decode(CreateRequestBody.self)
        guard let category = try await Category.find(requestBody.category, on: req.db) else {
            throw Abort(.badRequest, reason: "Unable to find category")
        }
        let record = Record(category: try category.requireID(), amount: requestBody.amount)
        try await record.save(on: req.db)
        return .created
    }
}
