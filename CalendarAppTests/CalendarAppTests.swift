//
//  CalendarAppTests.swift
//  CalendarAppTests
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Testing
@testable import CalendarApp
import Supabase
import Foundation

struct CalendarAppTests {

    @Test func example() async throws {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String
        let apiUrl = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String

        print(apiKey, apiUrl)
//        let dataStore = SupabaseDataStore()
//        let formatter = PhoneNumberFormatter()
//        print(formatter.format("3333333333"))
//        print(formatter.removeFormatting("(333) 333-3333"))
//        print(formatter.removeFormatting("(333)-333-3333"))
//        print(formatter.removeFormatting("(333)-333-3333"))
//        print(formatter.removeFormatting("333-333-3333"))
//        let accounts = try await dataStore.getAccounts(
//            with: ["(333)-333-3333"],
//            and: [UUID(uuidString: "daae79a4-27fc-485a-9fe2-ef95b8b43498")!]
//        )
//        let event = EventModelMocks.event(
//            creator: accounts.last!,
//            description: "building lego till 8pm or later. idk",
//            location: LocationModel(
//                address: "2360 sutter street",
//                city: "san francisco",
//                state: "california"
//            ),
//            startDate: DateFormatter().createDate(day: 30, hour: 17, minute: 00)!,
//            endDate: DateFormatter().createDate(day: 30, hour: 21, minute: 00)!,
//            guests: []
//        )
//
//        let created_event = try await dataStore.create(event: event)
//        try await dataStore.deleteEvent(
//            creator: AccountModel(uuid: UUID(uuidString: "daae79a4-27fc-485a-9fe2-ef95b8b43498")!,
//                                username: "",
//                                phoneNumber: ""),
//            event: EventModel(uuid: UUID(uuidString: "36fc09c2-1a0a-490e-83f2-563f1c93a9da")!,
//                              creator: AccountModel(uuid: .init(), username: "", phoneNumber: ""),
//                              description: "",
//                              startDate: .now,
//                              endDate: .now,
//                              location: LocationModel(address: "", city: "", state: ""),
//                              guests: [])
//        )

//        let account = AccountModel(uuid: UUID(uuidString: "daae79a4-27fc-485a-9fe2-ef95b8b43498")!,
//                                   username: "",
//                                   phoneNumber: "")
//        let events = try await dataStore.getEventFeed(viewing: account)
//        print(events)
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.

//        let account = AccountModel(uuid: UUID(uuidString: "02d18736-dc16-40db-8dc4-17df57345cfe")!,
//                                   username: "shadymccoy",
//                                   phoneNumber: "(321)-909-9090")
//        let accountTwo = AccountModel(uuid: UUID(),
//                                      username: "kelce",
//                                      phoneNumber: "(111)-222-3333")
//        try await dataStore.create(account: accountTwo)
//        try await dataStore.follow(follower: accountTwo, following: account)
    }

}
