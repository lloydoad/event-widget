//
//  AccountControl.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 1/16/25.
//

import SwiftUI

enum AccountControl: Equatable, CaseIterable {
    case subscribe
    case unsubscribe
    case getSubscriptionStatus

    enum Result {
        case subscribed
        case notSubscribed
        case unknown
    }

    var title: String {
        switch self {
        case .subscribe:
            return "subscribe"
        case .unsubscribe:
            return "unsubscribe"
        case .getSubscriptionStatus:
            return "subscription status"
        }
    }

    @MainActor
    func action(userAccount: AccountModel, account: AccountModel, dataStore: DataStoring) async throws -> Result {
        switch self {
        case .subscribe:
            try await dataStore.follow(follower: userAccount, following: account)
            return .subscribed
        case .unsubscribe:
            try await dataStore.unfollow(follower: userAccount, following: account)
            return .notSubscribed
        case .getSubscriptionStatus:
            let isFollowing = try await dataStore.isFollowing(follower: userAccount, following: account)
            return isFollowing ? .subscribed : .notSubscribed
        }
    }

    func identifier(account: AccountModel, listIdentifier: String) -> String {
        let prefix: String = {
            switch self {
            case .subscribe:
                return ButtonIdentifier.accountSubscribeAction
            case .unsubscribe:
                return ButtonIdentifier.accountUnsubscribeAction
            case .getSubscriptionStatus:
                return ButtonIdentifier.subscriptionStatusAction
            }
        }()
        return prefix + "_" + account.uuid.uuidString + "_" + listIdentifier
    }
}

extension StringBuilder {
    func account(result: AccountControl.Result, account: AccountModel, listIdentifier: String) -> StringBuilder {
        switch result {
        case .subscribed:
            return self.account(control: .unsubscribe, account: account, listIdentifier: listIdentifier)
        case .notSubscribed:
            return self.account(control: .subscribe, account: account, listIdentifier: listIdentifier)
        case .unknown:
            return self.text(.colored("...", color: .appTint))
        }
    }

    private func account(control: AccountControl, account: AccountModel, listIdentifier: String) -> StringBuilder {
        action(.bracket(
            control.title,
            identifier: control.identifier(
                account: account,
                listIdentifier: listIdentifier
            ),
            color: .appTint,
            action: { }
        ))
    }
}
