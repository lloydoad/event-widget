//
//  AccountWorker.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

@MainActor
protocol AccountWorking {
    func createAccount(username: String, phoneNumber: String) async throws -> AccountModel
}

struct MockAccountWorker: AccountWorking {
    var createdAccount: AccountModel = AccountModelMocks.lloydAccount

    func createAccount(username: String, phoneNumber: String) async throws -> AccountModel {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
        return createdAccount
    }
}

@MainActor
class AccountWorker: AccountWorking {
    let dataStore: DataStoring

    init(dataStore: DataStoring) {
        self.dataStore = dataStore
    }

    private var createAccountTask: Task<AccountModel, Error>?
    func createAccount(username: String, phoneNumber: String) async throws -> AccountModel {
        createAccountTask?.cancel()
        let task = Task { @MainActor in
            let account = AccountModel(uuid: UUID(), username: username, phoneNumber: phoneNumber)
            try await dataStore.save(account: account)
            return account
        }
        createAccountTask = task
        return try await task.value
    }
}
