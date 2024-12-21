//
//  MainView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var onboardingStore: OnboardingStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    
    var accountWorker: AccountWorking
    var eventWorker: EventWorking
    var contactSyncWorker: ContactSyncWorking
    
    @State private var navigationPagePath: [DeepLinkParser.Page] = []
    @State private var sheetPage: DeepLinkParser.Page?
    @State private var error: Error?
    
    private let deepLinkParser = DeepLinkParser()
    
    var body: some View {
        NavigationStack(path: $navigationPagePath) {
            if let userAccount = appSessionStore.userAccount {
                pageView(.events(userAccount))
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
        .errorAlert(error: $error)
        .tint(Color(AppColor.appTint.asUIColor))
        .environmentObject(appSessionStore)
        .environmentObject(onboardingStore)
        .environmentObject(dataStoreProvider)
    }
    
    func pageView(_ page: DeepLinkParser.Page) -> some View {
        switch page {
        case .events(let viewingAccount):
            return AnyView(EventListView(
                viewingAccount: viewingAccount,
                eventWorker: eventWorker,
                dataStore: dataStoreProvider.dataStore
            ))
        case .account(let model):
            return AnyView(AccountView(model: model))
        case .accounts(let model):
            return AnyView(AccountListView(model: model))
        case .subscriptions:
            return AnyView(SubscriptionsView(
                contactSyncWorker: contactSyncWorker,
                dataStore: dataStoreProvider.dataStore
            ))
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
            Task {
                do {
                    let newUserAccount = try await accountWorker
                        .createAccount(
                            username: username,
                            phoneNumber: phoneNumber
                        )
                    appSessionStore.userAccount = newUserAccount
                    onboardingStore.isPerformingActivity = false
                    onboardingStore.stage = .enterUsername
                } catch {
                    self.error = error
                    onboardingStore.isPerformingActivity = false
                }
            }
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
