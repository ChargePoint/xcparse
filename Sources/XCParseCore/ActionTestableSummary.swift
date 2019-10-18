//
//  ActionTestableSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestableSummary : ActionAbstractTestSummary {
    public let projectRelativePath: String?
    public let targetName: String?
    public let testKind: String?
    public let tests: [ActionTestSummaryIdentifiableObject]
    public let diagnosticsDirectoryName: String?
    public let failureSummaries: [ActionTestFailureSummary]
    public let testLanguage: String?
    public let testRegion: String?

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

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestableSummaryCodingKeys.self)
        projectRelativePath = try container.decodeXCResultTypeIfPresent(forKey: .projectRelativePath)
        targetName = try container.decodeXCResultTypeIfPresent(forKey: .targetName)
        testKind = try container.decodeXCResultTypeIfPresent(forKey: .testKind)

        tests = try container.decodeXCResultArray(forKey: .tests)

        diagnosticsDirectoryName = try container.decodeXCResultTypeIfPresent(forKey: .diagnosticsDirectoryName)

        failureSummaries = try container.decodeXCResultArray(forKey: .failureSummaries)

        testLanguage = try container.decodeXCResultTypeIfPresent(forKey: .testLanguage)
        testRegion = try container.decodeXCResultTypeIfPresent(forKey: .testRegion)

        try super.init(from: decoder)
    }

    public func flattenedTestSummaryMap(withXCResult xcresult: XCResult) -> [(testSummary: ActionTestSummary, activitySummaries: [ActionTestActivitySummary])] {
        var testSummaryMap: [(ActionTestSummary, [ActionTestActivitySummary])] = []

        var tests: [ActionTestSummaryIdentifiableObject] = self.tests

        var testSummaries: [ActionTestSummary] = []
        var testMetadata: [ActionTestMetadata] = []

        // Iterate through the testSummaryGroups until we get out all the test summaries & metadata
        repeat {
            let summaryGroups = tests.compactMap { (identifiableObj) -> ActionTestSummaryGroup? in
                if let testSummaryGroup = identifiableObj as? ActionTestSummaryGroup {
                    return testSummaryGroup
                } else {
                    return nil
                }
            }

            let summaries = tests.compactMap { (identifiableObj) -> ActionTestSummary? in
                if let testSummary = identifiableObj as? ActionTestSummary {
                    return testSummary
                } else {
                    return nil
                }
            }
            testSummaries.append(contentsOf: summaries)

            let metadata = tests.compactMap { (identifiableObj) -> ActionTestMetadata? in
                if let metadata = identifiableObj as? ActionTestMetadata {
                    return metadata
                } else {
                    return nil
                }
            }
            testMetadata.append(contentsOf: metadata)

            tests = summaryGroups.flatMap { $0.subtests }
        } while tests.count > 0

        // For those where we already have the ActionTestSummary, add them to the map
        let testSummariesToAllChildActivities = testSummaries.map { (testSummary: $0, activitySummaries: $0.allChildActivitySummaries()) }
        testSummaryMap.append(contentsOf: testSummariesToAllChildActivities)

        // Now let's go digging out the ActionTestSummary from these ActionTestMetadata references we got (will involve more xcresulttool calls)
        let testSummaryReferences = testMetadata.compactMap { $0.summaryRef }
        for summaryReference in testSummaryReferences {
            guard let summary: ActionTestSummary = summaryReference.modelFromReference(withXCResult: xcresult) else {
                xcresult.console.writeMessage("Error: Unhandled test summary type \(String(describing: summaryReference.targetType?.getType()))", to: .error)
                continue
            }

            let referenceSummaryChildActivities = summary.allChildActivitySummaries()
            testSummaryMap.append((summary, referenceSummaryChildActivities))
        }

        return testSummaryMap
    }
}
