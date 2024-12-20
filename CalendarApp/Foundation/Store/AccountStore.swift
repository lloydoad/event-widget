//
//  AccountStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

protocol AccountStoring {
    func save(account: AccountModel) async throws
    func getAccounts(with uuids: [UUID]) async throws -> [AccountModel]
    func findAccounts(with phoneNumbers: [String]) async throws -> [AccountModel]
}

class MockAccountStore: AccountStoring {
    enum StoreError: Error {
        case duplicateAccount
        case duplicatePhoneNumber
    }
    
    var accounts: [AccountModel] = [
        AccountModelMocks.nickAccount,
        AccountModelMocks.serenaAccount,
        AccountModelMocks.alanAccount,
    ]
    
    func save(account: AccountModel) async throws {
        try await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 second delay
        if accounts.contains(where: { $0.uuid == account.uuid }) {
            throw StoreError.duplicateAccount
        }
        if accounts.contains(where: { $0.phoneNumber == account.phoneNumber }) {
            throw StoreError.duplicatePhoneNumber
        }
        accounts.append(account)
    }
    
    func getAccounts(with uuids: [UUID]) async throws -> [AccountModel] {
        try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 second delay
        return accounts.compactMap { account in
            uuids.contains(account.uuid) ? account : nil
        }
    }
    
    func findAccounts(with phoneNumbers: [String]) async throws -> [AccountModel] {
        try await Task.sleep(nanoseconds: 3_500_000_000) // 3.5 second delay
        return accounts.filter { account in
            phoneNumbers.contains(account.phoneNumber)
        }
    }
}


