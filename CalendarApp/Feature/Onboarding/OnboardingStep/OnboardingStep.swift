//
//  OnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

enum OnboardingStepType: Hashable {
    case username
    case phoneNumber
}

protocol OnboardingStep {
    var stage: OnboardingStepType { get }
    func body(store: OnboardingStore) -> AnyView
    func isApplicable(store: OnboardingStore) -> Bool
}


