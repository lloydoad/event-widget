//
//  AccountWorker.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

@MainActor
class AccountWorker {
    let accountStore: AccountStoring

    init(accountStore: AccountStoring) {
        self.accountStore = accountStore
    }

    private var accountCreationTask: Task<Void, Never>?
    func createAccount(
        username: String, phoneNumber: String,
        onSuccess: @escaping (AccountModel) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let account = AccountModel(uuid: UUID(), username: username, phoneNumber: phoneNumber)
        accountCreationTask?.cancel()
        accountCreationTask = Task { @MainActor in
            do {
                try await accountStore.save(account: account)
                if !Task.isCancelled {
                    onSuccess(account)
                }
            } catch {
                if !Task.isCancelled {
                    onError(error)
                }
            }
        }
    }

    private var getOnboardedContactsTask: Task<Void, Never>?
    func getOnboardedContacts(onSuccess: @escaping ([AccountModel]) -> Void, onError: @escaping (Error) -> Void) {
        getOnboardedContactsTask?.cancel()
        getOnboardedContactsTask = Task { @MainActor in
            do {
                let contacts = try await accountStore.getAccounts(with: [])
                if !Task.isCancelled {
                    onSuccess(contacts)
                }
            } catch {
                if !Task.isCancelled {
                    onError(error)
                }
            }
        }
    }
}
