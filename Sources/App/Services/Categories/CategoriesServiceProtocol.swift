//
//  CategoriesServiceProtocol.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor

protocol CategoriesServiceProtocol {

    func create(request: Request) async throws -> HTTPStatus
    func category(request: Request) async throws -> CategoryResponse
    func all(request: Request) async throws -> [CategoryResponse]
}
