//
//  OnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

protocol OnboardingStep {
    var stepType: OnboardingStepType { get }
    func body(context: OnboardingContext) -> AnyView
    func isApplicable(context: OnboardingContext) -> Bool
}

struct CompleteOnboardingStep: OnboardingStep {
    var stepType: OnboardingStepType {
        .complete
    }

    func body(context: OnboardingContext) -> AnyView {
        do {
            return try AnyView(AttributedStringBuilder(baseStyle: .init(appFont: .large))
                .bracket("go to events", deeplink: .action(.markOnboardingComplete), color: .appTint)
                .primaryText("!")
                .view()
                .frame(maxWidth: .infinity, alignment: .leading)
            )
        } catch {
            return AnyView(AttributedStringBuilder(baseStyle: .init(appFont: .large))
                .primaryText("Something went wrong. Please try again")
                .view()
                .frame(maxWidth: .infinity, alignment: .leading)
            )
        }
    }
    
    func isApplicable(context: OnboardingContext) -> Bool {
        (
            context.completedSteps.contains(.username(context.usernameEntry)) &&
            context.completedSteps.contains(.hasSyncedContacts)
        )
    }
}
