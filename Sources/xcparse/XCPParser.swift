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
    case verbose = "v"
    case help = "h"
    case quit = "q"
    case unknown
  
    init(value: String) {
        switch value {
            case "s", "screenshots": self = .screenshot
            case "x", "xcov": self = .xcov
            case "v", "verbose": self = .verbose
            case "h", "help": self = .help
            case "q", "quit": self = .quit
            default: self = .unknown
        }
    }
}

class XCPParser {
    let xcparseVersion = "0.3.2"
    
    var console = Console()

    func getOption(_ option: String) -> (option:OptionType, value: String) {
      return (OptionType(value: option), option)
    }
    
    func extractScreenshots(xcresultPath : String, destination : String) throws {
        var attachments: [ActionTestAttachment] = []

        let xcresultJSON = XCResultToolCommand.Get(path: xcresultPath, id: "", outputPath: "", format: .json, console: self.console).run()
        let xcresultJSONData = Data(xcresultJSON.utf8)
        
        let decoder = JSONDecoder()
        let actionRecord = try decoder.decode(ActionsInvocationRecord.self, from: xcresultJSONData)
        
        let testReferenceIDs = actionRecord.actions.compactMap { $0.actionResult.testsRef?.id }

        var summaryRefIDs: [String] = []
        for testRefID in testReferenceIDs {
            let testJSONString = XCResultToolCommand.Get(path: xcresultPath, id: testRefID, outputPath: "", format: .json, console: self.console).run()

            let testRefData = Data(testJSONString.utf8)

            let testPlanRunSummaries = try decoder.decode(ActionTestPlanRunSummaries.self, from: testRefData)

            let testableSummaries = testPlanRunSummaries.summaries.flatMap { $0.testableSummaries }

            var tests: [ActionTestSummaryIdentifiableObject] = testableSummaries.flatMap { $0.tests }

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

            // Need to extract out the testSummary until get all ActionTestActivitySummary
            var activitySummaries = testSummaries.flatMap { $0.activitySummaries }

            // Get all subactivities
            var summariesToCheck = activitySummaries
            repeat {
                summariesToCheck = summariesToCheck.flatMap { $0.subactivities }

                // Add the subactivities we found
                activitySummaries.append(contentsOf: summariesToCheck)
            } while summariesToCheck.count > 0

            for activitySummary in activitySummaries {
                let summaryAttachments = activitySummary.attachments
                attachments.append(contentsOf: summaryAttachments)
            }

            let testSummaryRefIDs = testMetadata.compactMap { $0.summaryRef?.id }
            summaryRefIDs.append(contentsOf: testSummaryRefIDs)
        }

        for summaryRefID in summaryRefIDs {
            let testJSONString = XCResultToolCommand.Get(path: xcresultPath, id: summaryRefID, outputPath: "", format: .json, console: self.console).run()
            let summaryRefData = Data(testJSONString.utf8)
            
            let testSummary = try decoder.decode(ActionTestSummary.self, from: summaryRefData)

            var activitySummaries = testSummary.activitySummaries

            var summariesToCheck = activitySummaries
            repeat {
                summariesToCheck = summariesToCheck.flatMap { $0.subactivities }

                // Add the subactivities we found
                activitySummaries.append(contentsOf: summariesToCheck)
            } while summariesToCheck.count > 0

            for activitySummary in activitySummaries {
                let summaryAttachments = activitySummary.attachments
                attachments.append(contentsOf: summaryAttachments)
            }
        }

        let destinationURL = URL.init(fileURLWithPath: destination)
        let screenshotsDirURL = destinationURL.appendingPathComponent("testScreenshots")

        console.shellCommand("mkdir \"\(screenshotsDirURL.path)\"")
        for attachment in attachments {
            XCResultToolCommand.Export(path: xcresultPath, attachment: attachment, outputPath: screenshotsDirURL.path, console: self.console).run()
        }
    }
    
    func extractCoverage(xcresultPath : String, destination : String) throws {
        let xcresultJSON = XCResultToolCommand.Get(path: xcresultPath, id: "", outputPath: "", format: .json, console: self.console).run()

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
                                        type: .file, console: self.console).run()
            XCResultToolCommand.Export(path: xcresultPath, id: archiveId,
                                        outputPath: "\(destination)/action.xccovarchive",
                                        type: .directory, console: self.console).run()
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
        case .verbose:
            self.console.verbose = true
            console.writeMessage("Verbose mode enabled")
        case .help:
            console.printUsage()
        case .unknown, .quit:
            console.writeMessage("\nUnknown option \(argument)\n")
            console.printUsage()
        }
    }
    
    func interactiveMode() throws {
        console.writeMessage("Welcome to xcparse \(xcparseVersion). This program can extract screenshots and coverage files from an *.xcresult file.")
        var shouldQuit = false
        while !shouldQuit {
            console.writeMessage("Type 's' to extract screenshots, 'x' for code coverage files, 'v' for verbose, 'h' for help, or 'q' to quit.")
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
            case .verbose:
                console.verbose = true
                console.writeMessage("Verbose mode enabled")
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
