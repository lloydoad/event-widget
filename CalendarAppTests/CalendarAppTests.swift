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
        let datastore = try SupabaseDataStore()
        let testAccount = AccountModel(uuid: UUID(), username: "agatha", phoneNumber: "9119119191")
        try await datastore.create(account: testAccount, identifier: "agatha-all-along-disney")
    }

}
