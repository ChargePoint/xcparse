//
//  CPTFileFormat.swift
//  xcparse
//
//  Created by Alex Botkin on 8/1/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import Mantle

// TODO: Alex - need to figure out Supertype
// TODO: Alex - need to figure out JSON parsing

struct ActionAbstractTestSummary : Codable {
    let name: String?
}

@objc public class ActionDeviceRecord : MTLModel, MTLJSONSerializing {
    @objc var name: String = ""
    @objc var isConcreteDevice: Bool = false
    @objc var operatingSystemVersion: String = ""
    @objc var operatingSystemVersionWithBuildNumber: String = ""
    @objc var nativeArchitecture: String = ""
    @objc var modelName: String = ""
    @objc var modelCode: String = ""
    @objc var modelUTI: String = ""
    @objc var identifier: String = ""
    @objc var isWireless: Bool = false
    @objc var cpuKind: String = ""
    @objc var cpuCount: NSNumber? = nil // Int?
    @objc var cpuSpeedInMHz: NSNumber? = nil // Int?
    @objc var busSpeedInMHz: NSNumber? = nil // Int?
    @objc var ramSizeInMegabytes: NSNumber? = nil // Int?
    @objc var physicalCPUCoresPerPackage: NSNumber? = nil // Int?
    @objc var logicalCPUCoresPerPackage: NSNumber? = nil // Int?
    @objc var platformRecord: ActionPlatformRecord? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "name": "name._value",
            "isConcreteDevice": "isConcreteDevice._value",
            "operatingSystemVersion": "operatingSystemVersion._value",
            "operatingSystemVersionWithBuildNumber": "operatingSystemVersionWithBuildNumber._value",
            "nativeArchitecture": "nativeArchitecture._value",
            "modelName": "modelName._value",
            "modelCode": "modelCode._value",
            "modelUTI": "modelUTI._value",
            "identifier": "identifier._value",
            "isWireless": "isWireless._value",
            "cpuKind": "cpuKind._value",
            "cpuCount": "cpuCount._value",
            "cpuSpeedInMHz": "cpuSpeedInMHz._value",
            "busSpeedInMHz": "busSpeedInMHz._value",
            "ramSizeInMegabytes": "ramSizeInMegabytes._value",
            "physicalCPUCoresPerPackage": "physicalCPUCoresPerPackage._value",
            "logicalCPUCoresPerPackage": "logicalCPUCoresPerPackage._value",
            "platformRecord": "platformRecord",
        ]
    }
}

@objc public class ActionPlatformRecord : MTLModel, MTLJSONSerializing {
    @objc var identifier: String = ""
    @objc var userDescription: String = ""
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier": "identifier._value",
            "userDescription": "userDescription._value",
        ]
    }
}

@objc public class ActionRecord : MTLModel, MTLJSONSerializing {
    @objc var schemeCommandName: String = ""
    @objc var schemeTaskName: String = ""
    @objc var title: String? = nil
    @objc var startedTime: Date? = nil
    @objc var endedTime: Date? = nil
    @objc var runDestination: ActionRunDestinationRecord? = nil
    @objc var buildResult: ActionResult? = nil
    @objc var actionResult: ActionResult? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "schemeCommandName": "schemeCommandName._value",
            "schemeTaskName": "schemeTaskName._value",
            "title": "title._value",
            "startedTime": "startedTime._value",
            "endedTime": "endedTime._value",
            "runDestination": "runDestination",
            "buildResult": "buildResult",
            "actionResult": "actionResult",
        ]
    }
    
    @objc static public func startedTimeJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.DateJSONTransformer()
    }
    
    @objc static public func endedTimeJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.DateJSONTransformer()
    }
}

@objc public class ActionResult : MTLModel, MTLJSONSerializing {
    @objc var resultName: String = ""
    @objc var status: String = ""
    @objc var metrics: ResultMetrics? = nil
    @objc var issues: ResultIssueSummaries? = nil
    @objc var coverage: CodeCoverageInfo? = nil
    @objc var timelineRef: Reference? = nil
    @objc var logRef: Reference? = nil
    @objc var testsRef: Reference? = nil
    @objc var diagnosticsRef: Reference? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "resultName": "resultName._value",
            "status": "status._value",
            "metrics": "metrics",
            "issues": "issues",
            "coverage": "coverage",
            "timelineRef": "timelineRef",
            "logRef": "logRef",
            "testsRef": "testsRef",
            "diagnosticsRef": "diagnosticsRef",
        ]
    }
}

