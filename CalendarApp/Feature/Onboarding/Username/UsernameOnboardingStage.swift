//
//  UsernameOnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct UsernameOnboardingStage: OnboardingStage {
    var identifier: String {
        Self.identifier
    }

    static var identifier: String {
        "enter_username"
    }

    private let claimUsernameActionUUID = UUID()
    @State private var entryText: String = ""

    func body(context: OnboardingContext) -> AnyView {
        AnyView(
            UsernameOnboardingStageView()
                .environmentObject(context)
        )
    }

    func isApplicable(context: OnboardingContext) -> Bool {
        context.stageIdentifier == Self.identifier && context.savedUsername == nil
    }
}
