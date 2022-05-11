//
//  Date + extensions.swift
//  
//
//  Created by Yesset Murat on 5/11/22.
//

import Foundation

extension Calendar {

    static let iso8601 = Calendar(identifier: .iso8601)
}

extension Date {

    var startOfDay: Date? {
        return Calendar.iso8601.startOfDay(for: self)
    }

    var startOfWeek: Date? {
        return Calendar.iso8601.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date
    }

    var startOfMonth: Date? {
        return Calendar.iso8601.dateComponents([.calendar, .year, .month], from: self).date
    }

    var startOfYear: Date? {
        return Calendar.iso8601.dateComponents([.calendar, .year], from: self).date
    }

    func previous(_ component: Calendar.Component) -> Date? {
        return Calendar.iso8601.date(byAdding: component, value: -1, to: self)
    }
}
