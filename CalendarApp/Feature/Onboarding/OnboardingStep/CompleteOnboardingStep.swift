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

    func body(context: OnboardingContext) -> AnyView {
        AnyView(
            VStack(spacing: 8) {
                AttributedStringBuilder(baseStyle: .init(appFont: .large))
                    .primaryText("hello \(context.savedUsername ?? "")! saving your username and preferences ...")
                    .view()
                    .frame(maxWidth: .infinity, alignment: .leading)
                if context.isPerformingActivity {
                    HStack {
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .onAppear {
                context.isPerformingActivity = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    
//                }
            }
        )
    }

    func isApplicable(context: OnboardingContext) -> Bool {
        context.hasUsernameAndPhoneNumber && context.hasSyncedContacts
    }
}

#Preview("step 3") {
    OnboardingView()
        .environmentObject(OnboardingContext(completedSteps: [
            .username("lloydd"),
            .phoneNumber("301-367-1234"),
            .hasSyncedContacts
        ]))
}
