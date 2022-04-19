//
//  Record.swift
//  
//
//  Created by Yesset Murat on 4/19/22.
//

import Vapor
import Fluent
import Foundation

final class Record: Model {

    static let schema = "records"

    @ID(key: .id)
    var id: UUID?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Parent(key: "category")
    var category: Category

    @Field(key: "amount")
    var amount: Decimal

    init() {}

    init(id: UUID? = nil, createdAt: Date? = nil, category: Category.IDValue, amount: Decimal) {
        self.id = id
        self.createdAt = createdAt
        self.$category.id = category
        self.amount = amount
    }
}

extension Record: Content {}
