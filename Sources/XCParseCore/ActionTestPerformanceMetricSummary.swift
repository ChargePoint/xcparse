//
//  ActionTestPerformanceMetricSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestPerformanceMetricSummary : Codable {
    public let displayName: String
    public let unitOfMeasurement: String
    public let measurements: [Double]
    public let identifier: String?
    public let baselineName: String?
    public let baselineAverage: Double?
    public let maxPercentRegression: Double?
    public let maxPercentRelativeStandardDeviation: Double?
    public let maxRegression: Double?
    public let maxStandardDeviation: Double?

    enum ActionTestPerformanceMetricSummaryCodingKeys: String, CodingKey {
        case displayName
        case unitOfMeasurement
        case measurements
        case identifier
        case baselineName
        case baselineAverage
        case maxPercentRegression
        case maxPercentRelativeStandardDeviation
        case maxRegression
        case maxStandardDeviation
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestPerformanceMetricSummaryCodingKeys.self)
        displayName = try container.decodeXCResultType(forKey: .displayName)
        unitOfMeasurement = try container.decodeXCResultType(forKey: .unitOfMeasurement)

        let measurementValues = try container.decode(XCResultArrayValue<Double>.self, forKey: .measurements)
        measurements = measurementValues.values

        identifier = try container.decodeXCResultTypeIfPresent(forKey: .identifier)
        baselineName = try container.decodeXCResultTypeIfPresent(forKey: .baselineName)
        baselineAverage = try container.decodeXCResultTypeIfPresent(forKey: .baselineAverage)
        maxPercentRegression = try container.decodeXCResultTypeIfPresent(forKey: .maxPercentRegression)
        maxPercentRelativeStandardDeviation = try container.decodeXCResultTypeIfPresent(forKey: .maxPercentRelativeStandardDeviation)
        maxRegression = try container.decodeXCResultTypeIfPresent(forKey: .maxRegression)
        maxStandardDeviation = try container.decodeXCResultTypeIfPresent(forKey: .maxStandardDeviation)
    }
}
