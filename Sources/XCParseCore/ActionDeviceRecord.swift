//
//  ActionDeviceRecord.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionDeviceRecord : Codable {
    public let name: String
    public let isConcreteDevice: Bool
    public let operatingSystemVersion: String
    public let operatingSystemVersionWithBuildNumber: String
    public let nativeArchitecture: String
    public let modelName: String
    public let modelCode: String
    public let modelUTI: String
    public let identifier: String
    public let isWireless: Bool
    public let cpuKind: String
    public let cpuCount: Int?
    public let cpuSpeedInMHz: Int?
    public let busSpeedInMHz: Int?
    public let ramSizeInMegabytes: Int?
    public let physicalCPUCoresPerPackage: Int?
    public let logicalCPUCoresPerPackage: Int?
    public let platformRecord: ActionPlatformRecord

    enum ActionDeviceRecordCodingKeys: String, CodingKey {
        case name
        case isConcreteDevice
        case operatingSystemVersion
        case operatingSystemVersionWithBuildNumber
        case nativeArchitecture
        case modelName
        case modelCode
        case modelUTI
        case identifier
        case isWireless
        case cpuKind
        case cpuCount
        case cpuSpeedInMHz
        case busSpeedInMHz
        case ramSizeInMegabytes
        case physicalCPUCoresPerPackage
        case logicalCPUCoresPerPackage
        case platformRecord
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionDeviceRecordCodingKeys.self)
        name = try container.decodeXCResultType(forKey: .name)
        isConcreteDevice = try container.decodeXCResultType(forKey: .isConcreteDevice)
        operatingSystemVersion = try container.decodeXCResultType(forKey: .operatingSystemVersion)
        operatingSystemVersionWithBuildNumber = try container.decodeXCResultType(forKey: .operatingSystemVersionWithBuildNumber)
        nativeArchitecture = try container.decodeXCResultType(forKey: .nativeArchitecture)
        modelName = try container.decodeXCResultType(forKey: .modelName)
        modelCode = try container.decodeXCResultType(forKey: .modelCode)
        modelUTI = try container.decodeXCResultType(forKey: .modelUTI)
        identifier = try container.decodeXCResultType(forKey: .identifier)
        isWireless = try container.decodeXCResultType(forKey: .isWireless)
        cpuKind = try container.decodeXCResultType(forKey: .cpuKind)
        cpuCount = try container.decodeXCResultTypeIfPresent(forKey: .cpuCount)
        cpuSpeedInMHz = try container.decodeXCResultTypeIfPresent(forKey: .cpuSpeedInMHz)
        busSpeedInMHz = try container.decodeXCResultTypeIfPresent(forKey: .busSpeedInMHz)
        ramSizeInMegabytes = try container.decodeXCResultTypeIfPresent(forKey: .ramSizeInMegabytes)
        physicalCPUCoresPerPackage = try container.decodeXCResultTypeIfPresent(forKey: .physicalCPUCoresPerPackage)
        logicalCPUCoresPerPackage = try container.decodeXCResultTypeIfPresent(forKey: .logicalCPUCoresPerPackage)
        platformRecord = try container.decodeXCResultObject(forKey: .platformRecord)
    }
}
