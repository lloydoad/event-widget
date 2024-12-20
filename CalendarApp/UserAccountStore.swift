//
//  UserAccountStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/19/24.
//

import SwiftUI

class UserAccountStore: ObservableObject {
	@Published var account: AccountModel

	init(account: AccountModel) {
		self.account = account
	}

	convenience init() {
		let defaultAccount = AccountModel(
			uuid: UUID(),
			username: "",
			phoneNumber: "",
			subscriberIDs: []
		)
		self.init(account: defaultAccount)
	}

	func update(_ account: AccountModel) {
		self.account = account
	}
}
