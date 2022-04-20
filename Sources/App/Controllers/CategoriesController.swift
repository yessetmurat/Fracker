//
//  CategoriesController.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor

struct CategoriesController {

    private let service: CategoriesServiceProtocol

    init(service: CategoriesServiceProtocol) {
        self.service = service
    }

    func all(_ request: Request) async throws -> [CategoryResponse] {
        try await service.all(request: request)
    }

    func category(_ request: Request) async throws -> CategoryResponse {
        try await service.category(request: request)
    }

    func create(_ request: Request) async throws -> HTTPStatus {
        try await service.create(request: request)
    }
}

extension CategoriesController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes
            .grouped("api", "categories")
            .grouped(AuthorizationToken.authenticator(), AuthorizationToken.guardMiddleware())

        group.get(use: all)
        group.get(":id", use: category)
        group.post(use: create)
    }
}
