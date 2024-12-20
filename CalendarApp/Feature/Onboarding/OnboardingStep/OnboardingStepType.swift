//
//  OnboardingStepType.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import Foundation

enum OnboardingStepType {
    case username
    case phoneNumber
    case syncContacts
    case complete
}

enum OnboardingStepComplete: Equatable {
    case username(String)
    case phoneNumber(String)
    case hasSyncedContacts
}

