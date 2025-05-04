//
//  CoreDataUserStore.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import CoreData

final class CoreDataUserStore: UserStoreProtocol {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(user: User) throws {
        let request: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        if let existing = try context.fetch(request).first {
            existing.id = user.id
            existing.name = user.name
            existing.email = user.email
            existing.photoURL = user.photoURL
        } else {
            let newUser = CDUser(context: context)
            newUser.id = user.id
            newUser.name = user.name
            newUser.email = user.email
            newUser.photoURL = user.photoURL
        }

        try context.save()
    }

    func fetchUser() throws -> User? {
        let request: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        guard let cdUser = try context.fetch(request).first else {
            return nil
        }

        return User(
            id: cdUser.id ?? "",
            name: cdUser.name ?? "",
            email: cdUser.email ?? "",
            photoURL: cdUser.photoURL ?? ""
        )
    }
}
