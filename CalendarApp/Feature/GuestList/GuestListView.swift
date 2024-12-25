//
//  AccountListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct GuestListView: View {
    let guests: [AccountModel]

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    ListTitleView(title: "guest list")
                    ForEach(guests.sorted(), id: \.uuid) { guest in
                        AccountView(account: guest)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

#Preview("following 2 accounts") {
    GuestListView(guests: [
        AccountModelMocks.alanAccount,
        AccountModelMocks.serenaAccount,
        AccountModelMocks.ivoAccount
    ])
    .environmentObject(mockAppSessionStore(account: AccountModelMocks.lloydAccount))
    .environmentObject(DataStoreProvider(dataStore: MockDataStore(followings: [
        AccountModelMocks.lloydUUID: [AccountModelMocks.serenaUUID, AccountModelMocks.ivoUUID]
    ])))
}

#Preview("following 0 accounts") {
    GuestListView(guests: [
        AccountModelMocks.alanAccount,
        AccountModelMocks.serenaAccount,
        AccountModelMocks.ivoAccount
    ])
    .environmentObject(mockAppSessionStore(account: AccountModelMocks.lloydAccount))
    .environmentObject(DataStoreProvider(dataStore: MockDataStore(followings: [
        AccountModelMocks.lloydUUID: []
    ])))
}

#Preview("following all accounts") {
    GuestListView(guests: [
        AccountModelMocks.alanAccount,
        AccountModelMocks.serenaAccount,
        AccountModelMocks.ivoAccount
    ])
    .environmentObject(mockAppSessionStore(account: AccountModelMocks.lloydAccount))
    .environmentObject(DataStoreProvider(dataStore: MockDataStore(followings: [
        AccountModelMocks.lloydUUID: [AccountModelMocks.serenaUUID, AccountModelMocks.ivoUUID, AccountModelMocks.nickUUID, AccountModelMocks.alanUUID]
    ])))
}
