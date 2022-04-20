//
//  UserServiceProtocol.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor

protocol UserServiceProtocol {

    func signUp(request: Request) async throws -> HTTPStatus
    func signIn(request: Request) async throws -> AuthResponse
}