@objc public class ActionRunDestinationRecord : MTLModel, MTLJSONSerializing {
    @objc var displayName: String = ""
    @objc var targetArchitecture: String = ""
    @objc var targetDeviceRecord: ActionDeviceRecord? = nil
    @objc var localComputerRecord: ActionDeviceRecord? = nil
    @objc var targetSDKRecord: ActionSDKRecord? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "displayName": "displayName._value",
            "targetArchitecture": "targetArchitecture._value",
            "targetDeviceRecord": "targetDeviceRecord",
            "localComputerRecord": "localComputerRecord",
            "targetSDKRecord": "targetSDKRecord",
        ]
    }
}

@objc public class ActionSDKRecord : MTLModel, MTLJSONSerializing {
    @objc var name: String = ""
    @objc var identifier: String = ""
    @objc var operatingSystemVersion: String = ""
    @objc var isInternal: Bool = false
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "name": "name._value",
            "identifier": "identifier._value",
            "operatingSystemVersion": "operatingSystemVersion._value",
            "isInternal": "isInternal._value",
        ]
    }
}

@objc public class ActionTestActivitySummary : MTLModel, MTLJSONSerializing {
    @objc var title: String = ""
    @objc var activityType: String = ""
    @objc var uuid: String = ""
    @objc var start: Date? = nil
    @objc var finish: Date? = nil
    @objc var attachments: [ActionTestAttachment] = []
    @objc var subactivities: [ActionTestActivitySummary] = []
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "title": "title._value",
            "activityType": "activityType._value",
            "uuid": "uuid._value",
            "start": "start._value",
            "finish": "finish._value",
            "attachments": "start._values",
            "subactivities": "subactivities._values",
        ]
    }
    
    @objc static public func attachmentsJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestAttachment.self);
    }
    
    @objc static public func subactivitiesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestActivitySummary.self);
    }
}

@objc public class ActionTestAttachment : MTLModel, MTLJSONSerializing {
    @objc var uniformTypeIdentifier: String = ""
    @objc var name: String? = nil
    @objc var timestamp: Date? = nil
    @objc var userInfo: SortedKeyValueArray? = nil
    @objc var lifetime: String = ""
    @objc var inActivityIdentifier: Int = 0
    @objc var filename: String? = nil
    @objc var payloadRef: Reference? = nil
    @objc var payloadSize: Int = 0
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "uniformTypeIdentifier": "uniformTypeIdentifier._value",
            "name": "name._value",
            "timestamp": "timestamp._value",
            "userInfo": "userInfo._value",
            "lifetime": "lifetime._value",
            "inActivityIdentifier": "inActivityIdentifier._value",
            "filename": "filename._value",
            "payloadRef": "payloadRef._value",
            "payloadSize": "payloadSize._value",
        ]
    }
}

@objc public class ActionTestFailureSummary : MTLModel, MTLJSONSerializing {
    @objc var message: String? = nil
    @objc var fileName: String = ""
    @objc var lineNumber: Int = 0
    @objc var isPerformanceFailure: Bool = false
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "message": "message._value",
            "fileName": "fileName._value",
            "lineNumber": "lineNumber._value",
            "isPerformanceFailure": "isPerformanceFailure._value",
        ]
    }
}

struct ActionTestMetadata : Codable {
    let testStatus: String
    let duration: Double?
    //    let summaryRef: Reference?
    let performanceMetricsCount: Int
    let failureSummariesCount: Int
    let activitySummariesCount: Int
}

@objc public class ActionTestPerformanceMetricSummary : MTLModel, MTLJSONSerializing {
    @objc var displayName: String = ""
    @objc var unitOfMeasurement: String = ""
    @objc var measurements: [NSNumber] = [] // Double
    @objc var identifier: String? = nil
    @objc var baselineName: String? = nil
    @objc var baselineAverage: NSNumber? = nil // Double
    @objc var maxPercentRegression: NSNumber? = nil // Double
    @objc var maxPercentRelativeStandardDeviation: NSNumber? = nil // Double
    @objc var maxRegression: NSNumber? = nil // Double
    @objc var maxStandardDeviation: NSNumber? = nil // Double
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "displayName": "displayName._value",
            "unitOfMeasurement": "unitOfMeasurement._value",
            "measurements": "measurements._values",
            "identifier": "identifier._value",
            "baselineName": "baselineName._value",
            "baselineAverage": "baselineAverage._value",
            "maxPercentRegression": "maxPercentRegression._value",
            "maxPercentRelativeStandardDeviation": "maxPercentRelativeStandardDeviation._value",
            "maxRegression": "maxRegression._value",
            "maxStandardDeviation": "maxStandardDeviation._value",
        ]
    }
    
    @objc static public func measurementsJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: NSNumber.self);
    }
}

