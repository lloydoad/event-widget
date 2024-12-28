//
//  ErrorManager.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/25/24.
//

import SwiftUI

struct ErrorManager {
    static let appMessageKey = "AppMessageKey"
    static let loggedMessageKey = "LoggedMessageKey"
    static func with(loggedMessage: String, appMessage: String = "Please try again later") -> Error {
        NSError(domain: "", code: 0, userInfo: [
            loggedMessageKey: loggedMessage,
            appMessageKey: appMessage
        ])
    }
}
