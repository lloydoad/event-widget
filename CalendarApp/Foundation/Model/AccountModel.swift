//
//  AccountModel.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/17/24.
//

import Foundation

struct AccountModel: Codable, Hashable, Equatable {
	var uuid: UUID
	var username: String
	var phoneNumber: String

    struct Realtime: Codable {
        var id: UUID
        var username: String
        var phone_number: String
    }
}

extension AccountModel: Comparable {
    static func < (lhs: AccountModel, rhs: AccountModel) -> Bool {
        lhs.username < rhs.username
    }
}

extension AccountModel.Realtime {
    init(model: AccountModel) {
        self.id = model.uuid
        self.username = model.username
        self.phone_number = PhoneNumberFormatter().removeFormatting(model.phoneNumber)
    }

    var model: AccountModel {
        let phoneNumberFormatter = PhoneNumberFormatter()
        return AccountModel(
            uuid: id,
            username: username,
            phoneNumber: phoneNumberFormatter.format(phone_number)
        )
    }
}

extension AccountModel {
    var realtime: AccountModel.Realtime {
        .init(model: self)
    }
}
