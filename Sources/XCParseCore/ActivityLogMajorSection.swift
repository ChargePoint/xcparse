//
//  ActivityLogMajorSection.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActivityLogMajorSection : ActivityLogSection {
    public let subtitle: String

    enum ActivityLogMajorSectionCodingKeys: String, CodingKey {
        case subtitle
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogMajorSectionCodingKeys.self)
        subtitle = try container.decodeXCResultType(forKey: .subtitle)
        try super.init(from: decoder)
    }
}
