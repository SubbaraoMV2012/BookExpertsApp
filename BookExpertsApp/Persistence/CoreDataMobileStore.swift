//
//  CoreDataMobileStore.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation
import CoreData

final class CoreDataMobileStore: MobileStoreProtocol {
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func save(mobiles: [Mobile]) throws {
        for obj in mobiles {
            let request: NSFetchRequest<CDMobile> = CDMobile.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", obj.id)

            if let existing = try context.fetch(request).first {
                existing.name = obj.name
                existing.jsonData = try encodeData(obj.data)
            } else {
                let newObj = CDMobile(context: context)
                newObj.id = obj.id
                newObj.name = obj.name
                newObj.jsonData = try encodeData(obj.data)
            }
        }
        try context.save()
    }

    func fetchMobiles() throws -> [Mobile] {
        let request: NSFetchRequest<CDMobile> = CDMobile.fetchRequest()
        return try context.fetch(request).map { cd in
            Mobile(
                id: cd.id ?? "",
                name: cd.name ?? "",
                data: decodeData(cd.jsonData)
            )
        }
    }

    func deleteMobile(withID id: String) throws {
        let request: NSFetchRequest<CDMobile> = CDMobile.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let obj = try context.fetch(request).first {
            context.delete(obj)
            try context.save()
        }
    }

    func updateMobile(id: String, newName: String) throws {
        let request: NSFetchRequest<CDMobile> = CDMobile.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let obj = try context.fetch(request).first {
            obj.name = newName
            try context.save()
        }
    }

    private func encodeData(_ dict: [String: String]?) throws -> String {
        guard let dict = dict else { return "" }
        let jsonData = try JSONSerialization.data(withJSONObject: dict)
        return String(data: jsonData, encoding: .utf8) ?? ""
    }

    private func decodeData(_ json: String?) -> [String: String]? {
        guard let json = json,
              let data = json.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            return nil
        }
        return dict
    }
}
