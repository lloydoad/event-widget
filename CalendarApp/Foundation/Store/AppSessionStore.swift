//
//  AppSessionStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class AppSessionStore: ObservableObject {
    @Published var userAccount: AccountModel? //= AccountModelMocks.lloydAccount
    @Published var hasSyncedContacts: Bool = false

    enum UserDefaultKeys: String {
        case userAccount
    }

    init(userAccount: AccountModel? = AppSessionStore.getUserAccountFromDefaults()) {
        self.userAccount = userAccount
    }

    func storeUserAccountToDefaults() {
        UserDefaults.standard.set(userAccount?.toPlistDictionary(),
                                  forKey: UserDefaultKeys.userAccount.rawValue)
    }

    static func getUserAccountFromDefaults() -> AccountModel? {
        guard
            let data = UserDefaults
                .standard
                .object(forKey: UserDefaultKeys.userAccount.rawValue) as? [String: Any]
        else {
            return nil
        }
        return AccountModel.fromPlistDictionary(data)
    }
}

func mockAppSessionStore(account: AccountModel? = AccountModelMocks.lloydAccount, hasSyncedContacts: Bool = false) -> AppSessionStore {
    let store = AppSessionStore()
    store.userAccount = account
    store.hasSyncedContacts = hasSyncedContacts
    return store
}
