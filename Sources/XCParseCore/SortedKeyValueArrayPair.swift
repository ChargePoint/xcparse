//
//  SortedKeyValueArrayPair.swift
//  
//
//  Created by Alexander Botkin on 10/4/20.
//

import Foundation


open class SortedKeyValueArrayPair : Codable {
    public let key: String
    public let value: XCResultValueType

    enum SortedKeyValueArrayPairCodingKeys: String, CodingKey {
        case key
        case value
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SortedKeyValueArrayPairCodingKeys.self)
        key = try container.decodeXCResultType(forKey: .key)
        value = try container.decodeXCResultObject(forKey: .value)
    }
}
