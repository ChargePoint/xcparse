//
//  ActionTestConfiguration.swift
//  XCParseCore
//
//  Created by Alex Botkin on 8/16/21.
//  Copyright © 2021 ChargePoint, Inc. All rights reserved.
//

import Foundation

// xcresult 3.34 and above
open class ActionTestConfiguration : Codable {
    public let values: SortedKeyValueArray

    enum ActionTestConfigurationCodingKeys: String, CodingKey {
        case values
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestConfigurationCodingKeys.self)
        values = try container.decodeXCResultObject(forKey: .values)
    }
}
