//
//  ComposerView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI
import MapKit

struct ComposerView: View {
	@EnvironmentObject var userAccountStore: UserAccountStore
    @State private var description: String = "description ..."
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
	@State private var location: LocationModel? = nil
	@State private var isLocationPickerPresented: Bool = false

    var body: some View {
		Form {
			ListTitleView(title: "create new event")
			TextEditor(text: $description)
				.frame(minHeight: 300, maxHeight: 350)
				.onChange(of: description, { oldValue, newValue in
					if newValue.count < 100 {
						description = newValue
					} else {
						description = oldValue
					}
				})
			DatePicker("starts:",
					   selection: $startDate,
					   displayedComponents: [.date, .hourAndMinute])
			DatePicker(
				"ends:",
				selection: $endDate,
				displayedComponents: [.date, .hourAndMinute])
			HStack {
				Spacer()
				Button("[\(location?.address ?? "add address")]") {
					isLocationPickerPresented = true
				}
				.font(AppFont.large.asFont)
				.tint(Color(AppColor.primary.asUIColor))
			}
			HStack {
				Spacer()
				Button("[save changes]") {
					saveEvent()
				}
				.font(AppFont.large.asFont)
				.tint(Color(AppColor.primary.asUIColor))
				.disabled(validatedEvent == nil)
			}
		}
		.sheet(isPresented: $isLocationPickerPresented, content: {
			LocationPickerView(location: $location)
		})
		.font(AppFont.light.asFont)
		.tint(Color(AppColor.appTint.asUIColor))
    }

	private var validatedEvent: EventModel? {
		guard
			!description.isEmpty,
			endDate > .now,
			let location = location
		else {
			return nil
		}
		return EventModel(
			creator: userAccountStore.account,
			description: description,
			startDate: startDate,
			endDate: endDate,
			location: location,
			guests: []
		)
	}

    private func saveEvent() {
        // Implement the logic to save the event
		print(validatedEvent)
        // Save the newEvent to your data store
    }
}


#Preview {
	ComposerView()
		.environmentObject(UserAccountStore(
			account: AccountModelMocks.alanAccount
		))
}
