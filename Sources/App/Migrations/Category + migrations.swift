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
                .field(FieldKeys.name, .string, .required)
                .field(FieldKeys.user, .uuid, .references(User.schema, .id), .required)
                .update()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(schema)
                .delete()
        }
    }
}
