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
}
