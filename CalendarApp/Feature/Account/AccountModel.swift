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
	static let alanUUID = UUID()
	static let serenaUUID = UUID()
	static let nickUUID = UUID()
	static let catUUID = UUID()
	static let lloydUUID = UUID()
	static let ivoUUID = UUID()
	
	static let nickAccount = AccountModel(
		uuid: nickUUID,
		username: "nick",
		phoneNumber: "(555) 564-8583"
	)
	static let alanAccount = AccountModel(
		uuid: alanUUID,
		username: "alan",
		phoneNumber: "555-478-7672"
	)
	static let serenaAccount = AccountModel(
		uuid: serenaUUID,
		username: "serena",
		phoneNumber: "301-367-6763"
	)
	static let catAccount = AccountModel(
		uuid: catUUID,
		username: "cat",
		phoneNumber: "(555) 766-4823"
	)
	static let lloydAccount = AccountModel(
		uuid: lloydUUID,
		username: "lloyd",
		phoneNumber: "301-367-6765"
	)
	static let ivoAccount = AccountModel(
		uuid: ivoUUID,
		username: "ivo",
		phoneNumber: "301-367-6766"
	)
}

