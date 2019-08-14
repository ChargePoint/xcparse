//
//  XCPResultTypes.swift
//  xcparse
//
//  Created by Alex Botkin on 8/13/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation


class ActionAbstractTestSummary : Codable {
    let name: String?
    
    enum ActionAbstractTestSummaryCodingKeys: String, CodingKey {
        case name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionAbstractTestSummaryCodingKeys.self)
        name = try container.decodeXCResultTypeIfPresent(forKey: .name)
    }
}

class ActionDeviceRecord : Codable {
    let name: String
    let isConcreteDevice: Bool
    let operatingSystemVersion: String
    let operatingSystemVersionWithBuildNumber: String
    let nativeArchitecture: String
    let modelName: String
    let modelCode: String
    let modelUTI: String
    let identifier: String
    let isWireless: Bool
    let cpuKind: String
    let cpuCount: Int?
    let cpuSpeedInMHz: Int?
    let busSpeedInMHz: Int?
    let ramSizeInMegabytes: Int?
    let physicalCPUCoresPerPackage: Int?
    let logicalCPUCoresPerPackage: Int?
    let platformRecord: ActionPlatformRecord
    
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
    
    required init(from decoder: Decoder) throws {
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
    }
}

class ActionPlatformRecord : Codable {
    let identifier: String
    let userDescription: String
    
    enum ActionPlatformRecordCodingKeys: String, CodingKey {
        case identifier
        case userDescription
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionPlatformRecordCodingKeys.self)
        identifier = try container.decodeXCResultType(forKey: .identifier)
        userDescription = try container.decodeXCResultType(forKey: .userDescription)
    }
}

class ActionRecord : Codable {
    let schemeCommandName: String
    let schemeTaskName: String
    let title: String?
    let startedTime: Date
    let endedTime: Date
    let runDestination: ActionRunDestinationRecord
    let buildResult: ActionResult
    let actionResult: ActionResult
    
    enum ActionRecordCodingKeys: String, CodingKey {
        case schemeCommandName
        case schemeTaskName
        case title
        case startedTime
        case endedTime
        case runDestination
        case buildResult
        case actionResult
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionRecordCodingKeys.self)
        schemeCommandName = try container.decodeXCResultType(forKey: .schemeCommandName)
        schemeTaskName = try container.decodeXCResultType(forKey: .schemeTaskName)
        title = try container.decodeXCResultTypeIfPresent(forKey: .title)
        startedTime = try container.decodeXCResultType(forKey: .startedTime)
        endedTime = try container.decodeXCResultType(forKey: .endedTime)
        runDestination = try container.decodeXCResultObject(forKey: .runDestination)
        buildResult = try container.decodeXCResultObject(forKey: .buildResult)
        actionResult = try container.decodeXCResultObject(forKey: .actionResult)
    }
}

class ActionResult : Codable {
    let resultName: String
    let status: String
    let metrics: ResultMetrics
    let issues: ResultIssueSummaries
    let coverage: CodeCoverageInfo
    let timelineRef: Reference?
    let logRef: Reference?
    let testsRef: Reference?
    let diagnosticsRef: Reference?
    
    enum ActionResultCodingKeys: String, CodingKey {
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
    
    required init(from decoder: Decoder) throws {
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
    }
}

class ActionRunDestinationRecord : Codable {
    let displayName: String
    let targetArchitecture: String
    let targetDeviceRecord: ActionDeviceRecord
    let localComputerRecord: ActionDeviceRecord
    let targetSDKRecord: ActionSDKRecord
    
    enum ActionRunDestinationRecordCodingKeys: String, CodingKey {
        case displayName
        case targetArchitecture
        case targetDeviceRecord
        case localComputerRecord
        case targetSDKRecord
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionRunDestinationRecordCodingKeys.self)
        displayName = try container.decodeXCResultType(forKey: .displayName)
        targetArchitecture = try container.decodeXCResultType(forKey: .targetArchitecture)
        targetDeviceRecord = try container.decodeXCResultObject(forKey: .targetDeviceRecord)
        localComputerRecord = try container.decodeXCResultObject(forKey: .localComputerRecord)
        targetSDKRecord = try container.decodeXCResultObject(forKey: .targetSDKRecord)
    }
}

