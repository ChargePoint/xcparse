//
//  SortedKeyValueArray.swift
//  
//
//  Created by Alexander Botkin on 10/4/20.
//

import Foundation

open class SortedKeyValueArray : Codable {
    public let storage: [SortedKeyValueArrayPair]

    enum SortedKeyValueArrayCodingKeys: String, CodingKey {
        case storage
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SortedKeyValueArrayCodingKeys.self)
        storage = try container.decodeXCResultArray(forKey: .storage)
    }
}
