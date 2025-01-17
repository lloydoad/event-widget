//
//  GuestView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @EnvironmentObject var appSessionStore: AppSessionStore

    var listIdentifier: String
    var account: AccountModel

    @StateObject private var viewModel: AccountViewModel = .init()

    var body: some View {
        Text(viewModel.content)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .systemBackground))
            .transition(.blurReplace)
            .animation(.easeInOut, value: viewModel.content)
            .onAppear {
                registerActions()
                viewModel.configure(
                    dataStore: dataStoreProvider.dataStore,
                    appSessionStore: appSessionStore,
                    account: account,
                    listIdentifier: listIdentifier
                )
            }
            .onDisappear {
                unregisterActions()
            }
    }

    private func registerActions() {
        for control in AccountControl.allCases {
            ActionCentralDispatch
                .shared
                .register(
                    identifier: control.identifier(account: account, listIdentifier: listIdentifier),
                    action: {
                        viewModel.perform(control: control)
                    }
                )
        }
    }

    private func unregisterActions() {
        for control in AccountControl.allCases {
            ActionCentralDispatch
                .shared
                .deregister(
                    identifier: control.identifier(account: account, listIdentifier: listIdentifier)
                )
        }
    }
}
