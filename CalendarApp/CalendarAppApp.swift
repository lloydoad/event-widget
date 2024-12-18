//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

@main
struct CalendarAppApp: App {
	@State private var path: [DeepLinkParser.Route] = []
	@State private var eventListModel: EventListView.Model = EventListView.Model(events: [
		try! EventListItemView.Model(
			viewer: AccountModelMocks.lloydAccount,
			event: EventModelMocks.event(
				creator: AccountModelMocks.serenaAccount,
				description: "meditation at the SF Dharma collective. will be focused on emotions",
				guests: [
					AccountModelMocks.alanAccount,
					AccountModelMocks.lloydAccount,
					AccountModelMocks.ivoAccount
				]
			)
		),
		try! EventListItemView.Model(
			viewer: AccountModelMocks.lloydAccount,
			event: EventModelMocks.event(
				creator: AccountModelMocks.nickAccount,
				description: "building lego till 8pm or later. idk",
				guests: [
					AccountModelMocks.lloydAccount,
				]
			)
		),
		try! EventListItemView.Model(
			viewer: AccountModelMocks.lloydAccount,
			event: EventModelMocks.event(
				creator: AccountModelMocks.lloydAccount,
				description: "thinking about going to a comedy after work. open to ideas",
				guests: []
			)
		),
		try! EventListItemView.Model(
			viewer: AccountModelMocks.lloydAccount,
			event: EventModelMocks.event(
				creator: AccountModelMocks.nickAccount,
				description: "anyone down to smash 👀 (as-in nintendo smash)",
				guests: []
			)
		)
	])
	private let deepLinkParser = DeepLinkParser()

    var body: some Scene {
        WindowGroup {
			NavigationStack(path: $path) {
				EventListView(model: eventListModel)
					.navigationDestination(for: DeepLinkParser.Route.self) { route in
						switch route {
						case .events(let model):
							EventListView(model: model)
						case .account(let model):
							Text("Account: \(model.username)")
						case .eventGuests(let model):
							Text("Event guests: \(model.count)")
						case .subscriptions:
							Text("Subscriptions")
						case .composeEvent:
							Text("composeEvent")
						}
					}
					.onOpenURL { url in
						if let route = deepLinkParser.getRoute(url: url) {
							path.append(route)
						}
					}
			}
		}
    }
}
