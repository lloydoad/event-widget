//
//  OnboardingStepType.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import Foundation

enum OnboardingStage: Equatable {
    case enterUsername
    case enterPhoneNumber(username: String)
}

