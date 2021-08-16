//
//  ActionTestPerformanceMetricSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation


public enum ActionTestPerformanceMetric : ExpressibleByStringLiteral {
    case ClockMonotonicTime
    case CPUCycles
    case CPUInstructionsRetired
    case CPUTime
    case DiskLogicalWrites
    case MemoryPhysical
    case MemoryPhysicalPeak
    case Unknown(name: String)

    public init(stringLiteral name: String) {
        switch name {
        case "com.apple.dt.XCTMetric_Clock.time.monotonic":
            self = .ClockMonotonicTime
        case "com.apple.dt.XCTMetric_CPU.cycles":
            self = .CPUCycles
        case "com.apple.dt.XCTMetric_CPU.instructions_retired":
            self = .CPUInstructionsRetired
        case "com.apple.dt.XCTMetric_CPU.time":
            self = .CPUTime
        case "com.apple.dt.XCTMetric_Disk.logical.writes":
            self = .DiskLogicalWrites
        case "com.apple.dt.XCTMetric_Memory.physical":
            self = .MemoryPhysical
        case "com.apple.dt.XCTMetric_Memory.physical-peak":
            self = .MemoryPhysicalPeak
        default:
            self = .Unknown(name: name)
        }
    }
}


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

    // xcresult 3.34 and above
    public let polarity: String?

    // Derived
    public var metricType : ActionTestPerformanceMetric {
        let identifierString = identifier ?? "Identifier Missing"
        return ActionTestPerformanceMetric(stringLiteral: identifierString)
    }

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
        case polarity
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestPerformanceMetricSummaryCodingKeys.self)
        displayName = try container.decodeXCResultType(forKey: .displayName)
        unitOfMeasurement = try container.decodeXCResultType(forKey: .unitOfMeasurement)

        measurements = try container.decodeXCResultArray(forKey: .measurements)

        identifier = try container.decodeXCResultTypeIfPresent(forKey: .identifier)
        baselineName = try container.decodeXCResultTypeIfPresent(forKey: .baselineName)
        baselineAverage = try container.decodeXCResultTypeIfPresent(forKey: .baselineAverage)
        maxPercentRegression = try container.decodeXCResultTypeIfPresent(forKey: .maxPercentRegression)
        maxPercentRelativeStandardDeviation = try container.decodeXCResultTypeIfPresent(forKey: .maxPercentRelativeStandardDeviation)
        maxRegression = try container.decodeXCResultTypeIfPresent(forKey: .maxRegression)
        maxStandardDeviation = try container.decodeXCResultTypeIfPresent(forKey: .maxStandardDeviation)
        polarity = try container.decodeXCResultTypeIfPresent(forKey: .polarity)
    }
}