class ActionSDKRecord : Codable {
    let name: String
    let identifier: String
    let operatingSystemVersion: String
    let isInternal: Bool
    
    enum ActionSDKRecordCodingKeys: String, CodingKey {
        case name
        case identifier
        case operatingSystemVersion
        case isInternal
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionSDKRecordCodingKeys.self)
        name = try container.decodeXCResultType(forKey: .name)
        identifier = try container.decodeXCResultType(forKey: .identifier)
        operatingSystemVersion = try container.decodeXCResultType(forKey: .operatingSystemVersion)
        isInternal = try container.decodeXCResultTypeIfPresent(forKey: .isInternal) ?? false
    }
}

class ActionTestActivitySummary : Codable {
    let title: String
    let activityType: String
    let uuid: String
    let start: Date?
    let finish: Date?
    let attachments: [ActionTestAttachment]
    let subactivities: [ActionTestActivitySummary]
    
    enum ActionTestActivitySummaryCodingKeys: String, CodingKey {
        case title
        case activityType
        case uuid
        case start
        case finish
        case attachments
        case subactivities
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestActivitySummaryCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        activityType = try container.decodeXCResultType(forKey: .activityType)
        uuid = try container.decodeXCResultType(forKey: .uuid)
        start = try container.decodeXCResultTypeIfPresent(forKey: .start)
        finish = try container.decodeXCResultTypeIfPresent(forKey: .finish)
        
        attachments = try container.decodeIfPresent(XCResultArrayValue<ActionTestAttachment>.self, forKey: .attachments)?.values ?? []
        subactivities = try container.decodeIfPresent(XCResultArrayValue<ActionTestActivitySummary>.self, forKey: .subactivities)?.values ?? []
    }
}

class ActionTestAttachment : Codable {
    let uniformTypeIdentifier: String
    let name: String?
    let timestamp: Date?
//    let userInfo: SortedKeyValueArray?
    let lifetime: String
    let inActivityIdentifier: Int
    let filename: String?
    let payloadRef: Reference?
    let payloadSize: Int
    
    enum ActionTestAttachmentCodingKeys: String, CodingKey {
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
    
    required init(from decoder: Decoder) throws {
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
    }
}

class ActionTestFailureSummary : Codable {
    let message: String?
    let fileName: String
    let lineNumber: Int
    let isPerformanceFailure: Bool
    
    enum ActionTestFailureSummaryCodingKeys: String, CodingKey {
        case message
        case fileName
        case lineNumber
        case isPerformanceFailure
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestFailureSummaryCodingKeys.self)
        message = try container.decodeXCResultTypeIfPresent(forKey: .message)
        fileName = try container.decodeXCResultType(forKey: .fileName)
        lineNumber = try container.decodeXCResultType(forKey: .lineNumber)
        isPerformanceFailure = try container.decodeXCResultType(forKey: .isPerformanceFailure)
    }
}

class ActionTestMetadata : ActionTestSummaryIdentifiableObject {
    let testStatus: String
    let duration: Double?
    let summaryRef: Reference?
    let performanceMetricsCount: Int
    let failureSummariesCount: Int
    let activitySummariesCount: Int
    
    enum ActionTestMetadataCodingKeys: String, CodingKey {
        case testStatus
        case duration
        case summaryRef
        case performanceMetricsCount
        case failureSummariesCount
        case activitySummariesCount
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestMetadataCodingKeys.self)
        testStatus = try container.decodeXCResultType(forKey: .testStatus)
        duration = try container.decodeXCResultTypeIfPresent(forKey: .duration)
        summaryRef = try container.decodeXCResultObjectIfPresent(forKey: .summaryRef)
        
