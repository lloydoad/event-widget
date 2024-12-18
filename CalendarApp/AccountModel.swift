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
}

struct AccountModelMocks {
	static let nickAccount = AccountModel(uuid: .init(), username: "nick", phoneNumber: "301-367-6761")
	static let alanAccount = AccountModel(uuid: .init(), username: "alan", phoneNumber: "301-367-6761")
	static let serenaAccount = AccountModel(uuid: .init(), username: "serena", phoneNumber: "301-367-6761")
	static let catAccount = AccountModel(uuid: .init(), username: "cat", phoneNumber: "301-367-6761")
	static let lloydAccount = AccountModel(uuid: .init(), username: "lloyd", phoneNumber: "301-367-6761")
	static let ivoAccount = AccountModel(uuid: .init(), username: "ivo", phoneNumber: "301-367-6761")
}
