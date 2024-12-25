//
//  GuestViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/21/24.
//

import SwiftUI

class AccountViewModel: ObservableObject, Identifiable {
    enum Control: Equatable, Identifiable {
        case subscription
        case profile(identifier: UUID)

        var id: String {
            switch self {
            case .subscription: return "subscription"
            case .profile(identifier: let identifier): return identifier.uuidString
            }
        }
    }

    enum ControlState: Equatable {
        case enable([Control])
        case disabled
    }

    private let profileActionUUID: UUID = UUID()

    var id: String
    var dataStore: DataStoring?
    var appSessionStore: AppSessionStore?
    var account: AccountModel?

    @Published var content: AttributedString
    @Published var controls: ControlState
    @Published var subscriptionButtonType: SubscriptionButtonView.ButtonType = .loading
    @Published var error: Error?

    // MARK: - Init

    init() {
        self.id = UUID().uuidString
        self.content = ""
        self.controls = .disabled
    }

    func configure(dataStore: DataStoring, appSessionStore: AppSessionStore, account: AccountModel) {
        self.id = account.uuid.uuidString
        self.dataStore = dataStore
        self.appSessionStore = appSessionStore
        self.account = account
        self.content = Self.getContent(account: account, appSessionStore: appSessionStore)
        self.controls = .enable(Self.getControls(account: account, appSessionStore: appSessionStore, profileActionUUID: profileActionUUID))
        self.updateSubscriptionStatus()
    }

    var currentTask: Task<Void, Never>?
    func updateSubscriptionStatus() {
        guard let appSessionStore else { return }
        guard let dataStore else { return }
        guard let userAccount = appSessionStore.userAccount else { return }
        guard let account else { return }
        currentTask?.cancel()
        self.subscriptionButtonType = .loading
        currentTask = Task {
            do {
                let following = try await dataStore.getFollowingAccounts(userAccount: userAccount)
                await MainActor.run {
                    if following.contains(account.uuid) {
                        self.subscriptionButtonType = .unsubscribe
                    } else {
                        self.subscriptionButtonType = .subscribe
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }

    // MARK: - Content Builders

    static func getControls(account: AccountModel, appSessionStore: AppSessionStore, profileActionUUID: UUID) -> [Control] {
        guard let userAccount = appSessionStore.userAccount else { return [] }
        var controls: [Control] = [.profile(identifier: profileActionUUID)]
        if account != userAccount {
            controls.append(.subscription)
        }
        return controls
    }

    static func getContent(account: AccountModel, appSessionStore: AppSessionStore) -> AttributedString {
        guard let userAccount = appSessionStore.userAccount else { return "" }
        return ListItemView.Model.accountContent(
            viewer: userAccount,
            account: account
        )
    }
}
