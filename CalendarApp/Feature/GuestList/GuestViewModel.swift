//
//  GuestViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

import SwiftUI

@MainActor
class GuestViewModelsController: ObservableObject {
    @Published var viewModels: [GuestViewModel] = []

    func setViewModels(_ newViewModels: [GuestViewModel]) {
        viewModels = newViewModels
    }
}

@MainActor
class GuestViewModel: ObservableObject, Identifiable {
    let id: String
    var dataStore: DataStoring
    var appSessionStore: AppSessionStore
    var guest: AccountModel
    
    enum Action: Hashable {
        case loading
        case success(AttributedString)
    }

    @Published var content: AttributedString = ""
    @Published var actions: Action = .loading
    
    init(
        dataStore: DataStoring,
        appSessionStore: AppSessionStore,
        guest: AccountModel
    ) {
        self.id = guest.uuid.uuidString
        self.dataStore = dataStore
        self.appSessionStore = appSessionStore
        self.guest = guest
        refreshContent()
    }

    func refreshAction() async throws {
        guard let userAccount = appSessionStore.userAccount else { return }
        let following = try await dataStore.getFollowingAccounts(userAccount: userAccount)
        let accountControls = try ListItemView.Model.accountControls(
            viewer: userAccount,
            account: guest,
            following: following
        )
        actions = .success(accountControls)
    }

    private func refreshContent() {
        if let viewer = appSessionStore.userAccount {
            content = ListItemView.Model.accountContent(
                viewer: viewer,
                account: guest
            )
        }
    }
}
