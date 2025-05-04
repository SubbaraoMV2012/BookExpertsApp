//
//  Mobile.swift
//  BookExpertsApp
//
//  Created by SubbaRao MV on 04/05/25.
//

import Foundation

struct Mobile: Identifiable, Decodable {
    let id: String
    let name: String
    let data: [String: String]?

    init(id: String, name: String, data: [String: String]?) {
        self.id = id
        self.name = name
        self.data = data
    }

    enum CodingKeys: String, CodingKey {
        case id, name, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        if let rawData = try? container.decode([String: AnyDecodable].self, forKey: .data) {
            var stringDict = [String: String]()
            for (key, value) in rawData {
                stringDict[key] = value.description
            }
            data = stringDict
        } else {
            data = nil
        }
    }
}

struct AnyDecodable: Decodable, CustomStringConvertible {
    let value: Any

    var description: String {
        if let val = value as? CustomStringConvertible {
            return val.description
        }
        return "\(value)"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let doubleVal = try? container.decode(Double.self) {
            value = doubleVal
        } else if let boolVal = try? container.decode(Bool.self) {
            value = boolVal
        } else if let stringVal = try? container.decode(String.self) {
            value = stringVal
        } else if let nested = try? container.decode([String: AnyDecodable].self) {
            value = nested.mapValues { $0.description }
        } else if let array = try? container.decode([AnyDecodable].self) {
            value = array.map { $0.description }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported value")
        }
    }
}

