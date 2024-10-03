Name: Xcode Result Types
Version: 3.53
Signature: HAB7BB+BxgA=
Types:
  - ActionAbstractTestSummary
    * Kind: object
    * Properties:
      + name: String?
  - ActionDeviceRecord
    * Kind: object
    * Properties:
      + name: String
      + isConcreteDevice: Bool
      + operatingSystemVersion: String
      + operatingSystemVersionWithBuildNumber: String
      + nativeArchitecture: String
      + modelName: String
      + modelCode: String
      + modelUTI: String
      + identifier: String
      + isWireless: Bool
      + cpuKind: String
      + cpuCount: Int?
      + cpuSpeedInMHz: Int?
      + busSpeedInMHz: Int?
      + ramSizeInMegabytes: Int?
      + physicalCPUCoresPerPackage: Int?
      + logicalCPUCoresPerPackage: Int?
      + platformRecord: ActionPlatformRecord
  - ActionPlatformRecord
    * Kind: object
    * Properties:
      + identifier: String
      + userDescription: String
  - ActionRecord
    * Kind: object
    * Properties:
      + schemeCommandName: String
      + schemeTaskName: String
      + title: String?
      + startedTime: Date
      + endedTime: Date
      + runDestination: ActionRunDestinationRecord
      + buildResult: ActionResult
      + actionResult: ActionResult
      + testPlanName: String?
  - ActionResult
    * Kind: object
    * Properties:
      + resultName: String
      + status: String
      + metrics: ResultMetrics
      + issues: ResultIssueSummaries
      + coverage: CodeCoverageInfo
      + timelineRef: Reference?
      + logRef: Reference?
      + testsRef: Reference?
      + diagnosticsRef: Reference?
      + consoleLogRef: Reference?
  - ActionRunDestinationRecord
    * Kind: object
    * Properties:
      + displayName: String
      + targetArchitecture: String
      + targetDeviceRecord: ActionDeviceRecord
      + localComputerRecord: ActionDeviceRecord
      + targetSDKRecord: ActionSDKRecord
  - ActionSDKRecord
    * Kind: object
    * Properties:
      + name: String
      + identifier: String
      + operatingSystemVersion: String
      + isInternal: Bool
  - ActionTestActivitySummary
    * Kind: object
    * Properties:
      + title: String
      + activityType: String
      + uuid: String
      + start: Date?
      + finish: Date?
      + attachments: [ActionTestAttachment]
      + subactivities: [ActionTestActivitySummary]
      + failureSummaryIDs: [String]
      + expectedFailureIDs: [String]
      + warningSummaryIDs: [String]
  - ActionTestAttachment
    * Kind: object
    * Properties:
      + uniformTypeIdentifier: String
      + name: String?
      + uuid: String?
      + timestamp: Date?
      + userInfo: SortedKeyValueArray?
      + lifetime: String
      + inActivityIdentifier: Int
      + filename: String?
      + payloadRef: Reference?
      + payloadSize: Int
  - ActionTestConfiguration
    * Kind: object
    * Properties:
      + values: SortedKeyValueArray
  - ActionTestExpectedFailure
    * Kind: object
    * Properties:
      + uuid: String
      + failureReason: String?
      + failureSummary: ActionTestFailureSummary?
      + isTopLevelFailure: Bool
  - ActionTestFailureSummary
    * Kind: object
    * Properties:
      + message: String?
      + fileName: String
      + lineNumber: Int
      + isPerformanceFailure: Bool
      + uuid: String
      + issueType: String?
      + detailedDescription: String?
      + attachments: [ActionTestAttachment]
      + associatedError: TestAssociatedError?
      + sourceCodeContext: SourceCodeContext?
      + timestamp: Date?
      + isTopLevelFailure: Bool
      + expression: TestExpression?
  - ActionTestIssueSummary
    * Kind: object
    * Properties:
      + message: String?
      + fileName: String
      + lineNumber: Int
      + uuid: String
      + issueType: String?
      + detailedDescription: String?
      + attachments: [ActionTestAttachment]
      + associatedError: TestAssociatedError?
      + sourceCodeContext: SourceCodeContext?
      + timestamp: Date?
  - ActionTestMetadata
    * Supertype: ActionTestSummaryIdentifiableObject
    * Kind: object
    * Properties:
      + testStatus: String
      + duration: Double?
      + summaryRef: Reference?
      + performanceMetricsCount: Int
      + failureSummariesCount: Int
      + activitySummariesCount: Int
  - ActionTestNoticeSummary
    * Kind: object
    * Properties:
      + message: String?
      + fileName: String
      + lineNumber: Int
      + timestamp: Date?
  - ActionTestPerformanceMetricSummary
    * Kind: object
    * Properties:
      + displayName: String
      + unitOfMeasurement: String
      + measurements: [Double]
      + identifier: String?
      + baselineName: String?
      + baselineAverage: Double?
      + maxPercentRegression: Double?
      + maxPercentRelativeStandardDeviation: Double?
      + maxRegression: Double?
      + maxStandardDeviation: Double?
      + polarity: String?
  - ActionTestPlanRunSummaries
    * Kind: object
    * Properties:
      + summaries: [ActionTestPlanRunSummary]
  - ActionTestPlanRunSummary
    * Supertype: ActionAbstractTestSummary
    * Kind: object
    * Properties:
      + testableSummaries: [ActionTestableSummary]
  - ActionTestRepetitionPolicySummary
    * Kind: object
    * Properties:
      + iteration: Int?
      + totalIterations: Int?
      + repetitionMode: String?
  - ActionTestSummary
    * Supertype: ActionTestSummaryIdentifiableObject
    * Kind: object
    * Properties:
      + testStatus: String
      + duration: Double
      + performanceMetrics: [ActionTestPerformanceMetricSummary]
      + failureSummaries: [ActionTestFailureSummary]
      + expectedFailures: [ActionTestExpectedFailure]
      + skipNoticeSummary: ActionTestNoticeSummary?
      + activitySummaries: [ActionTestActivitySummary]
      + repetitionPolicySummary: ActionTestRepetitionPolicySummary?
      + arguments: [TestArgument]
      + configuration: ActionTestConfiguration?
      + warningSummaries: [ActionTestIssueSummary]
      + summary: String?
      + documentation: [TestDocumentation]
      + trackedIssues: [IssueTrackingMetadata]
      + tags: [TestTag]
  - ActionTestSummaryGroup
    * Supertype: ActionTestSummaryIdentifiableObject
    * Kind: object
    * Properties:
      + duration: Double
      + subtests: [ActionTestSummaryIdentifiableObject]
      + skipNoticeSummary: ActionTestNoticeSummary?
      + summary: String?
      + documentation: [TestDocumentation]
      + trackedIssues: [IssueTrackingMetadata]
      + tags: [TestTag]
  - ActionTestSummaryIdentifiableObject
    * Supertype: ActionAbstractTestSummary
    * Kind: object
    * Properties:
      + identifier: String?
      + identifierURL: String?
  - ActionTestableSummary
    * Supertype: ActionAbstractTestSummary
    * Kind: object
    * Properties:
      + identifierURL: String?
      + projectRelativePath: String?
      + targetName: String?
      + testKind: String?
      + tests: [ActionTestSummaryIdentifiableObject]
      + diagnosticsDirectoryName: String?
      + failureSummaries: [ActionTestFailureSummary]
      + testLanguage: String?
      + testRegion: String?
  - ActionsInvocationMetadata
    * Kind: object
    * Properties:
      + creatingWorkspaceFilePath: String
      + uniqueIdentifier: String
      + schemeIdentifier: EntityIdentifier?
  - ActionsInvocationRecord
    * Kind: object
    * Properties:
      + metadataRef: Reference?
      + metrics: ResultMetrics
      + issues: ResultIssueSummaries
      + actions: [ActionRecord]
      + archive: ArchiveInfo?
  - ActivityLogAnalyzerControlFlowStep
    * Supertype: ActivityLogAnalyzerStep
    * Kind: object
    * Properties:
      + title: String
      + startLocation: DocumentLocation?
      + endLocation: DocumentLocation?
      + edges: [ActivityLogAnalyzerControlFlowStepEdge]
  - ActivityLogAnalyzerControlFlowStepEdge
    * Kind: object
    * Properties:
      + startLocation: DocumentLocation?
      + endLocation: DocumentLocation?
  - ActivityLogAnalyzerEventStep
    * Supertype: ActivityLogAnalyzerStep
    * Kind: object
    * Properties:
      + title: String
      + location: DocumentLocation?
      + description: String
      + callDepth: Int
  - ActivityLogAnalyzerResultMessage
    * Supertype: ActivityLogMessage
    * Kind: object
    * Properties:
      + steps: [ActivityLogAnalyzerStep]
      + resultType: String?
      + keyEventIndex: Int
  - ActivityLogAnalyzerStep
    * Kind: object
    * Properties:
      + parentIndex: Int
  - ActivityLogAnalyzerWarningMessage
    * Supertype: ActivityLogMessage
    * Kind: object
  - ActivityLogCommandInvocationSection
    * Supertype: ActivityLogSection
    * Kind: object
    * Properties:
      + commandDetails: String
      + emittedOutput: String
      + exitCode: Int?
  - ActivityLogMajorSection
    * Supertype: ActivityLogSection
    * Kind: object
    * Properties:
      + subtitle: String
  - ActivityLogMessage
    * Kind: object
    * Properties:
      + type: String
      + title: String
      + shortTitle: String?
      + category: String?
      + location: DocumentLocation?
      + annotations: [ActivityLogMessageAnnotation]
  - ActivityLogMessageAnnotation
    * Kind: object
    * Properties:
      + title: String
      + location: DocumentLocation?
  - ActivityLogSection
    * Kind: object
    * Properties:
      + domainType: String
      + title: String
      + startTime: Date?
      + duration: Double
      + result: String?
      + location: DocumentLocation?
      + subsections: [ActivityLogSection]
      + messages: [ActivityLogMessage]
      + attachments: [ActivityLogSectionAttachment]
  - ActivityLogSectionAttachment
    * Kind: object
    * Properties:
      + identifier: String
      + majorVersion: UInt8
      + minorVersion: UInt8
      + data: Data
  - ActivityLogTargetBuildSection
    * Supertype: ActivityLogMajorSection
    * Kind: object
    * Properties:
      + productType: String?
  - ActivityLogUnitTestSection
    * Supertype: ActivityLogSection
    * Kind: object
    * Properties:
      + testName: String?
      + suiteName: String?
      + summary: String?
      + emittedOutput: String?
      + performanceTestOutput: String?
      + testsPassedString: String?
      + wasSkipped: Bool
      + runnablePath: String?
      + runnableUTI: String?
  - ArchiveInfo
    * Kind: object
    * Properties:
      + path: String?
  - Array
    * Kind: array
  - Bool
    * Kind: value
  - CodeCoverageInfo
    * Kind: object
    * Properties:
      + hasCoverageData: Bool
      + reportRef: Reference?
      + archiveRef: Reference?
  - ConsoleLogItem
    * Kind: object
    * Properties:
      + adaptorType: String?
      + kind: String?
      + timestamp: Double
      + content: String
      + logData: ConsoleLogItemLogData?
  - ConsoleLogItemLogData
    * Kind: object
    * Properties:
      + message: String?
      + subsystem: String?
      + category: String?
      + library: String?
      + format: String?
      + backtrace: String?
      + pid: Int32
      + processName: String?
      + sessionUUID: String?
      + tid: UInt64
      + messageType: UInt8
      + senderImagePath: String?
      + senderImageUUID: String?
      + senderImageOffset: UInt64
      + unixTimeInterval: Double
      + timeZone: String?
  - ConsoleLogSection
    * Kind: object
    * Properties:
      + title: String
      + items: [ConsoleLogItem]
  - Data
    * Kind: value
  - Date
    * Kind: value
  - DocumentLocation
    * Kind: object
    * Properties:
      + url: String
      + concreteTypeName: String
  - Double
    * Kind: value
  - EntityIdentifier
    * Kind: object
    * Properties:
      + entityName: String
      + containerName: String
      + entityType: String
      + sharedState: String
  - Int
    * Kind: value
  - Int16
    * Kind: value
  - Int32
    * Kind: value
  - Int64
    * Kind: value
  - Int8
    * Kind: value
  - IssueSummary
    * Kind: object
    * Properties:
      + issueType: String
      + message: String
      + producingTarget: String?
      + documentLocationInCreatingWorkspace: DocumentLocation?
  - IssueTrackingMetadata
    * Kind: object
    * Properties:
      + identifier: String
      + url: URL?
      + comment: String?
      + summary: String
  - ObjectID
    * Kind: object
    * Properties:
      + hash: String
  - Reference
    * Kind: object
    * Properties:
      + id: String
      + targetType: TypeDefinition?
  - ResultIssueSummaries
    * Kind: object
    * Properties:
      + analyzerWarningSummaries: [IssueSummary]
      + errorSummaries: [IssueSummary]
      + testFailureSummaries: [TestFailureIssueSummary]
      + warningSummaries: [IssueSummary]
      + testWarningSummaries: [TestIssueSummary]
  - ResultMetrics
    * Kind: object
    * Properties:
      + analyzerWarningCount: Int
      + errorCount: Int
      + testsCount: Int
      + testsFailedCount: Int
      + testsSkippedCount: Int
      + warningCount: Int
      + totalCoveragePercentage: Double?
  - SortedKeyValueArray
    * Kind: object
    * Properties:
      + storage: [SortedKeyValueArrayPair]
  - SortedKeyValueArrayPair
    * Kind: object
    * Properties:
      + key: String
      + value: SchemaSerializable
  - SourceCodeContext
    * Kind: object
    * Properties:
      + location: SourceCodeLocation?
      + callStack: [SourceCodeFrame]
  - SourceCodeFrame
    * Kind: object
    * Properties:
      + addressString: String?
      + symbolInfo: SourceCodeSymbolInfo?
  - SourceCodeLocation
    * Kind: object
    * Properties:
      + filePath: String?
      + lineNumber: Int?
  - SourceCodeSymbolInfo
    * Kind: object
    * Properties:
      + imageName: String?
      + symbolName: String?
      + location: SourceCodeLocation?
  - String
    * Kind: value
  - TestArgument
    * Kind: object
    * Properties:
      + parameter: TestParameter?
      + identifier: String?
      + description: String
      + debugDescription: String?
      + typeName: String?
      + value: TestValue
  - TestAssociatedError
    * Kind: object
    * Properties:
      + domain: String?
      + code: Int?
      + userInfo: SortedKeyValueArray?
  - TestDocumentation
    * Kind: object
    * Properties:
      + content: String
      + format: String
  - TestExpression
    * Kind: object
    * Properties:
      + sourceCode: String
      + value: TestValue?
      + subexpressions: [TestExpression]
  - TestFailureIssueSummary
    * Supertype: IssueSummary
    * Kind: object
    * Properties:
      + testCaseName: String
  - TestIssueSummary
    * Supertype: IssueSummary
    * Kind: object
    * Properties:
      + testCaseName: String
  - TestParameter
    * Kind: object
    * Properties:
      + label: String
      + name: String?
      + typeName: String?
      + fullyQualifiedTypeName: String?
  - TestTag
    * Kind: object
    * Properties:
      + identifier: String
      + name: String
      + anchors: [String]
  - TestValue
    * Kind: object
    * Properties:
      + description: String
      + debugDescription: String?
      + typeName: String?
      + fullyQualifiedTypeName: String?
      + label: String?
      + isCollection: Bool
      + children: TestValue?
  - TypeDefinition
    * Kind: object
    * Properties:
      + name: String
      + supertype: TypeDefinition?
  - UInt16
    * Kind: value
  - UInt32
    * Kind: value
  - UInt64
    * Kind: value
  - UInt8
    * Kind: value
  - URL
    * Kind: value
