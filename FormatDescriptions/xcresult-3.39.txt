Name: Xcode Result Types
Version: 3.39
Signature: PS0lrtUj8Aw=
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
      + configuration: ActionTestConfiguration?
  - ActionTestSummaryGroup
    * Supertype: ActionTestSummaryIdentifiableObject
    * Kind: object
    * Properties:
      + duration: Double
      + subtests: [ActionTestSummaryIdentifiableObject]
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
  - ConsoleLogSection
    * Kind: object
    * Properties:
      + title: String
      + items: [ConsoleLogItem]
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
  - IssueSummary
    * Kind: object
    * Properties:
      + issueType: String
      + message: String
      + producingTarget: String?
      + documentLocationInCreatingWorkspace: DocumentLocation?
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
  - ResultMetrics
    * Kind: object
    * Properties:
      + analyzerWarningCount: Int
      + errorCount: Int
      + testsCount: Int
      + testsFailedCount: Int
      + testsSkippedCount: Int
      + warningCount: Int
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
  - TestAssociatedError
    * Kind: object
    * Properties:
      + domain: String?
      + code: Int?
      + userInfo: SortedKeyValueArray?
  - TestFailureIssueSummary
    * Supertype: IssueSummary
    * Kind: object
    * Properties:
      + testCaseName: String
  - TypeDefinition
    * Kind: object
    * Properties:
      + name: String
      + supertype: TypeDefinition?
