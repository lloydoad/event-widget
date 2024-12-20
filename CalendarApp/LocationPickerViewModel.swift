//
//  LocationPickerViewModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI
import MapKit

@MainActor
class LocationPickerViewModel: ObservableObject {
	@Published var searchText = ""
	@Published var searchResults: [MKMapItem] = []
	@Published var selectedLocation: MKMapItem?
	@Published var isSearching = false
	@Published var errorMessage: String?

	private var searchTask: Task<Void, Never>?

	func search() {
		searchTask?.cancel()

		guard !searchText.isEmpty else {
			searchResults = []
			return
		}

		searchTask = Task {
			isSearching = true
			errorMessage = nil

			do {
				let request = MKLocalSearch.Request()
				request.naturalLanguageQuery = searchText
				let search = MKLocalSearch(request: request)
				let response = try await search.start()

				if !Task.isCancelled {
					searchResults = response.mapItems
				}
			} catch {
				errorMessage = "no locations found"
			}

			isSearching = false
		}
	}

	func selectLocation(_ item: MKMapItem) {
		selectedLocation = item
	}
}
