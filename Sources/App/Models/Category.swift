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

        static var emoji: FieldKey { "emoji" }
        static var name: FieldKey { "name" }
        static var user: FieldKey { "user" }
        static var createdAt: FieldKey { "created_at" }
        static var deletedAt: FieldKey { "deleted_at" }
    }

    @ID(key: .id)
    var id: UUID?

    @Field(key: FieldKeys.emoji)
    var emoji: String

    @Field(key: FieldKeys.name)
    var name: String

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.deletedAt, on: .delete)
    var deletedAt: Date?

    @Parent(key: FieldKeys.user)
    var user: User

    @Children(for: \.$category)
    var records: [Record]

    init() {}

    init(
        id: UUID? = nil,
        emoji: String,
        name: String,
        createdAt: Date? = nil,
        deletedAt: Date? = nil,
        user: User.IDValue
    ) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.createdAt = createdAt
        self.deletedAt = deletedAt
        self.$user.id = user
    }
}

extension Category: Content {}
