//
//  AppSessionStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import Foundation

class AppSessionStore: ObservableObject {
    @Published var userAccount: AccountModel? //= AccountModelMocks.lloydAccount

    enum UserDefaultKeys: String {
        case userAccount
    }

    static var sharedDefaults: UserDefaults = {
        let appDefaults = UserDefaults(suiteName: "group.shared-defaults.dapaah.lloyd.CalendarApp")
        if let appDefaults {
            UserDefaults.standard.dictionaryRepresentation().forEach {
                appDefaults.set($0.value, forKey: $0.key)
            }
        }
        return appDefaults ?? .standard
    }()

    init(userAccount: AccountModel? = AppSessionStore.getUserAccountFromDefaults()) {
        self.userAccount = userAccount
    }

    func storeUserAccountToDefaults() {
        Self.sharedDefaults.set(userAccount?.toPlistDictionary(), forKey: UserDefaultKeys.userAccount.rawValue)
    }

    static func getUserAccountFromDefaults() -> AccountModel? {
        guard
            let data = sharedDefaults.object(forKey: UserDefaultKeys.userAccount.rawValue) as? [String: Any]
        else {
            return nil
        }
        return AccountModel.fromPlistDictionary(data)
    }
}

func mockAppSessionStore(account: AccountModel? = AccountModelMocks.lloydAccount) -> AppSessionStore {
    let store = AppSessionStore()
    store.userAccount = account
    return store
}
