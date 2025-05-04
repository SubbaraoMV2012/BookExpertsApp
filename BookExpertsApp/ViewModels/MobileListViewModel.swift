//
//  MobileListViewModel.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import Combine
import CoreData

final class MobileListViewModel: ObservableObject {
    @Published var mobiles: [Mobile] = []
    @Published var errorMessage: String?
    private let mobileStoreProtocol: MobileStoreProtocol
    private var cancellables = Set<AnyCancellable>()

    init(mobileStoreProtocol: MobileStoreProtocol) {
        self.mobileStoreProtocol = mobileStoreProtocol
        fetchMobiles()
    }

    func fetchMobiles() {
        do {
            self.mobiles = try mobileStoreProtocol.fetchMobiles()
        } catch {
            self.errorMessage = "Failed to fetch objects: \(error.localizedDescription)"
        }
    }

    func addMobiles(from items: [Mobile]) {
        do {
            try mobileStoreProtocol.save(mobiles: items)
            fetchMobiles()
        } catch {
            errorMessage = "Failed to save objects: \(error.localizedDescription)"
        }
    }

    func deleteObject(id: String) {
        do {
            try mobileStoreProtocol.deleteMobile(withID: id)
            fetchMobiles()
        } catch {
            errorMessage = "Failed to delete object: \(error.localizedDescription)"
        }
    }

    func updateObject(id: String, newName: String) {
        do {
            try mobileStoreProtocol.updateMobile(id: id, newName: newName)
            fetchMobiles()
        } catch {
            errorMessage = "Failed to update object: \(error.localizedDescription)"
        }
    }
}

