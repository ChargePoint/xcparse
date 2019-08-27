//
//  XCPResultTypes.swift
//  xcparse
//
//  Created by Alex Botkin on 8/13/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation


open class ActionAbstractTestSummary : XCResultObject {
    public let name: String?
    
    public enum ActionAbstractTestSummaryCodingKeys: String, CodingKey {
        case name
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionAbstractTestSummaryCodingKeys.self)
        name = try container.decodeXCResultTypeIfPresent(forKey: .name)
        try super.init(from: decoder)
        let propertyList = ["name" : name]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionDeviceRecord : XCResultObject {
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
    
    public enum ActionDeviceRecordCodingKeys: String, CodingKey {
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
    
    public required init(from decoder: Decoder) throws {
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
        isWireless = try container.decodeXCResultTypeIfPresent(forKey: .isWireless) ?? false
        cpuKind = try container.decodeXCResultTypeIfPresent(forKey: .cpuKind) ?? ""
        cpuCount = try container.decodeXCResultTypeIfPresent(forKey: .cpuCount)
        cpuSpeedInMHz = try container.decodeXCResultTypeIfPresent(forKey: .cpuSpeedInMHz)
        busSpeedInMHz = try container.decodeXCResultTypeIfPresent(forKey: .busSpeedInMHz)
        ramSizeInMegabytes = try container.decodeXCResultTypeIfPresent(forKey: .ramSizeInMegabytes)
        physicalCPUCoresPerPackage = try container.decodeXCResultTypeIfPresent(forKey: .physicalCPUCoresPerPackage)
        logicalCPUCoresPerPackage = try container.decodeXCResultTypeIfPresent(forKey: .logicalCPUCoresPerPackage)
        platformRecord = try container.decodeXCResultObject(forKey: .platformRecord)
        try super.init(from: decoder)
        let propertyList = ["name":name, "isConcreteDevice":isConcreteDevice, "operatingSystemVersion":operatingSystemVersion, "operatingSystemVersionWithBuildNumber":operatingSystemVersionWithBuildNumber, "nativeArchitecture":nativeArchitecture, "modelName":modelName, "modelCode":modelCode, "modelUTI":modelUTI, "identifier":identifier, "isWireless":isWireless, "cpuKind":cpuKind, "cpuCount":cpuCount, "cpuSpeedInMHz": cpuSpeedInMHz, "busSpeedInMHz": busSpeedInMHz,
                            "ramSizeInMegabytes": ramSizeInMegabytes, "physicalCPUCoresPerPackage":physicalCPUCoresPerPackage, "logicalCPUCoresPerPackage":logicalCPUCoresPerPackage, "platformRecord":platformRecord] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionPlatformRecord : XCResultObject {
    public let identifier: String
    public let userDescription: String
    
    public enum ActionPlatformRecordCodingKeys: String, CodingKey {
        case identifier
        case userDescription
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionPlatformRecordCodingKeys.self)
        identifier = try container.decodeXCResultType(forKey: .identifier)
        userDescription = try container.decodeXCResultType(forKey: .userDescription)
        try super.init(from: decoder)
        let propertyList = ["identifier":identifier, "userDescription":userDescription]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionRecord : XCResultObject {
    public let schemeCommandName: String
    public let schemeTaskName: String
    public let title: String?
    public let startedTime: Date
    public let endedTime: Date
    public let runDestination: ActionRunDestinationRecord
    public let buildResult: ActionResult
    public let actionResult: ActionResult
    
    public enum ActionRecordCodingKeys: String, CodingKey {
        case schemeCommandName
        case schemeTaskName
        case title
        case startedTime
        case endedTime
        case runDestination
        case buildResult
        case actionResult
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionRecordCodingKeys.self)
        schemeCommandName = try container.decodeXCResultType(forKey: .schemeCommandName)
        schemeTaskName = try container.decodeXCResultType(forKey: .schemeTaskName)
        title = try container.decodeXCResultTypeIfPresent(forKey: .title)
        startedTime = try container.decodeXCResultType(forKey: .startedTime)
        endedTime = try container.decodeXCResultType(forKey: .endedTime)
        runDestination = try container.decodeXCResultObject(forKey: .runDestination)
        buildResult = try container.decodeXCResultObject(forKey: .buildResult)
        actionResult = try container.decodeXCResultObject(forKey: .actionResult)
        try super.init(from: decoder)
        let propertyList = ["schemeCommandName": schemeCommandName, "schemeTaskName": schemeTaskName, "title": title, "startedTime":startedTime, "endedTime":endedTime, "runDestination":runDestination, "buildResult":buildResult, "actionResult": actionResult] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionResult : XCResultObject {
    public let resultName: String
    public let status: String
    public let metrics: ResultMetrics
    public let issues: ResultIssueSummaries
    public let coverage: CodeCoverageInfo
    public let timelineRef: Reference?
    public let logRef: Reference?
    public let testsRef: Reference?
    public let diagnosticsRef: Reference?
    
    public enum ActionResultCodingKeys: String, CodingKey {
        case resultName
        case status
        case metrics
        case issues
        case coverage
        case timelineRef
        case logRef
        case testsRef
        case diagnosticsRef
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionResultCodingKeys.self)
        resultName = try container.decodeXCResultType(forKey: .resultName)
        status = try container.decodeXCResultType(forKey: .status)
        metrics = try container.decodeXCResultObject(forKey: .metrics)
        issues = try container.decodeXCResultObject(forKey: .issues)
        coverage = try container.decodeXCResultObject(forKey: .coverage)
        timelineRef = try container.decodeXCResultObjectIfPresent(forKey: .timelineRef)
        logRef = try container.decodeXCResultObjectIfPresent(forKey: .logRef)
        testsRef = try container.decodeXCResultObjectIfPresent(forKey: .testsRef)
        diagnosticsRef = try container.decodeXCResultObjectIfPresent(forKey: .diagnosticsRef)
        try super.init(from: decoder)
        let propertyList = ["resultName": resultName, "status": status, "metrics": metrics, "issues": issues, "coverage": coverage, "timelineRef": timelineRef, "logRef": logRef, "testsRef": testsRef, "diagnosticsRef": diagnosticsRef] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionRunDestinationRecord : XCResultObject {
    public let displayName: String
    public let targetArchitecture: String
    public let targetDeviceRecord: ActionDeviceRecord
    public let localComputerRecord: ActionDeviceRecord
    public let targetSDKRecord: ActionSDKRecord
    
    public enum ActionRunDestinationRecordCodingKeys: String, CodingKey {
        case displayName
        case targetArchitecture
        case targetDeviceRecord
        case localComputerRecord
        case targetSDKRecord
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionRunDestinationRecordCodingKeys.self)
        displayName = try container.decodeXCResultType(forKey: .displayName)
        targetArchitecture = try container.decodeXCResultType(forKey: .targetArchitecture)
        targetDeviceRecord = try container.decodeXCResultObject(forKey: .targetDeviceRecord)
        localComputerRecord = try container.decodeXCResultObject(forKey: .localComputerRecord)
        targetSDKRecord = try container.decodeXCResultObject(forKey: .targetSDKRecord)
        try super.init(from: decoder)
        let propertyList = ["displayName": displayName, "targetArchitecture": targetArchitecture, "targetDeviceRecord": targetDeviceRecord, "localComputerRecord": localComputerRecord, "targetSDKRecord": targetSDKRecord] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionSDKRecord : XCResultObject {
    public let name: String
    public let identifier: String
    public let operatingSystemVersion: String
    public let isInternal: Bool
    
    public enum ActionSDKRecordCodingKeys: String, CodingKey {
        case name
        case identifier
        case operatingSystemVersion
        case isInternal
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionSDKRecordCodingKeys.self)
        name = try container.decodeXCResultType(forKey: .name)
        identifier = try container.decodeXCResultType(forKey: .identifier)
        operatingSystemVersion = try container.decodeXCResultType(forKey: .operatingSystemVersion)
        isInternal = try container.decodeXCResultTypeIfPresent(forKey: .isInternal) ?? false
        try super.init(from: decoder)
        let propertyList = ["name": name, "identifier": identifier, "operatingSystemVersion": operatingSystemVersion, "isInternal": isInternal] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestActivitySummary : XCResultObject {
    public let title: String
    public let activityType: String
    public let uuid: String
    public let start: Date?
    public let finish: Date?
    public let attachments: [ActionTestAttachment]
    public let subactivities: [ActionTestActivitySummary]
    
    public enum ActionTestActivitySummaryCodingKeys: String, CodingKey {
        case title
        case activityType
        case uuid
        case start
        case finish
        case attachments
        case subactivities
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestActivitySummaryCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        activityType = try container.decodeXCResultType(forKey: .activityType)
        uuid = try container.decodeXCResultType(forKey: .uuid)
        start = try container.decodeXCResultTypeIfPresent(forKey: .start)
        finish = try container.decodeXCResultTypeIfPresent(forKey: .finish)
        
        attachments = try container.decodeIfPresent(XCResultArrayValue<ActionTestAttachment>.self, forKey: .attachments)?.values ?? []
        subactivities = try container.decodeIfPresent(XCResultArrayValue<ActionTestActivitySummary>.self, forKey: .subactivities)?.values ?? []
        try super.init(from: decoder)
        let propertyList = ["title": title, "activityType": activityType, "uuid": uuid, "start": start, "finish": finish, "attachments": attachments, "subactivities": subactivities] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestAttachment : XCResultObject {
    public let uniformTypeIdentifier: String
    public let name: String?
    public let timestamp: Date?
//    public let userInfo: SortedKeyValueArray?
    public let lifetime: String
    public let inActivityIdentifier: Int
    public let filename: String?
    public let payloadRef: Reference?
    public let payloadSize: Int
    
    public enum ActionTestAttachmentCodingKeys: String, CodingKey {
        case uniformTypeIdentifier
        case name
        case timestamp
//        case userInfo
        case lifetime
        case inActivityIdentifier
        case filename
        case payloadRef
        case payloadSize
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestAttachmentCodingKeys.self)
        uniformTypeIdentifier = try container.decodeXCResultType(forKey: .uniformTypeIdentifier)
        name = try container.decodeXCResultTypeIfPresent(forKey: .name)
        timestamp = try container.decodeXCResultTypeIfPresent(forKey: .timestamp)
//        userInfo = try container.decodeXCResultObjectIfPresent(forKey: .userInfo)
        lifetime = try container.decodeXCResultType(forKey: .lifetime)
        inActivityIdentifier = try container.decodeXCResultType(forKey: .inActivityIdentifier)
        filename = try container.decodeXCResultTypeIfPresent(forKey: .filename)
        payloadRef = try container.decodeXCResultObjectIfPresent(forKey: .payloadRef)
        payloadSize = try container.decodeXCResultType(forKey: .payloadSize)
        try super.init(from: decoder)
        let propertyList = ["uniformTypeIdentifier": uniformTypeIdentifier, "name": name, "timestamp": timestamp, "lifetime": lifetime, "inActivityIdentifier": inActivityIdentifier, "filename": filename, "payloadRef": payloadRef, "payloadSize": payloadSize] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestFailureSummary : XCResultObject {
    public let message: String?
    public let fileName: String
    public let lineNumber: Int
    public let isPerformanceFailure: Bool
    
    public enum ActionTestFailureSummaryCodingKeys: String, CodingKey {
        case message
        case fileName
        case lineNumber
        case isPerformanceFailure
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestFailureSummaryCodingKeys.self)
        message = try container.decodeXCResultTypeIfPresent(forKey: .message)
        fileName = try container.decodeXCResultType(forKey: .fileName)
        lineNumber = try container.decodeXCResultType(forKey: .lineNumber)
        isPerformanceFailure = try container.decodeXCResultType(forKey: .isPerformanceFailure)
        try super.init(from: decoder)
        let propertyList = ["message": message, "fileName": fileName, "lineNumber": lineNumber, "isPerformanceFailure": isPerformanceFailure] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestMetadata : ActionTestSummaryIdentifiableObject {
    public let testStatus: String
    public let duration: Double?
    public let summaryRef: Reference?
    public let performanceMetricsCount: Int
    public let failureSummariesCount: Int
    public let activitySummariesCount: Int
    
    public enum ActionTestMetadataCodingKeys: String, CodingKey {
        case testStatus
        case duration
        case summaryRef
        case performanceMetricsCount
        case failureSummariesCount
        case activitySummariesCount
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestMetadataCodingKeys.self)
        testStatus = try container.decodeXCResultType(forKey: .testStatus)
        duration = try container.decodeXCResultTypeIfPresent(forKey: .duration)
        summaryRef = try container.decodeXCResultObjectIfPresent(forKey: .summaryRef)
        
        // Despite formatDescription's insistence, these appear to be optional in the JSON output
        performanceMetricsCount = try container.decodeXCResultTypeIfPresent(forKey: .performanceMetricsCount) ?? 0
        failureSummariesCount = try container.decodeXCResultTypeIfPresent(forKey: .failureSummariesCount) ?? 0
        activitySummariesCount = try container.decodeXCResultTypeIfPresent(forKey: .activitySummariesCount) ?? 0
        try super.init(from: decoder)
        let propertyList = ["testStatus": testStatus, "duration": duration, "summaryRef": summaryRef, "performanceMetricsCount": performanceMetricsCount, "failureSummariesCount": failureSummariesCount, "activitySummariesCount": activitySummariesCount] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestPerformanceMetricSummary : XCResultObject {
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
    
    public enum ActionTestPerformanceMetricSummaryCodingKeys: String, CodingKey {
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
    
    public required init(from decoder: Decoder) throws {
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
        try super.init(from: decoder)
        let propertyList = ["displayName": displayName, "unitOfMeasurement": unitOfMeasurement, "measurements": measurements, "identifier": identifier, "baselineName": baselineName, "baselineAverage": baselineAverage, "maxPercentRegression": maxPercentRegression, "maxPercentRelativeStandardDeviation": maxPercentRelativeStandardDeviation, "maxRegression": maxRegression, "maxStandardDeviation": maxStandardDeviation] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestPlanRunSummaries : XCResultObject {
    public let summaries: [ActionTestPlanRunSummary]
    
    public enum ActionTestPlanRunSummariesCodingKeys: String, CodingKey {
        case summaries
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestPlanRunSummariesCodingKeys.self)

        let summaryValues = try container.decode(XCResultArrayValue<ActionTestPlanRunSummary>.self, forKey: .summaries)
        summaries = summaryValues.values
        try super.init(from: decoder)
        let propertyList = ["summaries": summaries] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestPlanRunSummary : ActionAbstractTestSummary {
    public let testableSummaries: [ActionTestableSummary]
    
    public enum ActionTestPlanRunSummaryCodingKeys: String, CodingKey {
        case testableSummaries
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestPlanRunSummaryCodingKeys.self)

        let summaryValues = try container.decode(XCResultArrayValue<ActionTestableSummary>.self, forKey: .testableSummaries)
        testableSummaries = summaryValues.values
        
        try super.init(from: decoder)
        let propertyList = ["testableSummaries": testableSummaries] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestSummary : ActionTestSummaryIdentifiableObject {
    public let testStatus: String
    public let duration: Double
    public let performanceMetrics: [ActionTestPerformanceMetricSummary]
    public let failureSummaries: [ActionTestFailureSummary]
    public let activitySummaries: [ActionTestActivitySummary]
    
    public enum ActionTestSummaryCodingKeys: String, CodingKey {
        case testStatus
        case duration
        case performanceMetrics
        case failureSummaries
        case activitySummaries
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)
        testStatus = try container.decodeXCResultType(forKey: .testStatus)
        
        performanceMetrics = try container.decodeIfPresent(XCResultArrayValue<ActionTestPerformanceMetricSummary>.self, forKey: .performanceMetrics)?.values ?? []
        failureSummaries = try container.decodeIfPresent(XCResultArrayValue<ActionTestFailureSummary>.self, forKey: .failureSummaries)?.values ?? []
        activitySummaries = try container.decodeIfPresent(XCResultArrayValue<ActionTestActivitySummary>.self, forKey: .activitySummaries)?.values ?? []
        
        try super.init(from: decoder)
        let propertyList = ["testStatus": testStatus, "duration": duration, "performanceMetrics": performanceMetrics, "failureSummaries": failureSummaries, "activitySummaries": activitySummaries] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestSummaryGroup : ActionTestSummaryIdentifiableObject {
    public let duration: Double
    public let subtests: [ActionTestSummaryIdentifiableObject]
    
    public enum ActionTestSummaryGroupCodingKeys: String, CodingKey {
        case duration
        case subtests
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryGroupCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)
        
        let subtestsValues = try container.decode(XCResultArrayValue<ActionTestSummaryIdentifiableObject>.self, forKey: .subtests)
        subtests = subtestsValues.values
        try super.init(from: decoder)
        let propertyList = ["duration": duration, "subtests": subtests] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestSummaryIdentifiableObject : ActionAbstractTestSummary {
    public let identifier: String?
    
    public enum ActionTestSummaryIdentifiableObjectCodingKeys: String, CodingKey {
        case identifier
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryIdentifiableObjectCodingKeys.self)
        identifier = try container.decodeXCResultTypeIfPresent(forKey: .identifier)
        try super.init(from: decoder)
        let propertyList = ["identifier": identifier] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionTestableSummary : ActionAbstractTestSummary {
    public let projectRelativePath: String?
    public let targetName: String?
    public let testKind: String?
    public let tests: [ActionTestSummaryIdentifiableObject]
    public let diagnosticsDirectoryName: String?
    public let failureSummaries: [ActionTestFailureSummary]
    public let testLanguage: String?
    public let testRegion: String?
    
    public enum ActionTestableSummaryCodingKeys: String, CodingKey {
        case projectRelativePath
        case targetName
        case testKind
        case tests
        case diagnosticsDirectoryName
        case failureSummaries
        case testLanguage
        case testRegion
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestableSummaryCodingKeys.self)
        projectRelativePath = try container.decodeXCResultTypeIfPresent(forKey: .projectRelativePath)
        targetName = try container.decodeXCResultTypeIfPresent(forKey: .targetName)
        testKind = try container.decodeXCResultTypeIfPresent(forKey: .testKind)

        tests = try container.decodeIfPresent(XCResultArrayValue<ActionTestSummaryIdentifiableObject>.self, forKey: .tests)?.values ?? []
        
        diagnosticsDirectoryName = try container.decodeXCResultTypeIfPresent(forKey: .diagnosticsDirectoryName)
        
        failureSummaries = try container.decodeIfPresent(XCResultArrayValue<ActionTestFailureSummary>.self, forKey: .failureSummaries)?.values ?? []
        
        testLanguage = try container.decodeXCResultTypeIfPresent(forKey: .testLanguage)
        testRegion = try container.decodeXCResultTypeIfPresent(forKey: .testRegion)
        
        try super.init(from: decoder)
        let propertyList = ["projectRelativePath": projectRelativePath, "targetName": targetName, "testKind": testKind, "tests": tests, "diagnosticsDirectoryName": diagnosticsDirectoryName, "failureSummaries": failureSummaries, "testLanguage": testLanguage, "testRegion": testRegion] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionsInvocationMetadata : XCResultObject {
    public let creatingWorkspaceFilePath: String
    public let uniqueIdentifier: String
    public let schemeIdentifier: EntityIdentifier?
    
    public enum ActionsInvocationMetadataCodingKeys: String, CodingKey {
        case creatingWorkspaceFilePath
        case uniqueIdentifier
        case schemeIdentifier
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionsInvocationMetadataCodingKeys.self)
        creatingWorkspaceFilePath = try container.decodeXCResultType(forKey: .creatingWorkspaceFilePath)
        uniqueIdentifier = try container.decodeXCResultType(forKey: .uniqueIdentifier)
        schemeIdentifier = try container.decodeXCResultObjectIfPresent(forKey: .schemeIdentifier)
        try super.init(from: decoder)
        let propertyList = ["creatingWorkspaceFilePath": creatingWorkspaceFilePath, "uniqueIdentifier": uniqueIdentifier, "schemeIdentifier": schemeIdentifier] as [String: Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActionsInvocationRecord : XCResultObject {
    public let metadataRef: Reference?
    public let metrics: ResultMetrics
    public let issues: ResultIssueSummaries
    public let actions: [ActionRecord]
    public let archive: ArchiveInfo?
    
    public enum ActionsInvocationRecordCodingKeys: String, CodingKey {
        case metadataRef
        case metrics
        case issues
        case actions
        case archive
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionsInvocationRecordCodingKeys.self)
        metadataRef = try container.decodeXCResultObjectIfPresent(forKey: .metadataRef)
        metrics = try container.decodeXCResultObject(forKey: .metrics)
        issues = try container.decodeXCResultObject(forKey: .issues)
        
        let actionValues = try container.decode(XCResultArrayValue<ActionRecord>.self, forKey: .actions)
        actions = actionValues.values
        archive = try container.decodeXCResultObjectIfPresent(forKey: .archive)
        try super.init(from: decoder)
        let propertyList = ["metadataRef": metadataRef as Reference?, "metrics": metrics as ResultMetrics, "issues": issues as ResultIssueSummaries, "actions": actions as [ActionRecord], "archive": archive as ArchiveInfo?] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActivityLogCommandInvocationSection : ActivityLogSection {
    public let commandDetails: String
    public let emittedOutput: String
    public let exitCode: Int?
    
    public enum ActivityLogCommandInvocationSectionCodingKeys: String, CodingKey {
        case commandDetails
        case emittedOutput
        case exitCode
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogCommandInvocationSectionCodingKeys.self)
        commandDetails = try container.decodeXCResultType(forKey: .commandDetails)
        emittedOutput = try container.decodeXCResultType(forKey: .emittedOutput)
        exitCode = try container.decodeXCResultTypeIfPresent(forKey: .exitCode)
        try super.init(from: decoder)
        let propertyList = ["commandDetails": commandDetails, "emittedOutput": emittedOutput, "exitCode": exitCode] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActivityLogMajorSection : ActivityLogSection {
    public let subtitle: String
    
    public enum ActivityLogMajorSectionCodingKeys: String, CodingKey {
        case subtitle
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogMajorSectionCodingKeys.self)
        subtitle = try container.decodeXCResultType(forKey: .subtitle)
        try super.init(from: decoder)
        let propertyList = ["subtitle": subtitle] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActivityLogMessage : XCResultObject {
    public let title: String
    public let shortTitle: String?
    public let category: String?
    public let location: DocumentLocation?
    public let annotations: [ActivityLogMessageAnnotation]
    
    public enum ActivityLogMessageCodingKeys: String, CodingKey {
        case type
        case title
        case shortTitle
        case category
        case location
        case annotations
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogMessageCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        shortTitle = try container.decodeXCResultTypeIfPresent(forKey: .shortTitle)
        category = try container.decodeXCResultTypeIfPresent(forKey: .category)
        location = try container.decodeXCResultObjectIfPresent(forKey: .location)
        
        let annotationValues = try container.decode(XCResultArrayValue<ActivityLogMessageAnnotation>.self, forKey: .annotations)
        annotations = annotationValues.values
        try super.init(from: decoder)
        type = try container.decodeXCResultType(forKey: .type)
        let propertyList = ["type": type, "title": title, "shortTitle": shortTitle, "category": category, "location": location, "annotations": annotations] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActivityLogMessageAnnotation : XCResultObject {
    public let title: String
    public let location: DocumentLocation?
    
    public enum ActivityLogMessageCodingKeys: String, CodingKey {
        case title
        case location
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogMessageCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        location = try container.decodeXCResultObjectIfPresent(forKey: .location)
        try super.init(from: decoder)
        let propertyList = ["title": title, "location": location] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActivityLogSection : XCResultObject {
    public let domainType: String
    public let title: String
    public let startTime: Date?
    public let duration: Double
    public let result: String?
    public let subsections: [ActivityLogSection]
    public let messages: [ActivityLogMessage]
    
    public enum ActivityLogSectionCodingKeys: String, CodingKey {
        case domainType
        case title
        case startTime
        case duration
        case result
        case subsections
        case messages
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogSectionCodingKeys.self)
        domainType = try container.decodeXCResultType(forKey: .domainType)
        title = try container.decodeXCResultType(forKey: .title)
        startTime = try container.decodeXCResultTypeIfPresent(forKey: .startTime)
        duration = try container.decodeXCResultType(forKey: .duration)
        result = try container.decodeXCResultTypeIfPresent(forKey: .result)
        
        let subsectionValues = try container.decode(XCResultArrayValue<ActivityLogSection>.self, forKey: .subsections)
        subsections = subsectionValues.values
        
        let messageValues = try container.decode(XCResultArrayValue<ActivityLogMessage>.self, forKey: .messages)
        messages = messageValues.values
        try super.init(from: decoder)
        let propertyList = ["domainType": domainType, "title": title, "startTime": startTime, "duration": duration, "result": result, "subsections": subsections, "messages": messages] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActivityLogTargetBuildSection : ActivityLogMajorSection {
    public let productType: String?
    
    public enum ActivityLogTargetBuildSectionCodingKeys: String, CodingKey {
        case productType
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogTargetBuildSectionCodingKeys.self)
        productType = try container.decodeXCResultTypeIfPresent(forKey: .productType)
        try super.init(from: decoder)
        let propertyList = ["productType": productType] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ActivityLogUnitTestSection : ActivityLogSection {
    public let testName: String?
    public let suiteName: String?
    public let summary: String?
    public let emittedOutput: String?
    public let performanceTestOutput: String?
    public let testsPassedString: String?
    public let runnablePath: String?
    public let runnableUTI: String?
    
    public enum ActivityLogUnitTestSectionCodingKeys: String, CodingKey {
        case testName
        case suiteName
        case summary
        case emittedOutput
        case performanceTestOutput
        case testsPassedString
        case runnablePath
        case runnableUTI
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogUnitTestSectionCodingKeys.self)
        testName = try container.decodeXCResultTypeIfPresent(forKey: .testName)
        suiteName = try container.decodeXCResultTypeIfPresent(forKey: .suiteName)
        summary = try container.decodeXCResultTypeIfPresent(forKey: .summary)
        emittedOutput = try container.decodeXCResultTypeIfPresent(forKey: .emittedOutput)
        performanceTestOutput = try container.decodeXCResultTypeIfPresent(forKey: .performanceTestOutput)
        testsPassedString = try container.decodeXCResultTypeIfPresent(forKey: .testsPassedString)
        runnablePath = try container.decodeXCResultTypeIfPresent(forKey: .runnablePath)
        runnableUTI = try container.decodeXCResultTypeIfPresent(forKey: .runnableUTI)
        try super.init(from: decoder)
        let propertyList = ["testName": testName, "suiteName": suiteName, "summary": summary, "emittedOutput": emittedOutput, "performanceTestOutput": performanceTestOutput, "testsPassedString": testsPassedString, "runnablePath": runnablePath, "runnableUTI": runnableUTI] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ArchiveInfo : XCResultObject {
    public let path: String?
    
    public enum ArchiveInfoCodingKeys: String, CodingKey {
        case path
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArchiveInfoCodingKeys.self)
        path = try container.decodeXCResultTypeIfPresent(forKey: .path)
        try super.init(from: decoder)
        let propertyList = ["path": path] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

//class Array : Codable {
//    // TODO: Alex - fill this in
//}

//class Bool : Codable {
//    // TODO: Alex - fill this in
//}

open class CodeCoverageInfo : XCResultObject {
    public let hasCoverageData: Bool
    public let reportRef: Reference?
    public let archiveRef: Reference?
    
    public enum CodeCoverageInfoCodingKeys: String, CodingKey {
        case hasCoverageData
        case reportRef
        case archiveRef
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodeCoverageInfoCodingKeys.self)
        hasCoverageData = try container.decodeXCResultTypeIfPresent(forKey: .hasCoverageData) ?? false
        reportRef = try container.decodeXCResultObjectIfPresent(forKey: .reportRef)
        archiveRef = try container.decodeXCResultObjectIfPresent(forKey: .archiveRef)
        try super.init(from: decoder)
        let propertyList = ["hasCoverageData": hasCoverageData, "reportRef": reportRef, "archiveRef": archiveRef] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

//class Date : Codable {
//    // TODO: Alex - fill this in
//}

open class DocumentLocation : XCResultObject {
    public let url: String
    public let concreteTypeName: String
    
    public enum DocumentLocationCodingKeys: String, CodingKey {
        case url
        case concreteTypeName
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DocumentLocationCodingKeys.self)
        url = try container.decodeXCResultType(forKey: .url)
        concreteTypeName = try container.decodeXCResultType(forKey: .concreteTypeName)
        try super.init(from: decoder)
        let propertyList = ["url": url, "concreteTypeName": concreteTypeName] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

//class Double : Codable {
//    // TODO: Alex - fill this in
//}

open class EntityIdentifier : XCResultObject {
    public let entityName: String
    public let containerName: String
    public let entityType: String
    public let sharedState: String
    
    public enum EntityIdentifierCodingKeys: String, CodingKey {
        case entityName
        case containerName
        case entityType
        case sharedState
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EntityIdentifierCodingKeys.self)
        entityName = try container.decodeXCResultType(forKey: .entityName)
        containerName = try container.decodeXCResultType(forKey: .containerName)
        entityType = try container.decodeXCResultType(forKey: .entityType)
        sharedState = try container.decodeXCResultType(forKey: .sharedState)
        try super.init(from: decoder)
        let propertyList = ["entityName": entityName, "containerName": containerName, "entityType": entityType, "sharedState": sharedState] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

//class Int : Codable {
//    // TODO: Alex - fill this in
//}

open class IssueSummary : XCResultObject {
    public let issueType: String
    public let message: String
    public let producingTarget: String?
    public let documentLocationInCreatingWorkspace: DocumentLocation?
    
    public enum EntityIdentifierCodingKeys: String, CodingKey {
        case issueType
        case message
        case producingTarget
        case documentLocationInCreatingWorkspace
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EntityIdentifierCodingKeys.self)
        issueType = try container.decodeXCResultType(forKey: .issueType)
        message = try container.decodeXCResultType(forKey: .message)
        producingTarget = try container.decodeXCResultTypeIfPresent(forKey: .producingTarget)
        documentLocationInCreatingWorkspace = try container.decodeXCResultObjectIfPresent(forKey: .documentLocationInCreatingWorkspace)
        try super.init(from: decoder)
        let propertyList = ["issueType": issueType, "message": message, "producingTarget": producingTarget, "documentLocationInCreatingWorkspace": documentLocationInCreatingWorkspace] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ObjectID : XCResultObject {
    public let hash: String
    
    public enum ObjectIDCodingKeys: String, CodingKey {
        case hash
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ObjectIDCodingKeys.self)
        hash = try container.decodeXCResultType(forKey: .hash)
        try super.init(from: decoder)
        let propertyList = ["hash": hash] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
        
    }
}

open class Reference : XCResultObject {
    public let id: String
    public let targetType: TypeDefinition?
    
    public enum ReferenceCodingKeys: String, CodingKey {
        case id
        case targetType
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReferenceCodingKeys.self)
        id = try container.decodeXCResultType(forKey: .id)
        targetType = try container.decodeXCResultObjectIfPresent(forKey: .targetType)
        try super.init(from: decoder)
        let propertyList = ["id": id, "targetType": targetType] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ResultIssueSummaries : XCResultObject {
    public let analyzerWarningSummaries: [IssueSummary]
    public let errorSummaries: [IssueSummary]
    public let testFailureSummaries: [TestFailureIssueSummary]
    public let warningSummaries: [IssueSummary]
    
    public enum ResultIssueSummariesCodingKeys: String, CodingKey {
        case analyzerWarningSummaries
        case errorSummaries
        case testFailureSummaries
        case warningSummaries
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultIssueSummariesCodingKeys.self)
        analyzerWarningSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .analyzerWarningSummaries)?.values ?? []
        errorSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .errorSummaries)?.values ?? []
        testFailureSummaries = try container.decodeIfPresent(XCResultArrayValue<TestFailureIssueSummary>.self, forKey: .testFailureSummaries)?.values ?? []
        warningSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .warningSummaries)?.values ?? []
        try super.init(from: decoder)
        let propertyList = ["analyzerWarningSummaries": analyzerWarningSummaries, "errorSummaries": errorSummaries, "testFailureSummaries": testFailureSummaries, "warningSummaries": warningSummaries] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class ResultMetrics : XCResultObject {
    public let analyzerWarningCount: Int
    public let errorCount: Int
    public let testsCount: Int
    public let testsFailedCount: Int
    public let warningCount: Int
    
    public enum ResultMetricsCodingKeys: String, CodingKey {
        case analyzerWarningCount
        case errorCount
        case testsCount
        case testsFailedCount
        case warningCount
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultMetricsCodingKeys.self)
        analyzerWarningCount = try container.decodeXCResultTypeIfPresent(forKey: .analyzerWarningCount) ?? 0
        errorCount = try container.decodeXCResultTypeIfPresent(forKey: .errorCount) ?? 0
        testsCount = try container.decodeXCResultTypeIfPresent(forKey: .testsCount) ?? 0
        testsFailedCount = try container.decodeXCResultTypeIfPresent(forKey: .testsFailedCount) ?? 0
        warningCount = try container.decodeXCResultTypeIfPresent(forKey: .warningCount) ?? 0
        try super.init(from: decoder)
        let propertyList = ["analyzerWarningCount": analyzerWarningCount, "errorCount": errorCount, "testsCount": testsCount, "testsFailedCount": testsFailedCount, "warningCount": warningCount] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

//class SortedKeyValueArray : Codable {
//    let storage: [SortedKeyValueArrayPair]
//}

//class SortedKeyValueArrayPair : Codable {
//    let key: String
//    let value: Codable
//    // TODO: Alex - fill this in
//}

//class String : Codable {
//    // TODO: Alex - fill this in
//}

open class TestFailureIssueSummary : IssueSummary {
    public let testCaseName: String
    
    public enum TestFailureIssueSummaryCodingKeys: String, CodingKey {
        case testCaseName
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestFailureIssueSummaryCodingKeys.self)
        testCaseName = try container.decodeXCResultType(forKey: .testCaseName)
        try super.init(from: decoder)
        let propertyList = ["testCaseName": testCaseName] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}

open class TypeDefinition : XCResultObject {
    public let name: String
    public let supertype: TypeDefinition?
    
    public enum TypeDefinitionCodingKeys: String, CodingKey {
        case name
        case supertype
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TypeDefinitionCodingKeys.self)
        name = try container.decodeXCResultType(forKey: .name)
        supertype = try container.decodeXCResultObjectIfPresent(forKey: .supertype)
        try super.init(from: decoder)
        let propertyList = ["name": name, "supertype": supertype] as [String : Any]
        self.appendToProperties(propertyList: propertyList)
    }
}


