//
//  AppSessionStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class AppSessionStore: ObservableObject {
	@Published private(set) var userAccount: AccountModel?
    @Published private(set) var hasSyncedContacts: Bool = false
    
    var hasOnboarded: Bool {
        userAccount != nil
    }

    func updateUserAccount(_ account: AccountModel) {
        self.userAccount = account
    }
    
    func updateHasSyncedContacts(_ hasSyncedContacts: Bool) {
        self.hasSyncedContacts = hasSyncedContacts
    }
}


func mockAppSessionStore(account: AccountModel = AccountModelMocks.lloydAccount, hasSyncedContacts: Bool = false) -> AppSessionStore {
    let store = AppSessionStore()
    store.updateUserAccount(account)
    store.updateHasSyncedContacts(hasSyncedContacts)
    return store
}
