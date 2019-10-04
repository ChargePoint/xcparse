//
//  ActivityLogTargetBuildSection.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActivityLogTargetBuildSection : ActivityLogMajorSection {
    public let productType: String?

    enum ActivityLogTargetBuildSectionCodingKeys: String, CodingKey {
        case productType
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogTargetBuildSectionCodingKeys.self)
        productType = try container.decodeXCResultTypeIfPresent(forKey: .productType)
        try super.init(from: decoder)
    }
}
