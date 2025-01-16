//
//  ComposerView.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI
import MapKit

struct ComposerView: View {
    @EnvironmentObject var appSessionStore: AppSessionStore
    @EnvironmentObject var dataStoreProvider: DataStoreProvider
    @Environment(\.dismiss) private var dismiss

    var shouldUpdate: Bool
    var eventID: UUID
    @State var description: String
    @State var startDate: Date
    @State var endDate: Date
    @State var location: LocationModel?

    @State private var error: Error?
	@State private var isLocationPickerPresented: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
		Form {
			ListTitleView(title: "create new event")
            ZStack(alignment: .topLeading) {
                if description.isEmpty {
                    Text("what's happening?")
                        .foregroundColor(Color(.placeholderText))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                }
                TextEditor(text: $description)
                    .frame(minHeight: 300, maxHeight: 350)
                    .onChange(of: description, { oldValue, newValue in
                        if newValue.count < 100 {
                            description = newValue
                        } else {
                            description = oldValue
                        }
                    })
            }
			DatePicker("starts:",
					   selection: $startDate,
                       in: Date()...,
					   displayedComponents: [.date, .hourAndMinute])
			DatePicker("ends:",
                       selection: $endDate,
                       in: startDate...,
                       displayedComponents: [.date, .hourAndMinute])
			HStack {
				Spacer()
				Button("[\(location?.address ?? "add address")]") {
					isLocationPickerPresented = true
				}
				.font(AppFont.large.asFont)
                .tint(Color(AppColor.primary.asColor))
			}
			HStack {
				Spacer()
				Button("[save changes]") {
					saveEvent()
				}
				.font(AppFont.large.asFont)
                .tint(Color(AppColor.primary.asColor))
				.disabled(validatedEvent == nil)
			}
		}
		.sheet(isPresented: $isLocationPickerPresented, content: {
			LocationPickerView(location: $location)
		})
		.font(AppFont.light.asFont)
		.tint(Color(AppColor.appTint.asUIColor))
        .disabled(isLoading)
        .errorAlert(error: $error)
    }

	private var validatedEvent: EventModel? {
		guard
			!description.isEmpty,
            endDate > startDate,
            endDate > .now,
			let location = location,
            let userAccount = appSessionStore.userAccount
		else {
			return nil
		}
		return EventModel(
            uuid: eventID,
            creator: userAccount,
			description: description,
			startDate: startDate,
			endDate: endDate,
			location: location,
			guests: []
		)
	}

    private func saveEvent() {
        guard let validatedEvent else { return }
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                if shouldUpdate {
                    _ = try await dataStoreProvider.dataStore.update(event: validatedEvent)
                } else {
                    _ = try await dataStoreProvider.dataStore.create(event: validatedEvent)
                }
                ActionCentralDispatch.shared.handle(action: ButtonIdentifier.refreshEventListAction)
                dismiss()
                isLoading = false
            } catch {
                self.error = error
                isLoading = false
            }
        }
    }
}


#Preview {
    ComposerView(shouldUpdate: false, eventID: UUID(), description: "", startDate: .now, endDate: .now)
        .environmentObject(mockAppSessionStore())
        .environmentObject(DataStoreProvider(dataStore: MockDataStore()))
}
