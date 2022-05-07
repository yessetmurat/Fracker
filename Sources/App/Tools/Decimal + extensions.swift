//
//  Decimal + extensions.swift
//  
//
//  Created by Yesset Murat on 5/8/22.
//

import Foundation

extension Decimal {

    var percent: String {
        let string = String(format: "%.2f", NSDecimalNumber(decimal: self).doubleValue)
        let integerDigits = string.components(separatedBy: ".").first ?? ""
        var fractionDigits = string.components(separatedBy: ".").last ?? ""

        while fractionDigits.last == "0" { fractionDigits.removeLast() }

        if fractionDigits.isEmpty {
            return integerDigits + "%"
        } else {
            return [integerDigits, fractionDigits].joined(separator: ".") + "%"
        }
    }
}
