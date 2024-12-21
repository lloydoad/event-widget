//
//  Untitled.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    @EnvironmentObject var actionCoordinator: AppActionCoordinator
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var appSessionStore: AppSessionStore

    private var steps: [any OnboardingStep] = [
        UsernameOnboardingStep(),
        PhoneNumberOnboardingStep(),
    ]

    init(accountWorker: AccountWorking) {
        self.accountWorker = accountWorker
    }
    
    var accountWorker: AccountWorking

    var body: some View {
        VStack(spacing: 16) {
            AttributedStringBuilder(baseStyle: .init(appFont: .navigationTitle))
                .primaryText("let's set up your account!")
                .view()
                .frame(maxWidth: .infinity, alignment: .leading)
            withAnimation(.easeInOut) {
                ForEach(steps, id: \.stage) { step in
                    if step.isApplicable(store: onboardingStore) {
                        step.body(store: onboardingStore)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            actionCoordinator.register(
                OnboardingAppActionHandler(
                    accountWorker: accountWorker,
                    appSessionStore: appSessionStore,
                    onboardingStore: onboardingStore,
                    dataStoreProvider: dataStoreProvider
                )
            )
        }
    }
}

#Preview("step 1") {
    @Previewable @State var dataStore: MockDataStore = MockDataStore(followings: [
        AccountModelMocks.lloydUUID: []
    ])
    OnboardingView(accountWorker: MockAccountWorker())
        .environmentObject(OnboardingStore())
        .environmentObject(mockAppSessionStore(account: AccountModelMocks.lloydAccount))
        .environmentObject(DataStoreProvider(dataStore: dataStore))
        .environmentObject(AppActionCoordinator())
}
