//
//  Untitled.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    private var steps: [any OnboardingStep] = [
        UsernameOnboardingStep(),
        SyncContactsOnboardingStep(),
        PhoneNumberOnboardingStep(),
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
                    if step.isApplicable(store: onboardingStore) {
                        step.body(store: onboardingStore)
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
        .environmentObject(OnboardingStore())
}
