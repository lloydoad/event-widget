//
//  PhoneNumberFormatter.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct PhoneNumberFormatter {
    func format(_ number: String) -> String {
        let digits = number.filter { $0.isNumber }
        var result = ""
        
        for (index, digit) in digits.enumerated() {
            if index == 0 {
                result.append("(")
            }
            if index == 3 {
                result.append(") ")
            }
            if index == 6 {
                result.append("-")
            }
            if index < 10 {
                result.append(digit)
            }
        }
        return result
    }

    func removeFormatting(_ number: String) -> String {
        number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }

    func isValid(_ number: String) -> Bool {
        let digits = number.filter { $0.isNumber }
        return digits.count == 10
    }
}
