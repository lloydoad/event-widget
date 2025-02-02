//
//  MainView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appSessionStore: AppSessionStore

    var contactSyncWorker: ContactSyncWorking

    @State private var navigationPagePath: [DeepLinkParser.Page] = []
    @State private var sheetPage: DeepLinkParser.Page?
    @State private var error: Error?
    @State private var onboardingContext = OnboardingContext(
        stageIdentifier: AppleAuthOnboardingStage.identifier)

    private let deepLinkParser = DeepLinkParser()

    var body: some View {
        NavigationStack(path: $navigationPagePath) {
            if appSessionStore.userAccount != nil {
                pageView(.feed)
                    .navigationDestination(for: DeepLinkParser.Page.self) { page in
                        pageView(page)
                    }
            } else {
                OnboardingView()
                    .environmentObject(onboardingContext)
            }
        }
        .sheet(item: $sheetPage, content: { page in
            pageView(page)
        })
        .onOpenURL { url in
            if let route = deepLinkParser.getRoute(url: url) {
                switch route {
                case .push(let page):
                    navigationPagePath.append(page)
                case .sheet(let page):
                    sheetPage = page
                }
            } else {
                ActionCentralDispatch.shared.handle(url: url)
            }
        }
        .errorAlert(error: $error)
        .tint(Color(AppColor.appTint.asUIColor))
    }

    func pageView(_ page: DeepLinkParser.Page) -> some View {
        switch page {
        case .feed:
            return AnyView(HomeFeedView())
        case .profile(let account):
            return AnyView(ProfileView(account: account))
        case .guestList(let guests):
            return AnyView(GuestListView(guests: guests))
        case .subscriptions:
            return AnyView(SubscriptionsView(
                contactSyncWorker: contactSyncWorker
            ))
        case .composer(let event):
            return AnyView(ComposerView(
                shouldUpdate: event != nil,
                eventID: event?.uuid ?? .init(),
                description: event?.description ?? "",
                startDate: event?.startDate ?? .now,
                endDate: event?.endDate ?? .now,
                location: event?.location
            ))
        }
    }
}
