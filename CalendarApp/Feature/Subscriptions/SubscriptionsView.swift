//
//  SubscriptionsView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI
import Contacts

struct SubscriptionsView: View {
    private enum Model: Equatable {
        case success([AccountModel])
        case loading
    }
    
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var appSessionStore: AppSessionStore
    let contactSyncWorker: ContactSyncWorking
    private let listIdentifier: String = "subscriptionsList"

    @State private var model: Model = .loading
    @State private var error: Error?

    var body: some View {
        VStack {
            ListTitleView(title: "subscriptions")
            ScrollView {
                VStack(spacing: 16) {
                    switch model {
                    case .success(let accounts):
                        if accounts.isEmpty {
                            StringBuilder(baseStyle: .init(appFont: .light))
                                .text(.primary("looks like your contacts aren't here yet"))
                                .view()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.blurReplace)
                            if
                                let appName = appSessionStore.featureFlags["app_name"],
                                let appStoreLink = appSessionStore.featureFlags["appstore_link"] {
                                ShareLink(
                                    items: [
                                        URL(string: appStoreLink) ?? URL(string: "www.apple.com")!
                                    ],
                                    message: Text("let's share impromptu events on [\(appName)]"),
                                    label: {
                                    StringBuilder(baseStyle: .init(appFont: .light))
                                        .text(.init("[send invites]",
                                                    segmentStyle: .init(color: .appTint)))
                                        .view()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .transition(.blurReplace)
                                    })
                            }
                        } else {
                            ForEach(accounts, id: \.hashValue.description) { account in
                                AccountView(listIdentifier: listIdentifier, account: account)
                            }
                            .transition(.blurReplace)
                        }
                    case .loading:
                        ZStack {
                            ProgressView()
                        }
                        .transition(.blurReplace)
                    }
                }
                .frame(maxWidth: .infinity)
                .animation(.easeInOut, value: model)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .errorAlert(error: $error)
        .onAppear {
            Task {
                if let userAccount = appSessionStore.userAccount {
                    await fetchFollowingAccounts(viewer: userAccount)
                }
            }
        }
    }

    private func getContacts() async -> [Contact] {
        do {
            return try await contactSyncWorker.sync()
        } catch {
            Task { @MainActor in
                self.error = error
            }
            return []
        }
    }

    private func fetchFollowingAccounts(viewer: AccountModel) async {
        do {
            let contacts = await getContacts()
            let dataStore = dataStoreProvider.dataStore
            let accounts = try await dataStore
                .getSubscriptionFeed(viewer: viewer, localPhoneNumbers: contacts.map(\.phoneNumber))
                .sorted()
            model = .success(accounts)
        } catch {

            self.error = error
        }
    }
}

#Preview("some accounts") {
    @Previewable @State var dataStore: MockDataStore = MockDataStore(followings: [
        AccountModelMocks.lloydUUID: [AccountModelMocks.nickUUID, AccountModelMocks.ivoUUID]
    ])
    SubscriptionsView(
        contactSyncWorker: MockContactSyncWorker(contacts: [
            Contact(phoneNumber: AccountModelMocks.nickAccount.phoneNumber),
            Contact(phoneNumber: AccountModelMocks.serenaAccount.phoneNumber),
            Contact(phoneNumber: AccountModelMocks.catAccount.phoneNumber)
        ])
    )
    .environmentObject(mockAppSessionStore(account: AccountModelMocks.lloydAccount))
    .environmentObject(DataStoreProvider(dataStore: dataStore))
}

#Preview("no accounts - contacts synced") {
    @Previewable @State var dataStore: MockDataStore = MockDataStore(followings: [
        AccountModelMocks.lloydUUID: []
    ])
    SubscriptionsView(
        contactSyncWorker: MockContactSyncWorker(contacts: [])
    )
    .environmentObject(mockAppSessionStore(account: AccountModelMocks.lloydAccount))
    .environmentObject(DataStoreProvider(dataStore: dataStore))
}