        // Despite formatDescription's insistence, these appear to be optional in the JSON output
        performanceMetricsCount = try container.decodeXCResultTypeIfPresent(forKey: .performanceMetricsCount) ?? 0
        failureSummariesCount = try container.decodeXCResultTypeIfPresent(forKey: .failureSummariesCount) ?? 0
        activitySummariesCount = try container.decodeXCResultTypeIfPresent(forKey: .activitySummariesCount) ?? 0
        
        try super.init(from: decoder)
    }
}

class ActionTestPerformanceMetricSummary : Codable {
    let displayName: String
    let unitOfMeasurement: String
    let measurements: [Double]
    let identifier: String?
    let baselineName: String?
    let baselineAverage: Double?
    let maxPercentRegression: Double?
    let maxPercentRelativeStandardDeviation: Double?
    let maxRegression: Double?
    let maxStandardDeviation: Double?
    
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
    
    required init(from decoder: Decoder) throws {
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

class ActionTestPlanRunSummaries : Codable {
    let summaries: [ActionTestPlanRunSummary]
    
    enum ActionTestPlanRunSummariesCodingKeys: String, CodingKey {
        case summaries
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestPlanRunSummariesCodingKeys.self)

        let summaryValues = try container.decode(XCResultArrayValue<ActionTestPlanRunSummary>.self, forKey: .summaries)
        summaries = summaryValues.values
    }
}

class ActionTestPlanRunSummary : ActionAbstractTestSummary {
    let testableSummaries: [ActionTestableSummary]
    
    enum ActionTestPlanRunSummaryCodingKeys: String, CodingKey {
        case testableSummaries
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestPlanRunSummaryCodingKeys.self)

        let summaryValues = try container.decode(XCResultArrayValue<ActionTestableSummary>.self, forKey: .testableSummaries)
        testableSummaries = summaryValues.values
        
        try super.init(from: decoder)
    }
}

class ActionTestSummary : ActionTestSummaryIdentifiableObject {
    let testStatus: String
    let duration: Double
    let performanceMetrics: [ActionTestPerformanceMetricSummary]
    let failureSummaries: [ActionTestFailureSummary]
    let activitySummaries: [ActionTestActivitySummary]
    
    enum ActionTestSummaryCodingKeys: String, CodingKey {
        case testStatus
        case duration
        case performanceMetrics
        case failureSummaries
        case activitySummaries
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)
        testStatus = try container.decodeXCResultType(forKey: .testStatus)
        
        performanceMetrics = try container.decodeIfPresent(XCResultArrayValue<ActionTestPerformanceMetricSummary>.self, forKey: .performanceMetrics)?.values ?? []
        failureSummaries = try container.decodeIfPresent(XCResultArrayValue<ActionTestFailureSummary>.self, forKey: .failureSummaries)?.values ?? []
        activitySummaries = try container.decodeIfPresent(XCResultArrayValue<ActionTestActivitySummary>.self, forKey: .activitySummaries)?.values ?? []
        
        try super.init(from: decoder)
    }
}

class ActionTestSummaryGroup : ActionTestSummaryIdentifiableObject {
    let duration: Double
    let subtests: [ActionTestSummaryIdentifiableObject]
    
    enum ActionTestSummaryGroupCodingKeys: String, CodingKey {
        case duration
        case subtests
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryGroupCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)
        
        let subtestsValues = try container.decode(XCResultArrayValue<ActionTestSummaryIdentifiableObject>.self, forKey: .subtests)
        subtests = subtestsValues.values
        try super.init(from: decoder)
    }
}

class ActionTestSummaryIdentifiableObject : ActionAbstractTestSummary {
    let identifier: String?
    
    enum ActionTestSummaryIdentifiableObjectCodingKeys: String, CodingKey {
        case identifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryIdentifiableObjectCodingKeys.self)
        identifier = try container.decodeXCResultTypeIfPresent(forKey: .identifier)
        try super.init(from: decoder)
    }
}

class ActionTestableSummary : ActionAbstractTestSummary {
    let projectRelativePath: String?
    let targetName: String?
    let testKind: String?
    let tests: [ActionTestSummaryIdentifiableObject]
    let diagnosticsDirectoryName: String?
    let failureSummaries: [ActionTestFailureSummary]
    let testLanguage: String?
    let testRegion: String?
    
