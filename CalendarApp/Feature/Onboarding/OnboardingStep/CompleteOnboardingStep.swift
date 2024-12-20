//
//  CompleteOnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct CompleteOnboardingStep: OnboardingStep {
    var stepType: OnboardingStepType {
        .complete
    }

    func body(store: OnboardingStore) -> AnyView {
        AnyView(
            VStack(spacing: 8) {
                AttributedStringBuilder(baseStyle: .init(appFont: .large))
                    .primaryText("hello \(store.savedUsername ?? "")! saving your username and preferences ...")
                    .view()
                    .frame(maxWidth: .infinity, alignment: .leading)
                if store.isPerformingActivity {
                    HStack {
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .onAppear {
                store.isPerformingActivity = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    
//                }
            }
        )
    }

    func isApplicable(store: OnboardingStore) -> Bool {
        store.hasUsernameAndPhoneNumber && store.hasSyncedContacts
    }
}

#Preview("step 3") {
    OnboardingView()
        .environmentObject(OnboardingStore(completedSteps: [
            .username("lloydd"),
            .phoneNumber("301-367-1234"),
            .hasSyncedContacts
        ]))
}
