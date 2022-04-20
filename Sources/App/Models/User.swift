//
//  User.swift
//  
//
//  Created by Yesset Murat on 4/20/22.
//

import Vapor
import Fluent

final class User: Model {

    static let schema = "users"

    struct FieldKeys {

        static var email: FieldKey { "email" }
        static var password: FieldKey { "password" }
    }

    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.email)
    var email: String

    @Field(key: FieldKeys.password)
    var password: String

    @Children(for: \.$user)
    var categories: [Category]

    @Children(for: \.$user)
    var records: [Record]

    init() {}

    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

extension User: Content {}

extension User: Authenticatable {}

extension User: Validatable {

    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}