    enum ActionTestableSummaryCodingKeys: String, CodingKey {
        case projectRelativePath
        case targetName
        case testKind
        case tests
        case diagnosticsDirectoryName
        case failureSummaries
        case testLanguage
        case testRegion
    }
    
    required init(from decoder: Decoder) throws {
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
    }
}

class ActionsInvocationMetadata : Codable {
    let creatingWorkspaceFilePath: String
    let uniqueIdentifier: String
    let schemeIdentifier: EntityIdentifier?
    
    enum ActionsInvocationMetadataCodingKeys: String, CodingKey {
        case creatingWorkspaceFilePath
        case uniqueIdentifier
        case schemeIdentifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionsInvocationMetadataCodingKeys.self)
        creatingWorkspaceFilePath = try container.decodeXCResultType(forKey: .creatingWorkspaceFilePath)
        uniqueIdentifier = try container.decodeXCResultType(forKey: .uniqueIdentifier)
        schemeIdentifier = try container.decodeXCResultObjectIfPresent(forKey: .schemeIdentifier)
    }
}

class ActionsInvocationRecord : Codable {
    let metadataRef: Reference?
    let metrics: ResultMetrics
    let issues: ResultIssueSummaries
    let actions: [ActionRecord]
    let archive: ArchiveInfo?
    
    enum ActionsInvocationRecordCodingKeys: String, CodingKey {
        case metadataRef
        case metrics
        case issues
        case actions
        case archive
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionsInvocationRecordCodingKeys.self)
        metadataRef = try container.decodeXCResultObjectIfPresent(forKey: .metadataRef)
        metrics = try container.decodeXCResultObject(forKey: .metrics)
        issues = try container.decodeXCResultObject(forKey: .issues)
        
        let actionValues = try container.decode(XCResultArrayValue<ActionRecord>.self, forKey: .actions)
        actions = actionValues.values
        
        archive = try container.decodeXCResultObjectIfPresent(forKey: .archive)
    }
}

class ActivityLogCommandInvocationSection : ActivityLogSection {
    let commandDetails: String
    let emittedOutput: String
    let exitCode: Int?
    
    enum ActivityLogCommandInvocationSectionCodingKeys: String, CodingKey {
        case commandDetails
        case emittedOutput
        case exitCode
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogCommandInvocationSectionCodingKeys.self)
        commandDetails = try container.decodeXCResultType(forKey: .commandDetails)
        emittedOutput = try container.decodeXCResultType(forKey: .emittedOutput)
        exitCode = try container.decodeXCResultTypeIfPresent(forKey: .exitCode)
        try super.init(from: decoder)
    }
}

class ActivityLogMajorSection : ActivityLogSection {
    let subtitle: String
    
    enum ActivityLogMajorSectionCodingKeys: String, CodingKey {
        case subtitle
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogMajorSectionCodingKeys.self)
        subtitle = try container.decodeXCResultType(forKey: .subtitle)
        try super.init(from: decoder)
    }
}

class ActivityLogMessage : Codable {
    let type: String
    let title: String
    let shortTitle: String?
    let category: String?
    let location: DocumentLocation?
    let annotations: [ActivityLogMessageAnnotation]
    
    enum ActivityLogMessageCodingKeys: String, CodingKey {
        case type
        case title
        case shortTitle
        case category
        case location
        case annotations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogMessageCodingKeys.self)
        type = try container.decodeXCResultType(forKey: .type)
        title = try container.decodeXCResultType(forKey: .title)
        shortTitle = try container.decodeXCResultTypeIfPresent(forKey: .shortTitle)
        category = try container.decodeXCResultTypeIfPresent(forKey: .category)
        location = try container.decodeXCResultObjectIfPresent(forKey: .location)
        
        let annotationValues = try container.decode(XCResultArrayValue<ActivityLogMessageAnnotation>.self, forKey: .annotations)
        annotations = annotationValues.values
    }
}

