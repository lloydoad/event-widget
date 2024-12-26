//
//  PhoneNumberOnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct PhoneNumberOnboardingStage: OnboardingStage {
    static var identifier: String {
        "enter_phone_number"
    }

    var identifier: String {
        Self.identifier
    }

    func body(context: OnboardingContext) -> AnyView {
        AnyView(
            PhoneNumberOnboardingStageView()
                .environmentObject(context)
        )
    }

    func isApplicable(context: OnboardingContext) -> Bool {
        context.stageIdentifier == Self.identifier && context.savedUsername != nil
    }
}
