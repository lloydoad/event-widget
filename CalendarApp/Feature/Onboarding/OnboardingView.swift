//
//  Untitled.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var context: OnboardingContext
    @State private var title: String = ""

    private var stages: [any OnboardingStage] = [
        AppleAuthOnboardingStage(),
        AccountMappingStage(),
        UsernameOnboardingStage(),
        PhoneNumberOnboardingStage()
    ]

    var body: some View {
        VStack(spacing: 16) {
            ListTitleView(title: title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.blurReplace)
            ForEach(stages, id: \.identifier) { stage in
                if stage.isApplicable(context: context) {
                    stage.body(context: context)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.blurReplace)
                        .onAppear {
                            title = stage.personalizedTitle ?? ""
                        }
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
