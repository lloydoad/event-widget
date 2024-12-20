//
//  OnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

protocol OnboardingStep {
    var stepType: OnboardingStepType { get }
    func body(store: OnboardingStore) -> AnyView
    func isApplicable(store: OnboardingStore) -> Bool
}