@objc public class ActionTestPlanRunSummaries : MTLModel, MTLJSONSerializing {
    @objc var summaries: [ActionTestPlanRunSummary] = []
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "summaries": "summaries._values",
        ]
    }
    
    @objc static public func summariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestPlanRunSummary.self);
    }
}

@objc public class ActionTestPlanRunSummary : MTLModel, MTLJSONSerializing {
    @objc var testableSummaries: [ActionTestableSummary] = []
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "testableSummaries": "testableSummaries._values",
        ]
    }
    
    @objc static public func testableSummariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestableSummary.self);
    }
}

@objc public class ActionTestSummary : MTLModel, MTLJSONSerializing {
    @objc var testStatus: String = ""
    @objc var duration: Double = 0
    @objc var performanceMetrics: [ActionTestPerformanceMetricSummary] = []
    @objc var failureSummaries: [ActionTestFailureSummary] = []
    @objc var activitySummaries: [ActionTestActivitySummary] = []
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "testStatus": "testStatus._value",
            "duration": "duration._value",
            "performanceMetrics": "performanceMetrics._values",
            "failureSummaries": "failureSummaries._values",
            "activitySummaries": "activitySummaries._values",
        ]
    }
    
    @objc static public func performanceMetricsJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestPerformanceMetricSummary.self);
    }
    
    @objc static public func failureSummariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestFailureSummary.self);
    }
    
    @objc static public func activitySummariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestActivitySummary.self);
    }
}

@objc public class ActionTestSummaryGroup : MTLModel, MTLJSONSerializing {
    @objc var duration: Double = 0
    @objc var subtests: [ActionTestSummaryIdentifiableObject] = []
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "duration": "duration._value",
            "subtests": "subtests._values",
        ]
    }
    
    @objc static public func subtestsJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestSummaryIdentifiableObject.self);
    }
}

@objc public class ActionTestSummaryIdentifiableObject : MTLModel, MTLJSONSerializing {
    @objc var identifier: String? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "identifier": "identifier._value",
        ]
    }
}

@objc public class ActionTestableSummary : MTLModel, MTLJSONSerializing {
    @objc var projectRelativePath: String? = nil
    @objc var targetName: String? = nil
    @objc var testKind: String? = nil
    @objc var tests: [ActionTestSummaryIdentifiableObject] = []
    @objc var diagnosticsDirectoryName: String? = nil
    @objc var failureSummaries: [ActionTestFailureSummary] = []
    @objc var testLanguage: String? = nil
    @objc var testRegion: String? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "projectRelativePath": "projectRelativePath._value",
            "targetName": "targetName._value",
            "testKind": "testKind._value",
            "tests": "tests._values",
            "diagnosticsDirectoryName": "diagnosticsDirectoryName._value",
            "failureSummaries": "failureSummaries._values",
            "testLanguage": "testLanguage._value",
            "testRegion": "testRegion._value",
        ]
    }
    
    @objc static public func testsJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestSummaryIdentifiableObject.self);
    }
    
    @objc static public func failureSummariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionTestFailureSummary.self);
    }
}

struct ActionsInvocationMetadata : Codable {
    let creatingWorkspaceFilePath: String
    let uniqueIdentifier: String
    let schemeIdentifier: EntityIdentifier?
}

// This seems to be the base in most cases
@objc public class ActionsInvocationRecord : MTLModel, MTLJSONSerializing {
    @objc public var metadataRef : Reference? = nil
    @objc var metrics : ResultMetrics?
    @objc var actions : [ActionRecord] = []
    //    @objc var archive : ArchiveInfo? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "metadataRef": "metadataRef",
            "metrics": "metrics",
            "actions": "actions._values",
            //            "archive": "archive",
        ]
    }
    
    @objc static public func actionsJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: ActionRecord.self);
    }
}

struct ActivityLogCommandInvocationSection : Codable {
    let commandDetails: String
    let emittedOutput: String
    let exitCode: Int?
}

struct ActivityLogMajorSection : Codable {
    let subtitle: String
}

struct ActivityLogMessage : Codable {
    let type: String
    let title: String
    let shortTitle: String?
    let category: String?
    //    let location: DocumentLocation?
    let annotations: [ActivityLogMessageAnnotation]
}

struct ActivityLogMessageAnnotation : Codable {
    let title: String
    //    let location: DocumentLocation?
    
}

struct ActivityLogSection : Codable {
    let domainType: String
    let title: String
    let startTime: Date?
    let duration: Double
    let result: String?
    let subsections: [ActivityLogSection]
    let messages: [ActivityLogMessage]
}

