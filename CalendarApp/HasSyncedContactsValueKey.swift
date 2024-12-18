//
//  HasSyncedContactsValueKey.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/18/24.
//

import SwiftUI

struct HasSyncedContactsValueKey: EnvironmentKey {
	static let defaultValue: Bool = false
}

extension EnvironmentValues {
	var hasSyncedContacts: Bool {
		get { self[HasSyncedContactsValueKey.self] }
		set { self[HasSyncedContactsValueKey.self] = newValue }
	}
}
