//
//  EventModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct EventModel {
	let creator: AccountModel
	let description: String
	let startDate: Date
	let endDate: Date
	let location: String
	let guests: [AccountModel]
}

extension EventModel {
	func isGoing(guest: AccountModel) -> Bool {
		guests.contains(guest)
	}

	func joinable(guest: AccountModel) -> Bool {
		!isGoing(guest: guest) && guest != creator
	}

	func cancellable(guest: AccountModel) -> Bool {
		isGoing(guest: guest)
	}

	func deletable(guest: AccountModel) -> Bool {
		creator == guest
	}
}

struct EventModelMocks {
	static func event(
		creator: AccountModel,
		guests: [AccountModel] = [
			AccountModelMocks.nickAccount,
			AccountModelMocks.alanAccount,
			AccountModelMocks.serenaAccount,
			AccountModelMocks.catAccount
		]
	) -> EventModel {
		EventModel(
			creator: creator,
			description: "building lego till 8 or later. I'm not sure",
			startDate: .now,
			endDate: .now,
			location: "235 Valencia St",
			guests: guests
		)
	}
}
