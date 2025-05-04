//
//  MobileStoreProtocol.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation

protocol MobileStoreProtocol {
    func save(mobiles: [Mobile]) throws
    func fetchMobiles() throws -> [Mobile]
    func deleteMobile(withID id: String) throws
    func updateMobile(id: String, newName: String) throws
}
