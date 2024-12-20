//
//  PhoneNumberOnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct PhoneNumberField: View {
    var formatter: PhoneNumberFormatter
    @Binding var text: String
    
    var body: some View {
        TextField("enter phone number", text: $text)
            .keyboardType(.phonePad)
            .font(AppFont.large.asFont)
            .onChange(of: text, { _, newValue in
                let formatted = formatter.format(newValue)
                if formatted != newValue {
                    text = formatted
                }
            })
    }
}

struct PhoneNumberOnboardingStep: OnboardingStep {
    private let formatter = PhoneNumberFormatter()
    
    var stepType: OnboardingStepType {
        .phoneNumber
    }

    func body(store: OnboardingStore) -> AnyView {
        return AnyView(
            VStack(spacing: 8) {
                PhoneNumberField(formatter: formatter, text: Binding(
                    get: {
                        store.phoneNumberEntry
                    },
                    set: { newValue in
                        store.phoneNumberEntry = newValue
                    }
                ))
                if formatter.isValid(store.phoneNumberEntry) {
                    if store.isPerformingActivity {
                        HStack {
                            ProgressView()
                            AttributedStringBuilder(baseStyle: .init(appFont: .large))
                                .primaryText("creating account ")
                                .view()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        AttributedStringBuilder(baseStyle: .init(appFont: .large))
                            .bracket("create account",
                                     fallbackURL: DeepLinkParser.Route.fallbackURL,
                                     deeplink: .action(.savePhoneNumberToOnboardingContext(store.phoneNumberEntry)),
                                     color: .appTint)
                            .view()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }
            }
        )
    }

    func isApplicable(store: OnboardingStore) -> Bool {
        store.hasUsername && !store.hasPhoneNumber
    }
}

#Preview("phone number entry") {
    OnboardingView()
        .environmentObject(OnboardingStore(
            completedSteps: [.username("lloyd")]
        ))
}

#Preview("phone number entry filled") {
    OnboardingView()
        .environmentObject(OnboardingStore(
            completedSteps: [.username("lloyd")],
            phoneNumberEntry: "(301) 234-5678")
        )
}

#Preview("phone number entry filled") {
    OnboardingView()
        .environmentObject(OnboardingStore(
            completedSteps: [.username("lloyd")],
            phoneNumberEntry: "(301) 234-5678",
            isPerformingActivity: true
        ))
}
