//
//  File.swift
//  
//
//  Created by Yesset Murat on 4/21/22.
//

import Vapor
import Fluent

protocol RecordsServiceProtocol {

    func create(request: Request) async throws -> HTTPStatus
    func record(request: Request) async throws -> RecordResponse
    func all(request: Request) async throws -> Page<RecordResponse>
}
