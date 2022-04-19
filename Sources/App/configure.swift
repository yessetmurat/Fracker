//
//  configure.swift
//
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    guard let databaseUrl = Environment.get("DB_URL") else {
        throw Abort(.badGateway)
    }
    try app.databases.use(.postgres(url: databaseUrl), as: .psql)
    app.migrations.add(CategoriesMigration())
    app.migrations.add(RecordsMigration())
    try app.autoMigrate().wait()
    try routes(app)
}
