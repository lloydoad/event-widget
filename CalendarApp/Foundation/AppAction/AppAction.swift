//
//  AppAction.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

enum AppAction: Codable, Hashable {
    case markOnboardingComplete
    case claimUsername(username: String)
    case createAccount(username: String, phoneNumber: String)
    case syncContacts

    var defaultTitle: String {
        switch self {
        case .markOnboardingComplete:
            return "complete onboarding"
        case .claimUsername:
            return "claim username"
        case .createAccount:
            return "create account"
        case .syncContacts:
            return "sync contacts"
        }
    }
}
