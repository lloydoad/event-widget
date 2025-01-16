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
		}
        .font(AppFont.large.asFont)
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
		.clipShape(RoundedRectangle(cornerSize: .init(width: 12, height: 12)))
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
                    locationItemView(for: item)
				}
			}
		}
		.listStyle(.plain)
	}
    
    private func locationItemView(for item: MKMapItem) -> some View {
        Button {
            viewModel.selectLocation(item)
            if let selected = viewModel.selectedLocation {
                location = locationModel(from: selected)
                dismiss()
            }
        } label: {
            VStack(alignment: .leading) {
                Text(item.name ?? "unknown location")
                    .font(.headline)
                    .fontDesign(.serif)

                if let address = item.placemark.title {
                    Text(address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontDesign(.serif)
                }
            }
        }
    }

	private func locationModel(from item: MKMapItem) -> LocationModel {
		let placemark = item.placemark
        let postalAddress = placemark.postalAddress
        let address = postalAddress?.street ?? ""
        let city = postalAddress?.city ?? ""
        let state = postalAddress?.state ?? ""
        let code = postalAddress?.postalCode ?? ""
        let country = postalAddress?.country ?? ""
        return LocationModel(address: address, code: code, city: city, state: state, country: country)
	}
}

#Preview {
	@Previewable @State var location: LocationModel?
	LocationPickerView(location: $location)
}
