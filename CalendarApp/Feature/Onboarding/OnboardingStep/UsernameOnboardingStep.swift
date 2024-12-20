//
//  UsernameOnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct UsernameOnboardingStep: OnboardingStep {
    var stepType: OnboardingStepType {
        .username
    }

    func body(store: OnboardingStore) -> AnyView {
        return AnyView(
            VStack(spacing: 4) {
                TextField("enter a username", text: Binding(
                    get: {
                        store.usernameEntry
                    },
                    set: { newValue in
                        store.usernameEntry = newValue
                            .trimmingCharacters(in: .whitespaces)
                    }
                ))
                .font(AppFont.large.asFont)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                claimUsername(store: store)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
    }

    func claimUsername(store: OnboardingStore) -> Text {
        let builder = AttributedStringBuilder(baseStyle: .init(appFont: .light))
        if store.usernameEntry.count >= 3 {
            return try! builder
                .bracket("save username",
                         deeplink: .action(.saveUsernameToOnboardingContext(store.usernameEntry)),
                         color: .appTint)
                .view()
        } else {
            return builder
                .text(.init("name cannot be shorter than 3 characters",
                            segmentStyle: .init(underline: false, color: .secondary)))
                .view()
        }
    }

    func isApplicable(store: OnboardingStore) -> Bool {
        store.completedSteps.isEmpty
    }
}

#Preview("username step") {
    @Previewable @State var store = OnboardingStore()
    OnboardingView()
        .environmentObject(store)
}

#Preview("username step filled") {
    @Previewable @State var store = OnboardingStore(usernameEntry: "lloyd")
    OnboardingView()
        .environmentObject(store)
}
