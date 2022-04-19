//
//  CategoriesMigration.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import FluentKit

struct CategoriesMigration: AsyncMigration {

    func prepare(on database: Database) async throws {
        try await database
            .schema(Category.schema)
            .id()
            .field("emoji", .string, .required)
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database
            .schema(Category.schema)
            .delete()
    }
}
