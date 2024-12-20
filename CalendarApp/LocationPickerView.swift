//
//  LocationPicker.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
	@StateObject private var viewModel = LocationPickerViewModel()
	@Binding var location: LocationModel?
	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack(spacing: 4) {
			ListTitleView(title: "search address")
			searchBar
			searchResults
			HStack {
				Spacer()
				Button("[save]") {
					if let selected = viewModel.selectedLocation {
						location = createLocationModel(from: selected)
						dismiss()
					}
				}
				.font(AppFont.large.asFont)
				.tint(Color(AppColor.primary.asUIColor))
				.disabled(viewModel.selectedLocation == nil)
			}
		}
		.padding()
	}

	private var searchBar: some View {
		HStack {
			Image(systemName: "magnifyingglass")
				.foregroundColor(.gray)
			TextField("butt street, pennsylvania, usa", text: $viewModel.searchText)
				.textFieldStyle(.plain)
				.autocorrectionDisabled()
				.onChange(of: viewModel.searchText, { _, newValue in
					viewModel.search()
				})
			if !viewModel.searchText.isEmpty {
				Button(action: {
					viewModel.searchText = ""
				}) {
					Image(systemName: "xmark.circle.fill")
						.foregroundColor(.gray)
				}
			}
		}
		.padding()
		.background(Color(.secondarySystemBackground))
		.clipShape(RoundedRectangle(cornerSize: .init(width: 16, height: 16)))
	}

	private var searchResults: some View {
		List {
			if viewModel.isSearching {
				HStack {
					Spacer()
					ProgressView()
					Spacer()
				}
			} else if let error = viewModel.errorMessage {
				Text(error)
					.foregroundColor(.red)
			} else {
				ForEach(viewModel.searchResults, id: \.self) { item in
					Button {
						viewModel.selectLocation(item)
					} label: {
						VStack(alignment: .leading) {
							Text(item.name ?? "Unknown Location")
								.font(.headline)

							if let address = item.placemark.title {
								Text(address)
									.font(.caption)
									.foregroundColor(.secondary)
							}
						}
					}
				}
			}
		}
		.listStyle(.plain)
	}

	private func createLocationModel(from item: MKMapItem) -> LocationModel {
		let placemark = item.placemark
		let address = placemark.thoroughfare ?? ""
		let city = placemark.locality ?? ""
		let state = placemark.administrativeArea ?? ""
		return LocationModel(address: address, city: city, state: state)
	}
}

#Preview {
	@Previewable @State var location: LocationModel?
	LocationPickerView(location: $location)
}