struct ActivityLogTargetBuildSection : Codable {
    let productType: String?
}

struct ActivityLogUnitTestSection : Codable {
    let testName: String?
    let suiteName: String?
    let summary: String?
    let emittedOutput: String?
    let performanceTestOutput: String?
    let testsPassedString: String?
    let runnablePath: String?
    let runnableUTI: String?
}

struct ArchiveInfo : Codable {
    let path: String?
}

@objc public class CodeCoverageInfo : MTLModel, MTLJSONSerializing {
    @objc var hasCoverageData: Bool = false
    @objc var reportRef: Reference? = nil
    @objc var archiveRef: Reference? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "hasCoverageData": "hasCoverageData._value",
            "reportRef": "reportRef",
            "archiveRef": "archiveRef",
        ]
    }
}

@objc public class DocumentLocation : MTLModel, MTLJSONSerializing {
    @objc var url: String = ""
    @objc var concreteTypeName: String = ""
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "url": "url._value",
            "concreteTypeName": "concreteTypeName._value",
        ]
    }
}

struct EntityIdentifier : Codable {
    let entityName: String
    let containerName: String
    let entityType: String
    let sharedState: String
}

@objc class IssueSummary : MTLModel, MTLJSONSerializing {
    @objc var issueType: String = ""
    @objc var message: String = ""
    @objc var producingTarget: String? = nil
    @objc var documentLocationInCreatingWorkspace: DocumentLocation? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "issueType": "issueType._value",
            "message": "message._value",
            "producingTarget": "producingTarget._value",
            "documentLocationInCreatingWorkspace": "documentLocationInCreatingWorkspace",
        ]
    }
}

struct ObjectID : Codable {
    let hash: String
}

@objc public class Reference : MTLModel, MTLJSONSerializing {
    @objc var id: String = ""
    @objc var targetType: TypeDefinition? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "id": "id._value",
            "targetType": "targetType",
        ]
    }
}

@objc public class ResultIssueSummaries : MTLModel, MTLJSONSerializing {
    @objc var analyzerWarningSummaries: [IssueSummary] = []
    @objc var errorSummaries: [IssueSummary] = []
    @objc var testFailureSummaries: [TestFailureIssueSummary] = []
    @objc var warningSummaries: [IssueSummary] = []
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "analyzerWarningSummaries": "analyzerWarningSummaries._values",
            "errorSummaries": "errorSummaries._values",
            "testFailureSummaries": "testFailureSummaries._values",
            "warningSummaries": "warningSummaries._values",
        ]
    }
    
    @objc static public func analyzerWarningSummariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: IssueSummary.self);
    }
    
    @objc static public func errorSummariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: IssueSummary.self);
    }
    
    @objc static public func testFailureSummariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: TestFailureIssueSummary.self);
    }
    
    @objc static public func warningSummariesJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: IssueSummary.self);
    }
}

@objc public class ResultMetrics : MTLModel, MTLJSONSerializing {
    @objc var analyzerWarningCount: Int = 0
    @objc var errorCount: Int = 0
    @objc var testsCount: Int = 0
    @objc var testsFailedCount: Int = 0
    @objc var warningCount: Int = 0
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "analyzerWarningCount": "analyzerWarningCount._value",
            "errorCount": "errorCount._value",
            "testsCount": "testsCount._value",
            "testsFailedCount": "testsFailedCount._value",
            "warningCount": "warningCount._value",
        ]
    }
}

@objc public class SortedKeyValueArray : MTLModel, MTLJSONSerializing {
    @objc var storage: [SortedKeyValueArrayPair] = []
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "storage": "storage._values",
        ]
    }
    
    @objc static public func storageJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.arrayTransformer(withModelClass: SortedKeyValueArrayPair.self);
    }
}

// TODO: Alex - come back to this commented property
@objc public class SortedKeyValueArrayPair : MTLModel, MTLJSONSerializing {
    @objc var key: String = ""
    // @objc var value: SchemaSerializable
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "key": "key._value",
//            "value": "value",
        ]
    }
}

@objc public class TestFailureIssueSummary : MTLModel, MTLJSONSerializing {
    @objc var testCaseName: String = ""
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "testCaseName": "testCaseName._value",
        ]
    }
}

// TODO: Alex - come back to this commented property
@objc public class TypeDefinition : MTLModel, MTLJSONSerializing {
    @objc var name: String = ""
    @objc var supertype: TypeDefinition? = nil
    
    @objc static public func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return [
            "name": "name._value",
            "supertype": "supertype",
        ]
    }
}
