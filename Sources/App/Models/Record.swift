//
//  Record.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent

final class Record: Model {

    static let schema = "records"

    struct FieldKeys {

        static var createdAt: FieldKey { "created_at" }
        static var amount: FieldKey { "amount" }
        static var category: FieldKey { "category" }
        static var user: FieldKey { "user" }
    }

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Field(key: FieldKeys.amount)
    var amount: Double

    @Parent(key: FieldKeys.category)
    var category: Category

    @Parent(key: FieldKeys.user)
    var user: User

    init() {}

    init(id: UUID? = nil, createdAt: Date? = nil, amount: Double, category: Category.IDValue, user: User.IDValue) {
        self.id = id
        self.createdAt = createdAt
        self.amount = amount
        self.$category.id = category
        self.$user.id = user
    }
}

extension Record: Content {}