class ActivityLogMessageAnnotation : Codable {
    let title: String
    let location: DocumentLocation?
    
    enum ActivityLogMessageCodingKeys: String, CodingKey {
        case title
        case location
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogMessageCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        location = try container.decodeXCResultObjectIfPresent(forKey: .location)
    }
}

class ActivityLogSection : Codable {
    let domainType: String
    let title: String
    let startTime: Date?
    let duration: Double
    let result: String?
    let subsections: [ActivityLogSection]
    let messages: [ActivityLogMessage]
    
    enum ActivityLogSectionCodingKeys: String, CodingKey {
        case domainType
        case title
        case startTime
        case duration
        case result
        case subsections
        case messages
    }
    
    required init(from decoder: Decoder) throws {
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
    }
}

class ActivityLogTargetBuildSection : ActivityLogMajorSection {
    let productType: String?
    
    enum ActivityLogTargetBuildSectionCodingKeys: String, CodingKey {
        case productType
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogTargetBuildSectionCodingKeys.self)
        productType = try container.decodeXCResultTypeIfPresent(forKey: .productType)
        try super.init(from: decoder)
    }
}

class ActivityLogUnitTestSection : ActivityLogSection {
    let testName: String?
    let suiteName: String?
    let summary: String?
    let emittedOutput: String?
    let performanceTestOutput: String?
    let testsPassedString: String?
    let runnablePath: String?
    let runnableUTI: String?
    
    enum ActivityLogUnitTestSectionCodingKeys: String, CodingKey {
        case testName
        case suiteName
        case summary
        case emittedOutput
        case performanceTestOutput
        case testsPassedString
        case runnablePath
        case runnableUTI
    }
    
    required init(from decoder: Decoder) throws {
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
    }
}

class ArchiveInfo : Codable {
    let path: String?
    
    enum ArchiveInfoCodingKeys: String, CodingKey {
        case path
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArchiveInfoCodingKeys.self)
        path = try container.decodeXCResultTypeIfPresent(forKey: .path)
    }
}

//class Array : Codable {
//    // TODO: Alex - fill this in
//}

//class Bool : Codable {
//    // TODO: Alex - fill this in
//}

class CodeCoverageInfo : Codable {
    let hasCoverageData: Bool
    let reportRef: Reference?
    let archiveRef: Reference?
    
    enum CodeCoverageInfoCodingKeys: String, CodingKey {
        case hasCoverageData
        case reportRef
        case archiveRef
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodeCoverageInfoCodingKeys.self)
        hasCoverageData = try container.decodeXCResultTypeIfPresent(forKey: .hasCoverageData) ?? false
        reportRef = try container.decodeXCResultObjectIfPresent(forKey: .reportRef)
        archiveRef = try container.decodeXCResultObjectIfPresent(forKey: .archiveRef)
    }
}

//class Date : Codable {
//    // TODO: Alex - fill this in
//}

class DocumentLocation : Codable {
    let url: String
    let concreteTypeName: String
    
    enum DocumentLocationCodingKeys: String, CodingKey {
        case url
        case concreteTypeName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DocumentLocationCodingKeys.self)
        url = try container.decodeXCResultType(forKey: .url)
        concreteTypeName = try container.decodeXCResultType(forKey: .concreteTypeName)
    }
}

//class Double : Codable {
//    // TODO: Alex - fill this in
//}

class EntityIdentifier : Codable {
    let entityName: String
    let containerName: String
    let entityType: String
    let sharedState: String
    
    enum EntityIdentifierCodingKeys: String, CodingKey {
        case entityName
        case containerName
        case entityType
        case sharedState
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EntityIdentifierCodingKeys.self)
        entityName = try container.decodeXCResultType(forKey: .entityName)
        containerName = try container.decodeXCResultType(forKey: .containerName)
        entityType = try container.decodeXCResultType(forKey: .entityType)
        sharedState = try container.decodeXCResultType(forKey: .sharedState)
    }
}

