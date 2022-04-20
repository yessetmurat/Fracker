//
//  File.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Fluent

extension Record {

    struct Migration: AsyncMigration {

        func prepare(on database: Database) async throws {
            try await database
                .schema(schema)
                .id()
                .field(FieldKeys.createdAt, .datetime, .required)
                .field(FieldKeys.amount, .double, .required)
                .field(FieldKeys.category, .uuid, .references(Category.schema, .id), .required)
                .field(FieldKeys.user, .uuid, .references(User.schema, .id), .required)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(schema)
                .delete()
        }
    }
}
