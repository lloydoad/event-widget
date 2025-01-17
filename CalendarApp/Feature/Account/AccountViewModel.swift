//
//  GuestViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

import SwiftUI

class AccountViewModel: ObservableObject, Identifiable {
    var listIdentifier: String
    var transformer: AccountTransformer
    var dataStore: DataStoring?
    var appSessionStore: AppSessionStore?
    var account: AccountModel?

    @Published var content: AttributedString
    @Published var error: Error?

    // MARK: - Init

    init() {
        self.listIdentifier = ""
        self.transformer = AccountTransformer(listIdentifier: listIdentifier)
        self.content = ""
    }

    func configure(dataStore: DataStoring, appSessionStore: AppSessionStore, account: AccountModel, listIdentifier: String) {
        self.dataStore = dataStore
        self.appSessionStore = appSessionStore
        self.account = account
        self.transformer = AccountTransformer(listIdentifier: listIdentifier)
        self.content = transformer.transform(account: account, controlResult: .unknown)
        self.perform(control: .getSubscriptionStatus)
    }

    var currentTask: Task<Void, Never>?
    func perform(control: AccountControl) {
        guard let appSessionStore else { return }
        guard let dataStore else { return }
        guard let userAccount = appSessionStore.userAccount else { return }
        guard let account else { return }
        currentTask?.cancel()
        content = transformer.transform(account: account, controlResult: .unknown)
        currentTask = Task {
            do {
                let result = try await control.action(userAccount: userAccount, account: account, dataStore: dataStore)
                await MainActor.run {
                    content = transformer.transform(account: account, controlResult: result)
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
