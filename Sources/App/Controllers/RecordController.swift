//
//  RecordsController.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent

struct RecordsContorller {

    private let service: RecordsServiceProtocol

    init(service: RecordsServiceProtocol) {
        self.service = service
    }

    func create(_ request: Request) async throws -> HTTPStatus {
        try await service.create(request: request)
    }

    func record(_ request: Request) async throws -> RecordResponse {
        try await service.record(request: request)
    }

    func all(_ request: Request) async throws -> Page<RecordResponse> {
        try await service.all(request: request)
    }
}

extension RecordsContorller: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes
            .grouped("api", "records")
            .grouped(AuthorizationToken.authenticator(), AuthorizationToken.guardMiddleware())

        group.get(use: all)
        group.get(":id", use: record)
        group.post(use: create)
    }
}
