//
//  Untitled.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var onboardingContext: OnboardingContext
    private var steps: [any OnboardingStep] = [
        UsernameOnboardingStep(),
        SyncContactsOnboardingStep(),
        CompleteOnboardingStep()
    ]

    var body: some View {
        VStack(spacing: 16) {
            AttributedStringBuilder(baseStyle: .init(appFont: .navigationTitle))
                .primaryText("let's set up your account!")
                .view()
                .frame(maxWidth: .infinity, alignment: .leading)
            withAnimation(.easeInOut) {
                ForEach(steps, id: \.stepType) { step in
                    if step.isApplicable(context: onboardingContext) {
                        step.body(context: onboardingContext)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview("step 1") {
    OnboardingView()
        .environmentObject(OnboardingContext())
}
#Preview("step 3") {
    OnboardingView()
        .environmentObject(OnboardingContext(completedSteps: [.username("lloydd"), .hasSyncedContacts]))
}
