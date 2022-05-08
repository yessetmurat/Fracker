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
                .create()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(schema)
                .delete()
        }
    }

    struct Migration_8_05_2022: AsyncMigration {

        func prepare(on database: Database) async throws {
            try await database
                .schema(schema)
                .field(FieldKeys.createdAt, .datetime)
                .update()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(schema)
                .delete()
        }
    }
}
