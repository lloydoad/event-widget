//
//  AccountModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct AccountModel: Codable, Hashable, Equatable {
	var uuid: UUID
	var username: String
	var phoneNumber: String
	var subscriberIDs: [UUID]
}

extension AccountModel {
	func isSubscriber(viewer: AccountModel) -> Bool {
		subscriberIDs.contains(viewer.uuid)
	}
}

class UserAccountStore: ObservableObject {
	// @Published will trigger view updates when the account changes
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


struct AccountModelMocks {
	static let alanUUID = UUID()
	static let serenaUUID = UUID()
	static let nickUUID = UUID()
	static let catUUID = UUID()
	static let lloydUUID = UUID()
	static let ivoUUID = UUID()
	
	static let nickAccount = AccountModel(
		uuid: nickUUID,
		username: "nick",
		phoneNumber: "301-367-6761",
		subscriberIDs: [alanUUID, serenaUUID]
	)
	static let alanAccount = AccountModel(
		uuid: alanUUID,
		username: "alan",
		phoneNumber: "301-367-6761",
		subscriberIDs: [nickUUID, serenaUUID]
	)
	static let serenaAccount = AccountModel(
		uuid: serenaUUID,
		username: "serena",
		phoneNumber: "301-367-6761",
		subscriberIDs: [ivoUUID, catUUID, lloydUUID]
	)
	static let catAccount = AccountModel(
		uuid: catUUID,
		username: "cat",
		phoneNumber: "301-367-6761",
		subscriberIDs: [nickUUID, lloydUUID]
	)
	static let lloydAccount = AccountModel(
		uuid: lloydUUID,
		username: "lloyd",
		phoneNumber: "301-367-6761",
		subscriberIDs: [catUUID]
	)
	static let ivoAccount = AccountModel(
		uuid: ivoUUID,
		username: "ivo",
		phoneNumber: "301-367-6761",
		subscriberIDs: [alanUUID]
	)
}

