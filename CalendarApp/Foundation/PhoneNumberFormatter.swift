//
//  PhoneNumberFormatter.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

class PhoneNumberFormatter {
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
    
    func isValid(_ number: String) -> Bool {
        let digits = number.filter { $0.isNumber }
        return digits.count == 10
    }
}
