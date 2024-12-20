//
//  SyncContactsOnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI
import Contacts

struct SyncContactsOnboardingStep: OnboardingStep {
    var stepType: OnboardingStepType {
        .syncContacts
    }

    func body(context: OnboardingContext) -> AnyView {
        let builder = AttributedStringBuilder(baseStyle: .init(appFont: .large))
        if context.isPerformingActivity {
            builder
                .primaryText("syncing contacts...")
        } else {
            builder
                .bracket("sync contacts",
                         fallbackURL: URL(string: "www.apple.com")!,
                         deeplink: .action(.syncContacts),
                         color: .appTint)
                .primaryText(" to enable you to see events from friends")
        }
        return AnyView(
            VStack {
                builder
                    .view()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
    }

    func isApplicable(context: OnboardingContext) -> Bool {
        context.hasUsername && !context.hasSyncedContacts
    }
}

#Preview("sync contacts") {
    OnboardingView()
        .environmentObject(OnboardingContext(
            completedSteps: [.username("lloyd")]
        ))
}

#Preview("sync contacts - network request") {
    OnboardingView()
        .environmentObject(OnboardingContext(
            completedSteps: [
                .username("lloyd")
            ],
            isPerformingActivity: true
        ))
}

