//
//  CodeCoverageInfo.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class CodeCoverageInfo : Codable {
    public let hasCoverageData: Bool
    public let reportRef: Reference?
    public let archiveRef: Reference?

    enum CodeCoverageInfoCodingKeys: String, CodingKey {
        case hasCoverageData
        case reportRef
        case archiveRef
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodeCoverageInfoCodingKeys.self)
        hasCoverageData = try container.decodeXCResultTypeIfPresent(forKey: .hasCoverageData) ?? false
        reportRef = try container.decodeXCResultObjectIfPresent(forKey: .reportRef)
        archiveRef = try container.decodeXCResultObjectIfPresent(forKey: .archiveRef)
    }
}
