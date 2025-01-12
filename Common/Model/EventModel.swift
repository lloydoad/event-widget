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

    func isActive() -> Bool {
        endDate > .now
    }
}

extension EventModel {
    struct RealtimeCreateResponse: Codable {
        var event_id: UUID
        var location_id: UUID
    }

    struct RealtimeCreateRequest: Encodable {
        let p_event_id: UUID?
        let p_creator_id: UUID
        let p_description: String
        let p_start_date: Date
        let p_end_date: Date
        let p_address: String
        let p_city: String
        let p_state: String
        let p_guest_ids: [UUID]
    }

    var realtimeCreateRequest: RealtimeCreateRequest {
        RealtimeCreateRequest(
            p_event_id: nil,
            p_creator_id: creator.uuid,
            p_description: description,
            p_start_date: startDate,
            p_end_date: endDate,
            p_address: location.address,
            p_city: location.city,
            p_state: location.state,
            p_guest_ids: guests.map(\.uuid)
        )
    }
}

extension EventModel {
    struct Realtime: Codable {
        struct Guest: Codable {
            let guest: AccountModel.Realtime
        }

        let id: UUID
        let description: String
        let start_date: String
        let end_date: String
        let creator: AccountModel.Realtime
        let location: LocationModel.Realtime
        let guests: [Guest]
    }
}

extension EventModel.Realtime {
    func model() throws -> EventModel {
        let formatter = DateFormatter()
        return EventModel(
            uuid: id,
            creator: creator.model,
            description: description,
            startDate: try formatter.fromIso8601(start_date),
            endDate: try formatter.fromIso8601(end_date),
            location: location.model,
            guests: guests.map({ guest in
                guest.guest.model
            })
        )
    }
}