//class Int : Codable {
//    // TODO: Alex - fill this in
//}

class IssueSummary : Codable {
    let issueType: String
    let message: String
    let producingTarget: String?
    let documentLocationInCreatingWorkspace: DocumentLocation?
    
    enum EntityIdentifierCodingKeys: String, CodingKey {
        case issueType
        case message
        case producingTarget
        case documentLocationInCreatingWorkspace
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EntityIdentifierCodingKeys.self)
        issueType = try container.decodeXCResultType(forKey: .issueType)
        message = try container.decodeXCResultType(forKey: .message)
        producingTarget = try container.decodeXCResultTypeIfPresent(forKey: .producingTarget)
        documentLocationInCreatingWorkspace = try container.decodeXCResultObjectIfPresent(forKey: .documentLocationInCreatingWorkspace)
    }
}

class ObjectID : Codable {
    let hash: String
    
    enum ObjectIDCodingKeys: String, CodingKey {
        case hash
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ObjectIDCodingKeys.self)
        hash = try container.decodeXCResultType(forKey: .hash)
    }
}

class Reference : Codable {
    let id: String
    let targetType: TypeDefinition?
    
    enum ReferenceCodingKeys: String, CodingKey {
        case id
        case targetType
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReferenceCodingKeys.self)
        id = try container.decodeXCResultType(forKey: .id)
        targetType = try container.decodeXCResultObjectIfPresent(forKey: .targetType)
    }
}

class ResultIssueSummaries : Codable {
    let analyzerWarningSummaries: [IssueSummary]
    let errorSummaries: [IssueSummary]
    let testFailureSummaries: [TestFailureIssueSummary]
    let warningSummaries: [IssueSummary]
    
    enum ResultIssueSummariesCodingKeys: String, CodingKey {
        case analyzerWarningSummaries
        case errorSummaries
        case testFailureSummaries
        case warningSummaries
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultIssueSummariesCodingKeys.self)
        analyzerWarningSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .analyzerWarningSummaries)?.values ?? []
        errorSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .errorSummaries)?.values ?? []
        testFailureSummaries = try container.decodeIfPresent(XCResultArrayValue<TestFailureIssueSummary>.self, forKey: .testFailureSummaries)?.values ?? []
        warningSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .warningSummaries)?.values ?? []
    }
}

class ResultMetrics : Codable {
    let analyzerWarningCount: Int
    let errorCount: Int
    let testsCount: Int
    let testsFailedCount: Int
    let warningCount: Int
    
    enum ResultMetricsCodingKeys: String, CodingKey {
        case analyzerWarningCount
        case errorCount
        case testsCount
        case testsFailedCount
        case warningCount
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultMetricsCodingKeys.self)
        analyzerWarningCount = try container.decodeXCResultTypeIfPresent(forKey: .analyzerWarningCount) ?? 0
        errorCount = try container.decodeXCResultTypeIfPresent(forKey: .errorCount) ?? 0
        testsCount = try container.decodeXCResultTypeIfPresent(forKey: .testsCount) ?? 0
        testsFailedCount = try container.decodeXCResultTypeIfPresent(forKey: .testsFailedCount) ?? 0
        warningCount = try container.decodeXCResultTypeIfPresent(forKey: .warningCount) ?? 0
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

class TestFailureIssueSummary : IssueSummary {
    let testCaseName: String
    
    enum TestFailureIssueSummaryCodingKeys: String, CodingKey {
        case testCaseName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestFailureIssueSummaryCodingKeys.self)
        testCaseName = try container.decodeXCResultType(forKey: .testCaseName)
        try super.init(from: decoder)
    }
}

class TypeDefinition : Codable {
    let name: String
    let supertype: TypeDefinition?
    
    enum TypeDefinitionCodingKeys: String, CodingKey {
        case name
        case supertype
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TypeDefinitionCodingKeys.self)
        name = try container.decodeXCResultType(forKey: .name)
        supertype = try container.decodeXCResultObjectIfPresent(forKey: .supertype)
    }
}

