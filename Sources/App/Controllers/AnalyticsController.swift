//
//  AnalyticsController.swift
//  
//
//  Created by Yesset Murat on 5/7/22.
//

import Vapor
import Fluent
import Foundation

struct AnalyticsController {

    enum FilterType: String, Decodable { case week, month, year }

    func analytics(request: Request) async throws -> AnalyticsResponse {
        let user = try await request.user
        let filterType = try request.query.get(FilterType.self, at: "filter")
        let currentDate = Date()

        guard let date = toDate(for: filterType, date: currentDate),
              let previousDate = toDate(for: filterType, date: date) else {
            throw Abort(.badRequest, reason: "Unable to get date for \(filterType)")
        }

        let currentRecords = try await user.$records.query(on: request.db)
            .filter(\.$createdAt >= date)
            .filter(\.$createdAt <= currentDate)
            .with(\.$category)
            .all()

        let previousRecords = try await user.$records.query(on: request.db)
            .filter(\.$createdAt >= previousDate)
            .filter(\.$createdAt <= date)
            .with(\.$category)
            .all()

        let currentAmount = currentRecords.map { $0.amount }.reduce(0, +)
        let previousAmount = previousRecords.map { $0.amount }.reduce(0, +)

        var didRise: Bool?
        var percent: Decimal = 0

        if !previousAmount.isZero {
            didRise = currentAmount > previousAmount
            percent = ((currentAmount - previousAmount) / currentAmount) * 100
        }

        var categories: [AnalyticsCategoryResponse] = []

        for category in currentRecords.map({ $0.category }) {
            let records = try await category.$records.query(on: request.db)
                .filter(\.$createdAt >= date)
                .filter(\.$createdAt <= currentDate)
                .all()
            let amount = records.map { $0.amount }.reduce(0, +)

            let response = try AnalyticsCategoryResponse(
                id: category.requireID(),
                emoji: category.emoji,
                name: category.name,
                recordsCount: records.count,
                amount: amount,
                value: NSDecimalNumber(decimal: amount / currentAmount).floatValue
            )

            categories.append(response)
        }

        return AnalyticsResponse(
            total: currentAmount,
            didRise: didRise,
            percent: abs(percent).percent,
            categories: categories.unique.sorted(by: { $0.amount > $1.amount })
        )
    }

    private func toDate(for filter: FilterType, date: Date) -> Date? {
        let calendarComponent: Calendar.Component

        switch filter {
        case .week: calendarComponent = .weekOfMonth
        case .month: calendarComponent = .month
        case .year: calendarComponent = .year
        }

        guard let fromDate = Calendar.current.date(byAdding: calendarComponent, value: -1, to: date) else {
            return nil
        }
        return fromDate
    }
}

extension AnalyticsController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let group = routes
            .grouped("api", "analytics")
            .grouped(AuthorizationToken.authenticator(), AuthorizationToken.guardMiddleware())

        group.get(use: analytics)
    }
}
