//
//  SupabaseDataStore.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/26/24.
//

import SwiftUI
import Supabase

class SupabaseDataStore: DataStoring {
    private let client: SupabaseClient

    init() throws {
        guard
            let key = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_KEY") as? String,
            !key.isEmpty
        else {
            throw ErrorManager.with(loggedMessage: "Server Key not found")
        }
        guard
            let urlValue = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let url = URL(string: urlValue),
            url.host != nil
        else {
            throw ErrorManager.with(loggedMessage: "Server URL not found")
        }
        client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }

    func getAccount(appleUserIdentifier: String) async throws -> AccountModel? {
        struct SelectResponse: Codable {
            let account: AccountModel.Realtime
        }
        let response: [SelectResponse] = try await client
            .from(.apple_identifiers)
            .select(.accountFromAppleID)
            .eq("apple_id", value: appleUserIdentifier)
            .execute()
            .value
        return response.first?.account.model
    }

    func create(account: AccountModel, identifier: String) async throws {
        try await client
            .rpc("create_account_with_apple", params: account.realtimeCreateRequest(identifier: identifier))
            .execute()
    }

    func create(event: EventModel) async throws -> EventModel {
        let response: EventModel.RealtimeCreateResponse = try await client
            .rpc("create_event", params: event.realtimeCreateRequest)
            .single()
            .execute()
            .value
        var createdEvent = event
        createdEvent.uuid = response.event_id
        return createdEvent
    }

    func joinEvent(guest account: AccountModel, event: EventModel) async throws {
        struct RealtimeEventGuest: Codable {
            var event_id: UUID
            var guest_id: UUID
        }
        try await client
            .from(.event_guests)
            .insert(RealtimeEventGuest(event_id: event.uuid, guest_id: account.uuid))
            .execute()
    }

    func leaveEvent(guest account: AccountModel, event: EventModel) async throws {
        try await client
            .from(.event_guests)
            .delete()
            .eq("event_id", value: event.uuid)
            .eq("guest_id", value: account.uuid)
            .execute()
    }

    func deleteEvent(creator account: AccountModel, event: EventModel) async throws {
        try await client
            .from(.events)
            .delete()
            .eq("id", value: event.uuid)
            .eq("creator_id", value: account.uuid)
            .execute()
    }

    func getEventFeed(viewing account: AccountModel) async throws -> [EventModel] {
        let params = ["p_viewer_id": account.uuid]
        let response: [EventModel.Realtime] = try await client
            .rpc("get_events_feed", params: params)
            .execute()
            .value
        return try response.map { try $0.model() }
    }

    func getEvents(creator account: AccountModel) async throws -> [EventModel] {
        let response: [EventModel.Realtime] = try await client
            .from(.events)
            .select(.fullEvent)
            .eq("creator_id", value: account.uuid)
            .order("end_date", ascending: false)
            .execute()
            .value
        return try response.map { try $0.model() }
    }

    func getEvent(uuid: UUID) async throws -> EventModel? {
        let response: EventModel.Realtime = try await client
            .from(.events)
            .select(.fullEvent)
            .eq("id", value: uuid)
            .single()
            .execute()
            .value
        return try response.model()
    }

    func getSubscriptionFeed(viewer: AccountModel, localPhoneNumbers: [String]) async throws -> [AccountModel] {
        struct Params: Codable {
            var p_phone_numbers: [String]
            var p_follower_id: UUID
        }
        let formatter = PhoneNumberFormatter()
        let response: [AccountModel.Realtime] = try await client
            .rpc("get_accounts_by_phone_or_follower", params: Params(
                p_phone_numbers: localPhoneNumbers.map { formatter.removeFormatting($0) },
                p_follower_id: viewer.uuid
            ))
            .execute()
            .value
        return response.map { $0.model }.sorted()
    }

    struct RealtimeFollow: Codable {
        var follower_id: UUID
        var following_id: UUID
    }

    func isFollowing(follower: AccountModel, following: AccountModel) async throws -> Bool {
        let response: [RealtimeFollow] = try await client
            .from(.follows)
            .select()
            .eq("follower_id", value: follower.uuid)
            .eq("following_id", value: following.uuid)
            .execute()
            .value
        return !response.isEmpty
    }

    func follow(follower: AccountModel, following: AccountModel) async throws {
        try await client
            .from(.follows)
            .insert(RealtimeFollow(
                follower_id: follower.uuid,
                following_id: following.uuid
            ))
            .execute()
    }

    func unfollow(follower: AccountModel, following: AccountModel) async throws {
        try await client
            .from(.follows)
            .delete()
            .eq("follower_id", value: follower.uuid)
            .eq("following_id", value: following.uuid)
            .execute()
    }
}

