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
import NIOSSL

extension Application {

    var supportingDirectory: String { self.directory.workingDirectory + "Supporting/" }
}

extension String {

    var bytes: [UInt8] { .init(self.utf8) }
}

extension JWKIdentifier {

    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

public func configure(_ app: Application) throws {
    // MARK: - Server configuration
    try configureServer(app)

    // MARK: - Database configuration
    configureDatabase(app)

    // MARK: - Migrations
    try addMigrations(app)

    // MARK: - JWT and password configuration
    try configureUserSecurity(app)

    // MARK: - Routes
    try routes(app)
}

private func configureServer(_ app: Application) throws {
    app.http.server.configuration.supportVersions = [.two]

    let certificateName: String
    let privateKeyName: String

    switch app.environment {
    case .development:
        certificateName = "localhost.pem"
        privateKeyName = "localhost-key.pem"
    case .production:
        certificateName = "cert.pem"
        privateKeyName = "key.pem"
    default:
        throw NIOSSLError.failedToLoadCertificate
    }

    let certificatePath = app.supportingDirectory + certificateName
    let privateKeyPath = app.supportingDirectory + privateKeyName
    try app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
        certificateChain: NIOSSLCertificate.fromPEMFile(certificatePath).map { .certificate($0) },
        privateKey: .file(privateKeyPath)
    )
    app.http.server.configuration.tlsConfiguration?.certificateVerification = .none
}

private func configureDatabase(_ app: Application) {
    let configuration = PostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "yessetmurat",
        password: Environment.get("DATABASE_PASSWORD"),
        database: Environment.get("DATABASE_NAME") ?? "Fracker"
    )
    app.databases.use(.postgres(configuration: configuration), as: .psql)
}

private func addMigrations(_ app: Application) throws {
    app.migrations.add(User.Migration())
    app.migrations.add(Category.Migration())
    app.migrations.add(Record.Migration())
    try app.autoMigrate().wait()
}

private func configureUserSecurity(_ app: Application) throws {
    let privateKey = try String(contentsOfFile: app.supportingDirectory + "jwt.key")
    let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))

    let publicKey = try String(contentsOfFile: app.supportingDirectory + "jwt.key.pub")
    let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))

    app.jwt.signers.use(privateSigner, kid: .private)
    app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)

    app.passwords.use(.bcrypt)
}
