//
//  SupabaseColumn.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/28/24.
//

import Foundation
import Supabase

enum SupabaseColumn {
    case fullEvent
    case accountFromAppleID

    var stringValue: String {
        switch self {
        case .fullEvent:
            """
                id,
                description,
                start_date,
                end_date,
                creator:creator_id(id, username, phone_number),
                location:location_id(address, city, state),
                guests:event_guests(guest:guest_id(id, username, phone_number))
            """
        case .accountFromAppleID:
            """
            account:account_id (
                id,
                username,
                phone_number
            )
            """
        }
    }
}

extension PostgrestQueryBuilder {
    func select(
      _ supabaseColumn: SupabaseColumn,
      head: Bool = false,
      count: CountOption? = nil
    ) -> PostgrestFilterBuilder {
        return self.select(supabaseColumn.stringValue, head: head, count: count)
    }
}

extension PostgrestTransformBuilder {
    func select(_ supabaseColumn: SupabaseColumn) -> PostgrestTransformBuilder {
        self.select(supabaseColumn.stringValue)
    }
}
