//
//  EventModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct EventModel: Codable, Hashable, Equatable {
	let creator: AccountModel
	let description: String
	let startDate: Date
	let endDate: Date
	let location: LocationModel
	let guests: [AccountModel]
}

extension EventModel {
	func isGoing(viewer: AccountModel) -> Bool {
		guests.contains(viewer)
	}

	func joinable(viewer: AccountModel) -> Bool {
		!isGoing(viewer: viewer) && viewer != creator && endDate > .now
	}

	func cancellable(viewer: AccountModel) -> Bool {
		isGoing(viewer: viewer) && endDate > .now
	}

	func deletable(viewer: AccountModel) -> Bool {
		creator == viewer
	}
}

struct EventModelMocks {
	static func event(
		creator: AccountModel,
		description: String = "building lego till 8 or later. I'm not sure",
		location: LocationModel = LocationModel(
			address: "235 Valencia St",
			city: "San Francisco",
			state: "California"
		),
		startDate: Date = .now,
		endDate: Date = .now,
		guests: [AccountModel] = [
			AccountModelMocks.nickAccount,
			AccountModelMocks.alanAccount,
			AccountModelMocks.serenaAccount,
			AccountModelMocks.catAccount
		]
	) -> EventModel {
		EventModel(
			creator: creator,
			description: description,
			startDate: startDate,
			endDate: endDate,
			location: location,
			guests: guests
		)
	}
}
