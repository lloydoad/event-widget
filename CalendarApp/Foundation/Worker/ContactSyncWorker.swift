//
//  ContactSyncWorker.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//

import SwiftUI
import Contacts

enum ContactError: Error {
    case accessDenied
}

struct Contact {
    let phoneNumber: String
}

@MainActor
class ContactSyncWorker {
    private let store = CNContactStore()
    private let keysToFetch = [
        CNContactPhoneNumbersKey,
    ] as [CNKeyDescriptor]

    private var syncTask: Task<Void, Never>?

    func sync(
        onSuccess: @escaping ([Contact]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        syncTask?.cancel()
        syncTask = Task { @MainActor in
            do {
                let hasAccess = try await store.requestAccess(for: .contacts)
                guard hasAccess else {
                    onError(ContactError.accessDenied)
                    return
                }
                let contacts = try await fetchContacts()
                if !Task.isCancelled {
                    onSuccess(contacts)
                }
            } catch {
                if !Task.isCancelled {
                    onError(error)
                }
            }
        }
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
