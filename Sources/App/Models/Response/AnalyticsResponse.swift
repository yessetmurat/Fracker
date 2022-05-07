//
//  AnalyticsResponse.swift
//  
//
//  Created by Yesset Murat on 5/7/22.
//

import Vapor

struct AnalyticsResponse: Content {

    let total: Decimal
    let didRise: Bool?
    let percent: String?
    let categories: [AnalyticsCategoryResponse]
}

struct AnalyticsCategoryResponse: Content, Hashable {

    let id: UUID
    let emoji: String
    let name: String
    let recordsCount: Int
    let amount: Decimal
    let value: Float
}
