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

    func body(store: OnboardingStore) -> AnyView {
        let builder = AttributedStringBuilder(baseStyle: .init(appFont: .large))
        if store.isPerformingActivity {
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

    func isApplicable(store: OnboardingStore) -> Bool {
        store.hasUsernameAndPhoneNumber && !store.hasSyncedContacts
    }
}

#Preview("sync contacts") {
    OnboardingView()
        .environmentObject(OnboardingStore(
            completedSteps: [.username("lloyd"), .phoneNumber("301-555-1234")]
        ))
}

#Preview("sync contacts - network request") {
    OnboardingView()
        .environmentObject(OnboardingStore(
            completedSteps: [
                .username("lloyd"),
                .phoneNumber("301-555-1234")
            ],
            isPerformingActivity: true
        ))
}

