//
//  UsernameOnboardingStep.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct UsernameOnboardingStep: OnboardingStep {
    var stage: OnboardingStepType {
        .username
    }

    let claimUsernameActionUUID = UUID()

    func body(store: OnboardingStore) -> AnyView {
        return AnyView(
            VStack(spacing: 4) {
                TextField("enter a username", text: Binding(
                    get: {
                        store.entryText
                    },
                    set: { newValue in
                        store.entryText = newValue
                            .trimmingCharacters(in: .whitespaces)
                    }
                ))
                .font(AppFont.large.asFont)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                if store.entryText.count >= 3 {
                    ButtonView(
                        title: "save username",
                        identifier: claimUsernameActionUUID.uuidString,
                        font: .light,
                        action: {
                            store.entryText = ""
                            store.stage = .enterPhoneNumber(
                                username: store.entryText
                            )
                        })
                    .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    StringBuilder(baseStyle: .init(appFont: .light))
                        .text(.init("name cannot be shorter than 3 characters",
                                    segmentStyle: .init(underline: false, color: .secondary)))
                        .view()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        )
    }

    func isApplicable(store: OnboardingStore) -> Bool {
        switch store.stage {
        case .enterUsername:
            true
        default:
            false
        }
    }
}

//#Preview("username step") {
//    @Previewable @State var store = OnboardingStore(stage: .enterUsername)
//    OnboardingView()
//        .environmentObject(store)
//}
//
//#Preview("username step filled") {
//    @Previewable @State var store = OnboardingStore(stage: .enterUsername, entryText: "lloydd")
//    OnboardingView()
//        .environmentObject(store)
//}
