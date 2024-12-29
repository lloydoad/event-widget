//
//  Table.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/28/24.
//

import Supabase
import Foundation

extension SupabaseClient {
    enum Table: String {
        case apple_identifiers
        case accounts
        case follows
        case events
        case event_guests
        case locations
    }

    func from(_ table: Table) -> PostgrestQueryBuilder {
        return self.from(table.rawValue)
    }
}
