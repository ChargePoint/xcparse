//
//  XCPParser.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/8/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import XCParseCore

enum OptionType: String {
    case screenshot = "s"
    case xcov = "x"
    case help = "h"
    case quit = "q"
    case unknown
  
    init(value: String) {
        switch value {
            case "s", "screenshots": self = .screenshot
            case "x", "xcov": self = .xcov
            case "h", "help": self = .help
            case "q", "quit": self = .quit
            default: self = .unknown
        }
    }
}

class XCPParser {
    
    let console = Console()

    func getOption(_ option: String) -> (option:OptionType, value: String) {
      return (OptionType(value: option), option)
    }
    
    func extractScreenshots(xcresultPath : String, destination : String) throws {
        let xcresultJSON = XCResultToolCommand.Get(path: xcresultPath, id: "", outputPath: "", format: .json).run()
        let xcresultJSONData = Data(xcresultJSON.utf8)
        
        let decoder = JSONDecoder()
        let actionRecord = try decoder.decode(ActionsInvocationRecord.self, from: xcresultJSONData)
        
        let testReferenceIDs = actionRecord.actions.compactMap { $0.actionResult.testsRef?.id }

        var summaryRefIDs: [String] = []
        for testRefID in testReferenceIDs {
            let testJSONString = XCResultToolCommand.Get(path: xcresultPath, id: testRefID, outputPath: "", format: .json).run()
            let testRefData = Data(testJSONString.utf8)

            let testPlanRunSummaries = try decoder.decode(ActionTestPlanRunSummaries.self, from: testRefData)

            let testableSummaries = testPlanRunSummaries.summaries.flatMap { $0.testableSummaries }

            var tests: [ActionTestSummaryIdentifiableObject] = testableSummaries.flatMap { $0.tests }

            var testSummaryGroups: [ActionTestSummaryGroup] = []
            var testSummaries: [ActionTestSummary] = []
            var testMetadata: [ActionTestMetadata] = []

            repeat {
                let summaryGroups = tests.compactMap { (identifiableObj) -> ActionTestSummaryGroup? in
                    if let testSummaryGroup = identifiableObj as? ActionTestSummaryGroup {
                        return testSummaryGroup
                    } else {
                        return nil
                    }
                }
                testSummaryGroups.append(contentsOf: summaryGroups)

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

                if let testSummaryGroup = testSummaryGroups.popLast() {
                    tests = testSummaryGroup.subtests
                } else {
                    tests = []
                }
            } while tests.count > 0

            let testSummaryRefIDs = testMetadata.compactMap { $0.summaryRef?.id }
            summaryRefIDs.append(contentsOf: testSummaryRefIDs)
        }
        
        var screenshotRefIDs: [String] = []
        var screenshotNames: [String] = []
        for summaryRefID in summaryRefIDs {
            let testJSONString = XCResultToolCommand.Get(path: xcresultPath, id: summaryRefID, outputPath: "", format: .json).run()
            let summaryRefData = Data(testJSONString.utf8)
            
            let testSummary = try decoder.decode(ActionTestSummary.self, from: summaryRefData)
            
            for activitySummary in testSummary.activitySummaries {
                let attachments = activitySummary.attachments
                for attachment in attachments {
                    if let payloadRef = attachment.payloadRef {
                        screenshotRefIDs.append(payloadRef.id)
                    }
                    if let filename = attachment.filename {
                        screenshotNames.append(filename)
                    }
                }
            }
        }
        
        console.shellCommand("mkdir \"\(destination)\"/testScreenshots/")
        for i in 0...screenshotRefIDs.count-1 {
            let outputPathURL = URL.init(fileURLWithPath: destination).appendingPathComponent("testScreenshots").appendingPathComponent(screenshotNames[i])

            XCResultToolCommand.Get(path: xcresultPath, id: screenshotRefIDs[i], outputPath: outputPathURL.path, format: .raw).run()
        }
    }
    
    func extractCoverage(xcresultPath : String, destination : String) throws {
        let xcresultJSON = XCResultToolCommand.Get(path: xcresultPath, id: "", outputPath: "", format: .json).run()

        let xcresultJSONData = Data(xcresultJSON.utf8)
        
        let decoder = JSONDecoder()
        let actionRecord = try decoder.decode(ActionsInvocationRecord.self, from: xcresultJSONData)
        
        var coverageReferenceIDs: [String] = []
        var coverageArchiveIDs: [String] = []
        
        for action in actionRecord.actions {
            if let reportRef = action.actionResult.coverage.reportRef {
                coverageReferenceIDs.append(reportRef.id)
            }
            if let archiveRef = action.actionResult.coverage.archiveRef {
                coverageArchiveIDs.append(archiveRef.id)
            }
        }
        for (reportId, archiveId) in zip(coverageReferenceIDs, coverageArchiveIDs) {
            XCResultToolCommand.Export(path: xcresultPath, id: reportId,
                                        outputPath: "\(destination)/action.xccovreport",
                                        type: .file).run()
            XCResultToolCommand.Export(path: xcresultPath, id: archiveId,
                                        outputPath: "\(destination)/action.xccovarchive",
                                        type: .directory).run()
        }
    }
    
    func staticMode() throws {
        let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        var startIndex : String.Index
        if argument.count == 2 {
            startIndex = argument.index(argument.startIndex, offsetBy:  1)
        }
        else {
            startIndex = argument.index(argument.startIndex, offsetBy:  2)
        }
        let substr = String(argument[startIndex...])
        let (option, _) = getOption(substr)
        switch (option) {
        case .screenshot:
            if argCount != 4 {
                console.writeMessage("Missing Arguments", to: .error)
                console.printUsage()
            }
            else {
                try extractScreenshots(xcresultPath: CommandLine.arguments[2], destination: CommandLine.arguments[3])
            }
        case .xcov:
            if argCount != 4 {
                console.writeMessage("Missing Arguments", to: .error)
                console.printUsage()
            }
            else {
                try extractCoverage(xcresultPath: CommandLine.arguments[2], destination: CommandLine.arguments[3])
            }
            break
        case .help:
            console.printUsage()
        case .unknown, .quit:
            console.writeMessage("\nUnknown option \(argument)\n")
            console.printUsage()
        }
    }
    
    func interactiveMode() throws {
        console.writeMessage("Welcome to xcparse. This program can extract screenshots and coverage files from an *.xcresult file.")
        var shouldQuit = false
        while !shouldQuit {
            console.writeMessage("Type 's' to extract screenshots, 'x' to extract code coverage files, 'h' for help, or 'q' to quit.")
            let (option, value) = getOption(console.getInput())
            switch option {
            case .screenshot:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your screenshots:")
                let destinationPath = console.getInput()
                try extractScreenshots(xcresultPath: path, destination: destinationPath)
            case .xcov:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your coverage file:")
                let destinationPath = console.getInput()
                try extractCoverage(xcresultPath: path, destination: destinationPath)
                break
            case .quit:
                shouldQuit = true
            case .help:
                console.printUsage()
            default:
                console.writeMessage("Unknown option \(value)", to: .error)
                console.printUsage()
            }
        }
    }
    
    
}
