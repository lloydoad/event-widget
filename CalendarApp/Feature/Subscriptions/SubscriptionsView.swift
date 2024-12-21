//
//  SubscriptionsView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct SubscriptionsView: View {
    private enum Model {
        case success([ListItemView.Model])
        case loading
    }
    
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var appSessionStore: AppSessionStore
    let contactSyncWorker: ContactSyncWorking
    
    @State private var model: Model = .loading
    @State private var error: Error?

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    ListTitleView(title: "subscriptions")
                    switch model {
                    case .success(let accounts):
                        if accounts.isEmpty {
                            AttributedStringBuilder(baseStyle: .init(appFont: .light))
                                .primaryText("looks like your contacts aren't here yet\n")
                                .bracket(
                                    "send invites",
                                    fallbackURL: DeepLinkParser.Route.fallbackURL,
                                    deeplink: .action(.invite),
                                    color: .appTint)
                                .view()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ForEach(accounts, id: \.hashValue) { account in
                                ListItemView(model: account)
                                    .padding(.bottom, 4)
                            }
                        }
                    case .loading:
                        ZStack {
                            ProgressView()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
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
    
    private func fetchFollowingAccounts(viewer: AccountModel) async {
        do {
            let contacts = try await contactSyncWorker.sync()
            let dataStore = dataStoreProvider.dataStore
            let following = try await dataStore.getFollowingAccounts(userAccount: viewer)
            let accounts = try await dataStore.getAccounts(with: contacts.map(\.phoneNumber), and: following)

            model = try .success(accounts.map({ account in
                try ListItemView.Model.account(viewer: viewer, account: account, following: following)
            }))
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
