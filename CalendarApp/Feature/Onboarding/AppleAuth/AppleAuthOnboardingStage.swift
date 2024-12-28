//
//  AppleAuthOnboardingStage.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/28/24.
//

import SwiftUI

struct AppleAuthOnboardingStage: OnboardingStage {
    static var identifier: String {
        "sign_in_with_apple"
    }

    var identifier: String {
        Self.identifier
    }

    func body(context: OnboardingContext) -> AnyView {
        AnyView(
            AppleAuthOnboardingStageView()
                .environmentObject(context)
        )
    }

    func isApplicable(context: OnboardingContext) -> Bool {
        context.stageIdentifier == Self.identifier && context.userIdentifier == nil
    }
}
