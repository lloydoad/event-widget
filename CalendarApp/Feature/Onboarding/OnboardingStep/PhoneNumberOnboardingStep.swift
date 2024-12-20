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

    func body(context: OnboardingContext) -> AnyView {
        return AnyView(
            VStack(spacing: 8) {
                PhoneNumberField(formatter: formatter, text: Binding(
                    get: {
                        context.phoneNumberEntry
                    },
                    set: { newValue in
                        context.phoneNumberEntry = newValue
                    }
                ))
                if formatter.isValid(context.phoneNumberEntry) {
                    AttributedStringBuilder(baseStyle: .init(appFont: .large))
                        .bracket("save number",
                                 fallbackURL: URL(string: "www.apple.com")!,
                                 deeplink: .action(.savePhoneNumberToOnboardingContext(context.phoneNumberEntry)),
                                 color: .appTint)
                        .view()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        )
    }

    func isApplicable(context: OnboardingContext) -> Bool {
        context.hasUsername && !context.hasPhoneNumber
    }
}

#Preview("phone number entry") {
    OnboardingView()
        .environmentObject(OnboardingContext(
            completedSteps: [.username("lloyd")]
        ))
}

#Preview("phone number entry filled") {
    OnboardingView()
        .environmentObject(OnboardingContext(
            completedSteps: [.username("lloyd")],
            phoneNumberEntry: "(301) 234-5678")
        )
}
