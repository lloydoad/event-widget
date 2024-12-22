//
//  AppAction.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

enum AppAction: Codable, Hashable {
    case join
    case cantGo
    case delete
    case subscribe
    case unsubscribe
    case invite
    case markOnboardingComplete
    case claimUsername(username: String)
    case createAccount(username: String, phoneNumber: String)
    case syncContacts

    var defaultTitle: String {
        switch self {
        case .join:
            return "join"
        case .cantGo:
            return "can't go"
        case .delete:
            return "delete"
        case .subscribe:
            return "subscribe"
        case .unsubscribe:
            return "unsubscribe"
        case .invite:
            return "invite"
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
