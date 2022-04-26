//
//  Category.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent

final class Category: Model {

    static let schema = "categories"

    struct FieldKeys {

        static var name: FieldKey { "name" }
        static var user: FieldKey { "user" }
        static var deletedAt: FieldKey { "deleted_at" }
    }

    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.name)
    var name: String

    @Timestamp(key: FieldKeys.deletedAt, on: .delete)
    var deletedAt: Date?

    @Parent(key: FieldKeys.user)
    var user: User

    init() {}

    init(id: UUID? = nil, name: String, user: User.IDValue) {
        self.id = id
        self.name = name
        self.$user.id = user
    }
}

extension Category: Content {}
