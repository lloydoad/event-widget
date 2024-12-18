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
	@State private var eventListModel: EventListView.Model = EventListView.Model(eventRows: [
		viewModel(guest: catAccount),
		viewModel(guest: ivoAccount)
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
