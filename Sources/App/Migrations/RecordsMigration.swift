//
//  RecordsMigration.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import FluentKit

struct RecordsMigration: AsyncMigration {

    func prepare(on database: Database) async throws {
        try await database
            .schema(Record.schema)
            .id()
            .field("created_at", .datetime, .required)
            .field("category", .uuid, .references(Category.schema, .id), .required)
            .field("amount", .double, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database
            .schema(Record.schema)
            .delete()
    }
}
