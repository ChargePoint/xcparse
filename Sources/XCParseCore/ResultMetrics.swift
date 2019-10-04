//
//  ResultMetrics.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ResultMetrics : Codable {
    public let analyzerWarningCount: Int
    public let errorCount: Int
    public let testsCount: Int
    public let testsFailedCount: Int
    public let warningCount: Int

    enum ResultMetricsCodingKeys: String, CodingKey {
        case analyzerWarningCount
        case errorCount
        case testsCount
        case testsFailedCount
        case warningCount
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultMetricsCodingKeys.self)
        analyzerWarningCount = try container.decodeXCResultTypeIfPresent(forKey: .analyzerWarningCount) ?? 0
        errorCount = try container.decodeXCResultTypeIfPresent(forKey: .errorCount) ?? 0
        testsCount = try container.decodeXCResultTypeIfPresent(forKey: .testsCount) ?? 0
        testsFailedCount = try container.decodeXCResultTypeIfPresent(forKey: .testsFailedCount) ?? 0
        warningCount = try container.decodeXCResultTypeIfPresent(forKey: .warningCount) ?? 0
    }
}
