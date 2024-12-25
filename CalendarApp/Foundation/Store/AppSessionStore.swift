//
//  AppSessionStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class AppSessionStore: ObservableObject {
    @Published var userAccount: AccountModel? = AccountModelMocks.lloydAccount
    @Published var hasSyncedContacts: Bool = false
}

func mockAppSessionStore(account: AccountModel = AccountModelMocks.lloydAccount, hasSyncedContacts: Bool = false) -> AppSessionStore {
    let store = AppSessionStore()
    store.userAccount = account
    store.hasSyncedContacts = hasSyncedContacts
    return store
}
