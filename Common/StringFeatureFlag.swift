//
//  FeatureFlags.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 1/18/25.
//

enum StringFeatureFlag: String {
    case appName
    case appStoreLink

    var defaultValue: String {
        switch self {
        case .appName:
            return "Hey.Social"
        case .appStoreLink:
            return "https://testflight.apple.com/join/J5u3gjg9"
        }
    }
}
