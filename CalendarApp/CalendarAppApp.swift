//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

@main
struct CalendarAppApp: App {
    @State private var navigationPagePath: [DeepLinkParser.Page] = []
    @State private var sheetPage: DeepLinkParser.Page?
	@State private var eventListModel: EventListView.Model = EventListView.Model(
		events: [
			try! .event(
				viewer: AccountModelMocks.lloydAccount,
				event: EventModelMocks.event(
					creator: AccountModelMocks.serenaAccount,
					description: "meditation at the SF Dharma collective. will be focused on emotions",
					startDate: DateFormatter().createDate(hour: 19, minute: 30)!,
					endDate: DateFormatter().createDate(hour: 21, minute: 30)!,
					guests: [
						AccountModelMocks.alanAccount,
						AccountModelMocks.lloydAccount,
						AccountModelMocks.ivoAccount
					]
				)
			),
			try! .event(
				viewer: AccountModelMocks.lloydAccount,
				event: EventModelMocks.event(
					creator: AccountModelMocks.nickAccount,
					description: "building lego till 8pm or later. idk",
					location: LocationModel(
						address: "1 haight st",
						city: "san francisco",
						state: "california"
					),
					startDate: DateFormatter().createDate(hour: 17, minute: 00)!,
					endDate: DateFormatter().createDate(hour: 21, minute: 00)!,
					guests: []
				)
			),
			try! .event(
				viewer: AccountModelMocks.lloydAccount,
				event: EventModelMocks.event(
					creator: AccountModelMocks.lloydAccount,
					description: "thinking about going to a comedy after work. open to ideas",
					location: LocationModel(
						address: "250 fell st",
						city: "san francisco",
						state: "california"
					),
					startDate: DateFormatter().createDate(hour: 12, minute: 00)!,
					endDate: DateFormatter().createDate(hour: 15, minute: 00)!,
					guests: []
				)
			),
			try! .event(
				viewer: AccountModelMocks.lloydAccount,
				event: EventModelMocks.event(
					creator: AccountModelMocks.nickAccount,
					description: "anyone down to smash 👀 (as-in nintendo smash)",
					location: LocationModel(
						address: "250 king st",
						city: "san francisco",
						state: "california"
					),
					startDate: DateFormatter().createDate(hour: 4, minute: 00)!,
					endDate: DateFormatter().createDate(hour: 7, minute: 00)!,
					guests: []
				)
			),
			try! .event(
				viewer: AccountModelMocks.lloydAccount,
				event: EventModelMocks.event(
					creator: AccountModelMocks.lloydAccount,
					description: "lets go around town and be spooky",
					location: LocationModel(
						address: "1 california st",
						city: "san francisco",
						state: "california"
					),
					startDate: DateFormatter().createDate(hour: 1, minute: 30)!,
					endDate: DateFormatter().createDate(hour: 4, minute: 15)!,
					guests: [AccountModelMocks.serenaAccount]
				)
			)
		],
		subscription: AccountListView.Model.init(
			variant: .subscriptions,
			accounts: [
				try! .account(
					viewer: AccountModelMocks.lloydAccount,
					account: AccountModelMocks.serenaAccount
				),
				try! .account(
					viewer: AccountModelMocks.lloydAccount,
					account: AccountModelMocks.ivoAccount
				)
			]
		))

	private let deepLinkParser = DeepLinkParser()

    var body: some Scene {
        WindowGroup {
			NavigationStack(path: $navigationPagePath) {
				EventListView(model: eventListModel)
                    .navigationDestination(for: DeepLinkParser.Page.self) { page in
                        pageView(page)
					}
                    .sheet(item: $sheetPage, content: { page in
                        pageView(page)
                    })
					.onOpenURL { url in
						if let route = deepLinkParser.getRoute(url: url) {
                            switch route {
                            case .action(let routeAction):
                                // handle some action
								break
                            case .push(let page):
                                navigationPagePath.append(page)
                            case .sheet(let page):
                                sheetPage = page
                            }
						}
					}
			}
			.tint(Color(AppColor.appTint.asUIColor))
			.environment(\.hasSyncedContacts, false)
			.environmentObject(UserAccountStore(
				account: AccountModelMocks.lloydAccount
			))
		}
    }
    
    func pageView(_ page: DeepLinkParser.Page) -> some View {
            switch page {
            case .events(let model):
                return AnyView(EventListView(model: model))
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
}
