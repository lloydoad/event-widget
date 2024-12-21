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

class PhoneNumberOnboardingStep: OnboardingStep {
    private let formatter = PhoneNumberFormatter()
    
    var stage: OnboardingStepType {
        .phoneNumber
    }

    func body(store: OnboardingStore) -> AnyView {
        return AnyView(
            VStack(spacing: 8) {
                PhoneNumberField(formatter: formatter, text: Binding(
                    get: {
                        store.entryText
                    },
                    set: { newValue in
                        store.entryText = newValue
                    }
                ))
                if formatter.isValid(store.entryText) {
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
                                     deeplink: .action(
                                        .createAccount(
                                            username: username(store: store),
                                            phoneNumber: store.entryText)
                                     ),
                                     color: .appTint)
                            .view()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        )
    }

    func isApplicable(store: OnboardingStore) -> Bool {
        switch store.stage {
        case .enterPhoneNumber:
            return true
        default:
            return false
        }
    }
    
    func username(store: OnboardingStore) -> String {
        switch store.stage {
        case .enterPhoneNumber(username: let username):
            return username
        default:
            return ""
        }
    }
}

#Preview("phone number entry") {
    OnboardingView()
        .environmentObject(OnboardingStore(
            stage: .enterPhoneNumber(username: "lloyd"),
            entryText: ""
        ))
}

#Preview("phone number entry filled") {
    OnboardingView()
        .environmentObject(OnboardingStore(
            stage: .enterPhoneNumber(username: "lloyd"),
            entryText: "301-367-8901"
        ))
}

#Preview("phone number entry filled") {
    OnboardingView()
        .environmentObject(OnboardingStore(
            stage: .enterPhoneNumber(username: "lloyd"),
            entryText: "301-367-8901",
            isPerformingActivity: true)
        )
}
