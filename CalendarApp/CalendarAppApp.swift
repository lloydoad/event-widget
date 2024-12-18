//
//  CalendarAppApp.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import SwiftUI

struct DeepLinkParser {
	enum Route: Hashable {
		case events(EventListView.Model)
		case account
		case subscription
	}

	func getRoute(url: URL) -> Route? {
		let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
		guard let host = components?.host else { return nil }
		print(components, host, components?.queryItems, components?.scheme, components?.path)
		return nil
	}
}

@main
struct CalendarAppApp: App {
	@State private var path = NavigationPath()
	@State private var eventListModel: EventListView.Model = EventListView.Model(eventRows: [
		viewModel(guest: "cat"),
		viewModel(guest: "unknown")
	])
	private let deepLinkParser = DeepLinkParser()

    var body: some Scene {
        WindowGroup {
			NavigationStack(path: $path, root: {
				EventListView(model: eventListModel)
					.navigationDestination(for: DeepLinkParser.Route.self) { route in
						switch route {
						case .events(let model):
							EventListView(model: model)
						case .account:
							Text("Account")
						case .subscription:
							Text("Subscriptions")
						}
					}
			})
			.onOpenURL { url in
				print(deepLinkParser.getRoute(url: url))
	//			print("App was opened via URL: \(incomingURL)")
	//			path.append()
			}
		}
    }
}
