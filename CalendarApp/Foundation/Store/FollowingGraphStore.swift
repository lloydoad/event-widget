//
//  FollowingGraphStoring.swift
//  CalendarApp
//
//  Created by Lloyd Dapaah on 12/20/24.
//


protocol FollowingGraphStoring {
    func createFollowing(account: AccountModel, following: AccountModel) async throws
    func getFollowing(account: AccountModel) async throws -> [AccountModel]
    func removeFollowing(account: AccountModel, following: AccountModel) async throws
}