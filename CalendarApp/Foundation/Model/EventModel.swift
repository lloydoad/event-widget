//
//  EventModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct EventModel: Codable, Hashable, Equatable {
    var uuid: UUID
    var creator: AccountModel
    var description: String
    var startDate: Date
    var endDate: Date
    var location: LocationModel
    var guests: [AccountModel]
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
