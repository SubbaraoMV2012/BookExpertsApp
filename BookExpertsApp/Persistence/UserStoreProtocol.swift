//
//  UserStoreProtocol.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation

protocol UserStoreProtocol {
    func save(user: User) throws
    func fetchUser() throws -> User?
}

