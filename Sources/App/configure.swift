//
//  configure.swift
//
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent
import FluentPostgresDriver
import JWT

extension Application {

    static let databaseUrl = URL(string: Environment.get("DB_URL")!)!
}

extension String {

    var bytes: [UInt8] { .init(self.utf8) }
}

extension JWKIdentifier {

    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

public func configure(_ app: Application) throws {
    // MARK: - Database configuratioon
    try configureDatabase(app)

    // MARK: - Migrations
    addMigrations(app)

    // MARK: - JWT and password configuration
    try configureUserSecurity(app)

    // MARK: - Routes
    try routes(app)
}

private func configureDatabase(_ app: Application) throws {
    try app.databases.use(.postgres(url: Application.databaseUrl), as: .psql)
}

private func addMigrations(_ app: Application) {
    app.migrations.add(User.Migration())
    app.migrations.add(Category.Migration())
    app.migrations.add(Record.Migration())
}

private func configureUserSecurity(_ app: Application) throws {
    let privateKey = try String(contentsOfFile: app.directory.workingDirectory + "jwtRS256.key")
    let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))

    let publicKey = try String(contentsOfFile: app.directory.workingDirectory + "jwtRS256.key.pub")
    let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))

    app.jwt.signers.use(privateSigner, kid: .private)
    app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)

    app.passwords.use(.bcrypt)
}
