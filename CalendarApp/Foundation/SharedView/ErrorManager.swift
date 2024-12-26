//
//  ErrorManager.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/25/24.
//

import SwiftUI

struct ErrorManager {
    static func with(message: String) -> Error {
        NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
