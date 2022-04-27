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
        static var appleUserIdentifier: FieldKey { "apple_user_identifier" }
        static var googleUserIdentifier: FieldKey { "google_user_identifier" }
        static var password: FieldKey { "password" }
        static var firstName: FieldKey { "first_name" }
        static var lastName: FieldKey { "last_name" }
    }

    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.email)
    var email: String

    @Field(key: FieldKeys.appleUserIdentifier)
    var appleUserIdentifier: String?

    @Field(key: FieldKeys.googleUserIdentifier)
    var googleUserIdentifier: String?

    @Field(key: FieldKeys.password)
    var password: String?

    @Field(key: FieldKeys.firstName)
    var firstName: String?

    @Field(key: FieldKeys.lastName)
    var lastName: String?

    @Children(for: \.$user)
    var categories: [Category]

    @Children(for: \.$user)
    var records: [Record]

    init() {}

    init(
        id: UUID? = nil,
        email: String,
        appleUserIdentifier: String? = nil,
        googleUserIdentifier: String? = nil,
        password: String? = nil,
        firstName: String? = nil,
        lastName: String? = nil
    ) {
        self.id = id
        self.email = email
        self.appleUserIdentifier = appleUserIdentifier
        self.googleUserIdentifier = googleUserIdentifier
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension User: Content {}

extension User: Authenticatable {}
