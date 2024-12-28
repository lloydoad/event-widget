//
//  Untitled.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var context: OnboardingContext

    private var stages: [any OnboardingStage] = [
        AppleAuthOnboardingStage(),
        UsernameOnboardingStage(),
        PhoneNumberOnboardingStage()
    ]

    var body: some View {
        VStack(spacing: 16) {
            ListTitleView(title: "let's set up your account")
                .frame(maxWidth: .infinity, alignment: .leading)
            ForEach(stages, id: \.identifier) { stage in
                if stage.isApplicable(context: context) {
                    stage.body(context: context)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.blurReplace)
                }
            }
        }
        .animation(.easeInOut, value: context.stageIdentifier)
        .padding()
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
