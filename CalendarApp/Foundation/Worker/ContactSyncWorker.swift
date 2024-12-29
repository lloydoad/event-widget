//
//  ContactSyncWorker.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI
import Contacts

struct Contact {
    let phoneNumber: String
}

@MainActor
protocol ContactSyncWorking {
    func sync() async throws -> [Contact]
}

struct MockContactSyncWorker: ContactSyncWorking {
    var contacts: [Contact]
    func sync() async throws -> [Contact] {
        contacts
    }
}

@MainActor
class ContactSyncWorker: ContactSyncWorking {
    private let store = CNContactStore()
    private let keysToFetch = [CNContactPhoneNumbersKey] as [CNKeyDescriptor]
    
    private var currentTask: Task<[Contact], Error>?
    func sync() async throws -> [Contact] {
        currentTask?.cancel()
        let task = Task { @MainActor in
            do {
                let hasAccess = try await store.requestAccess(for: .contacts)
                guard hasAccess else {
                    throw ErrorManager
                        .with(
                            loggedMessage: "No access to contacts",
                            appMessage: "No access to contacts. Please enable access in Settings"
                        )
                }
                return try await fetchContacts()
            } catch {
                throw ErrorManager
                    .with(
                        loggedMessage: error.localizedDescription,
                        appMessage: "No access to contacts. Please enable access in Settings"
                    )
            }
        }
        currentTask = task
        return try await task.value
    }

    private func fetchContacts() async throws -> [Contact] {
        let containers = try store.containers(matching: nil)
        var contacts: [Contact] = []

        for container in containers where !Task.isCancelled {
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            let cnContacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            let mappedContacts = cnContacts.compactMap { contact -> Contact? in
                guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else {
                    return nil
                }
                return Contact(phoneNumber: phoneNumber)
            }
            contacts.append(contentsOf: mappedContacts)
        }

        return contacts
    }
}
