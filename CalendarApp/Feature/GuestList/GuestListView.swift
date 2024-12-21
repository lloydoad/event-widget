//
//  AccountListView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct GuestListView: View {
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var appSessionStore: AppSessionStore
    let guests: [AccountModel]

    @StateObject private var viewModelsController = GuestViewModelsController()
    @State private var error: Error?

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    ListTitleView(title: "guest list")
                    ForEach(viewModelsController.viewModels) { viewModel in
                        GuestView(viewModel: viewModel)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .onAppear {
            setViewModels()
            viewModelsController.viewModels.forEach {
                refreshActions(viewModel: $0)
            }
        }
    }
    
    private func refreshActions(viewModel: GuestViewModel) {
        Task {
            do {
                try await viewModel.refreshAction()
            } catch {
                self.error = error
            }
        }
    }

    private func setViewModels() {
        viewModelsController.setViewModels(
            guests.map { guest in
                GuestViewModel(
                    dataStore: dataStoreProvider.dataStore,
                    appSessionStore: appSessionStore,
                    guest: guest
                )
            }
        )
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
