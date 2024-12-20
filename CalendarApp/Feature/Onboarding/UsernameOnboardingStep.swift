//
//  UsernameOnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct UsernameOnboardingStep: OnboardingStep {
    var stepType: OnboardingStepType { .username }

    func body(context: OnboardingContext) -> AnyView {
        return AnyView(
            VStack {
                TextField("enter a username", text: Binding(
                    get: {
                        context.usernameEntry
                    },
                    set: { newValue in
                        context.usernameEntry = newValue
                            .trimmingCharacters(in: .whitespaces)
                    }
                ))
                .font(AppFont.large.asFont)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                claimUsername(context: context)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
    }

    func claimUsername(context: OnboardingContext) -> Text {
        let builder = AttributedStringBuilder(baseStyle: .init(appFont: .light))
        if context.usernameEntry.count >= 3 {
            return try! builder
                .bracket("save username",
                         deeplink: .action(.saveUsernameToOnboardingContext(context.usernameEntry)),
                         color: .appTint)
                .view()
        } else {
            return builder
                .text(.init("name cannot be shorter than 3 characters",
                            segmentStyle: .init(underline: false, color: .secondary)))
                .view()
        }
    }

    func isApplicable(context: OnboardingContext) -> Bool {
        context.completedSteps.isEmpty
    }
}

#Preview("username step") {
    @Previewable @State var context = OnboardingContext()
    OnboardingView()
        .environmentObject(context)
}

#Preview("username step filled") {
    @Previewable @State var context = OnboardingContext(usernameEntry: "lloyd")
    OnboardingView()
        .environmentObject(context)
}
