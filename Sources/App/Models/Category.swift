//
//  Category.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent
import Foundation

final class Category: Model {

    static let schema = "categories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "emoji")
    var emoji: String

    @Field(key: "name")
    var name: String

    init() {}

    init(id: UUID? = nil, emoji: String, name: String) {
        self.id = id
        self.emoji = emoji
        self.name = name
    }
}

extension Category: Content {}
