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

    enum FilterType: String, Decodable {

        case day, week, month, year

        func title(for request: Request) -> String {
            switch self {
            case .day: return "Analytics.day".localized(for: request)
            case .week: return "Analytics.week".localized(for: request)
            case .month: return "Analytics.month".localized(for: request)
            case .year: return "Analytics.year".localized(for: request)
            }
        }
    }

    func analytics(request: Request) async throws -> AnalyticsResponse {
        let filterType = try request.query.get(FilterType.self, at: "filter")
        let currentDate = Date()
        let fromDate: Date?
        let calendarComponent: Calendar.Component

        switch filterType {
        case .day:
            fromDate = currentDate.startOfDay
            calendarComponent = .day
        case .week:
            fromDate = currentDate.startOfWeek
            calendarComponent = .weekOfMonth
        case .month:
            fromDate = currentDate.startOfMonth
            calendarComponent = .month
        case .year:
            fromDate = currentDate.startOfYear
            calendarComponent = .year
        }

        guard let fromDate = fromDate, let previousDate = fromDate.previous(calendarComponent) else {
            throw Abort(.badRequest, reason: Reason.dateError(filterType: filterType).description(for: request))
        }

        let currentRecords = try await records(for: request, fromDate: fromDate, toDate: currentDate)
        let previousRecords = try await records(for: request, fromDate: previousDate, toDate: fromDate)

        let currentAmount = currentRecords.map { $0.amount }.reduce(0, +)
        let previousAmount = previousRecords.map { $0.amount }.reduce(0, +)

        var didRise: Bool?
        var percent: Decimal = 0

        if !previousAmount.isZero {
            didRise = currentAmount > previousAmount
            percent = ((currentAmount - previousAmount) / currentAmount) * 100
        }

        var categories: [AnalyticsCategoryResponse] = []

        for record in currentRecords {
            guard let category = try await record.$category.query(on: request.db).withDeleted().first() else {
                continue
            }

            let records = try await category.$records.query(on: request.db)
                .filter(\.$createdAt >= fromDate)
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

    private func records(for request: Request, fromDate: Date, toDate: Date) async throws -> [Record] {
        return try await request.user.$records.query(on: request.db)
            .filter(\.$createdAt >= fromDate)
            .filter(\.$createdAt <= toDate)
            .all()
    }
}

extension AnalyticsController {

    enum Reason: ReasonProtocol {

        case dateError(filterType: FilterType)

        func description(for request: Request) -> String {
            switch self {
            case .dateError(let filterType):
                return "Analytics.dateError".localized(for: request) + " \'" + filterType.title(for: request) + "\'"
            }
        }
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
