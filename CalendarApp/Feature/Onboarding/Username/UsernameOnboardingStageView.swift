//
//  UsernameOnboardingStageView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/26/24.
//

import SwiftUI

struct UsernameOnboardingStageView: View {
    @EnvironmentObject var context: OnboardingContext
    @State private var entryText: String = ""

    private let claimUsernameActionUUID = UUID()

    var body: some View {
        VStack(spacing: 8) {
            TextField("enter a username", text: $entryText)
            .font(AppFont.large.asFont)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            if entryText.count >= 3 {
                ButtonView(
                    title: "save username",
                    identifier: claimUsernameActionUUID.uuidString,
                    font: .light,
                    action: {
                        context.savedUsername = entryText
                        context.stageIdentifier = PhoneNumberOnboardingStage.identifier
                    })
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                StringBuilder(baseStyle: .init(appFont: .large))
                    .text(.secondary("name cannot be shorter than 3 characters"))
                    .view()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
            }
        }
    }
}

#Preview("step 1") {
    @Previewable @State var dataStore: MockDataStore = MockDataStore(followings: [
        AccountModelMocks.lloydUUID: []
    ])
    OnboardingView()
        .environmentObject(OnboardingContext(stageIdentifier: UsernameOnboardingStage.identifier))
        .environmentObject(mockAppSessionStore(account: AccountModelMocks.lloydAccount))
        .environmentObject(DataStoreProvider(dataStore: dataStore))
}

