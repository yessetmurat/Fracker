//
//  Category + migrations.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Fluent

extension Category {

    struct Migration: AsyncMigration {

        func prepare(on database: Database) async throws {
            try await database
                .schema(schema)
                .id()
                .field(FieldKeys.emoji, .string, .required)
                .field(FieldKeys.name, .string, .required)
                .field(FieldKeys.deletedAt, .datetime)
                .field(FieldKeys.user, .uuid, .references(User.schema, .id), .required)
                .unique(on: FieldKeys.emoji)
                .unique(on: FieldKeys.name)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(schema)
                .delete()
        }
    }
}
