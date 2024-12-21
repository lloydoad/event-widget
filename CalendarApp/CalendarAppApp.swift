//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

@main
struct CalendarAppApp: App {
    @StateObject private var appSessionStore = AppSessionStore()
    @StateObject private var onboardingStore = OnboardingStore()
    
    private let contactSyncWorker = ContactSyncWorker()
    private let accountWorker = AccountWorker(dataStore: MockDataStore()) // TODO: Replace with network store
    private let eventWorker = EventWorker(dataStore: MockDataStore()) // TODO: Replace with network store
    
    @State private var navigationPagePath: [DeepLinkParser.Page] = []
    @State private var sheetPage: DeepLinkParser.Page?
    @State private var errorMessage: String?
    @State private var isPresentingError: Bool = false

	private let deepLinkParser = DeepLinkParser()

    var body: some Scene {
        WindowGroup {
			NavigationStack(path: $navigationPagePath) {
                if let userAccount = appSessionStore.userAccount {
                    EventListView(viewingAccount: userAccount, eventWorker: eventWorker)
                        .navigationDestination(for: DeepLinkParser.Page.self) { page in
                            pageView(page)
                        }
                } else {
                    OnboardingView()
                }
			}
            .sheet(item: $sheetPage, content: { page in
                pageView(page)
            })
            .onOpenURL { url in
                if let route = deepLinkParser.getRoute(url: url) {
                    switch route {
                    case .action(let action):
                        handleAction(action)
                    case .push(let page):
                        navigationPagePath.append(page)
                    case .sheet(let page):
                        sheetPage = page
                    }
                }
            }
            .alert(errorMessage ?? "something went wrong", isPresented: $isPresentingError, actions: {
                Button("OK", role: .cancel) { }
            })
			.tint(Color(AppColor.appTint.asUIColor))
            .environmentObject(appSessionStore)
            .environmentObject(onboardingStore)
		}
    }

    func pageView(_ page: DeepLinkParser.Page) -> some View {
        switch page {
        case .events(let viewingAccount):
            return AnyView(EventListView(viewingAccount: viewingAccount, eventWorker: eventWorker))
        case .account(let model):
            return AnyView(AccountView(model: model))
        case .accounts(let model):
            return AnyView(AccountListView(model: model))
        case .subscriptions(let model):
            return AnyView(AccountListView(model: model))
        case .composer:
            return AnyView(ComposerView())
        }
    }
    
    func handleAction(_ action: DeepLinkParser.RouteAction) {
        switch action {
        case .join:
            break
        case .cantGo:
            break
        case .delete:
            break
        case .subscribe:
            break
        case .unsubscribe:
            break
        case .invite:
            break
        case .markOnboardingComplete:
            break
        case .claimUsername(username: let username):
            onboardingStore.entryText = ""
            onboardingStore.stage = .enterPhoneNumber(username: username)
        case .createAccount(username: let username, phoneNumber: let phoneNumber):
            onboardingStore.isPerformingActivity = true
            accountWorker.createAccount(
                username: username,
                phoneNumber: phoneNumber,
                onSuccess: { newUserAccount in
                    appSessionStore.userAccount = newUserAccount
                    onboardingStore.isPerformingActivity = false
                    onboardingStore.stage = .enterUsername
                }, onError: { error in
                    errorMessage = error.localizedDescription
                    isPresentingError = true
                    onboardingStore.isPerformingActivity = false
                })
        case .syncContacts:
            break
//            onboardingStore.isPerformingActivity = true
//            contactSyncWorker.sync(
//                onSuccess: { contacts in
//                    print(contacts)
//                    onboardingStore.isPerformingActivity = false
//                    onboardingStore.completedSteps.append(.hasSyncedContacts)
//                },
//                onError: { error in
//                    errorMessage = error.localizedDescription
//                    isPresentingError = true
//                    onboardingStore.isPerformingActivity = false
//                })
        }
    }
}
