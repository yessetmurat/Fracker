//
//  User + migrations.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Fluent

extension User {

    struct Migration: AsyncMigration {

        func prepare(on database: Database) async throws {
            try await database
                .schema(schema)
                .id()
                .field(FieldKeys.email, .string, .required)
                .field(FieldKeys.password, .string, .required)
                .unique(on: FieldKeys.email)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database
                .schema(schema)
                .delete()
        }
    }
}
