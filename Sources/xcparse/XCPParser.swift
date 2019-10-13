//
//  XCPParser.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/8/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Basic
import Foundation
import SPMUtility
import XCParseCore

let xcparseCurrentVersion = Version(0, 4, 0)

enum OptionType: String {
    case screenshot = "s"
    case log = "l"
    case xcov = "x"
    case verbose = "v"
    case help = "h"
    case quit = "q"
    case unknown
  
    init(value: String) {
        switch value {
            case "s", "screenshots": self = .screenshot
            case "l", "logs": self = .log
            case "x", "xcov": self = .xcov
            case "v", "verbose": self = .verbose
            case "h", "help": self = .help
            case "q", "quit": self = .quit
            default: self = .unknown
        }
    }
}

class XCPParser {
    var xcparseLatestVersion = xcparseCurrentVersion
    
    var console = Console()
    let decoder = JSONDecoder()

    func getOption(_ option: String) -> (option:OptionType, value: String) {
      return (OptionType(value: option), option)
    }

    func getXCResult(path: String) throws -> ActionsInvocationRecord? {
        guard let xcresultGetResult = XCResultToolCommand.Get(path: path, id: "", outputPath: "", format: .json, console: self.console).run() else {
            return nil
        }
        let xcresultJSON = try xcresultGetResult.utf8Output()
        if xcresultGetResult.exitStatus != .terminated(code: 0) || xcresultJSON == "" {
            return nil
        }

        let xcresultJSONData = Data(xcresultJSON.utf8)
        return try decoder.decode(ActionsInvocationRecord.self, from: xcresultJSONData)
    }
    
    func extractScreenshots(xcresultPath : String, destination : String) throws {
        var attachments: [ActionTestAttachment] = []

        guard let actionRecord = try getXCResult(path: xcresultPath) else {
            return
        }
        
        let testReferenceIDs = actionRecord.actions.compactMap { $0.actionResult.testsRef?.id }

        var summaryRefIDs: [String] = []
        for testRefID in testReferenceIDs {
            guard let testGetResult = XCResultToolCommand.Get(path: xcresultPath, id: testRefID, outputPath: "", format: .json, console: self.console).run() else {
                return
            }
            let testJSONString = try testGetResult.utf8Output()
            if  testGetResult.exitStatus != .terminated(code: 0) || testJSONString == "" {
                continue
            }

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
            guard let summaryGetResult = XCResultToolCommand.Get(path: xcresultPath, id: summaryRefID, outputPath: "", format: .json, console: self.console).run() else {
                return
            }
            let testJSONString = try summaryGetResult.utf8Output()
            if summaryGetResult.exitStatus != .terminated(code: 0) || testJSONString == "" {
                continue
            }

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

        console.shellCommand(["mkdir", screenshotsDirURL.path])

        let progressBar = PercentProgressAnimation(stream: stdoutStream, header: "Exporting Screenshots")
        progressBar.update(step: 0, total: attachments.count, text: "")
        
        for (index, attachment) in attachments.enumerated() {
            progressBar.update(step: index, total: attachments.count, text: "Extracting \"\(attachment.filename ?? "Unknown Filename")\"")

            XCResultToolCommand.Export(path: xcresultPath, attachment: attachment, outputPath: screenshotsDirURL.path, console: self.console).run()
        }
        
        progressBar.update(step: attachments.count, total: attachments.count, text: "🎊 Export complete! 🎊")
        progressBar.complete(success: true)
    }
    
    func extractCoverage(xcresultPath : String, destination : String) throws {
        guard let actionRecord = try getXCResult(path: xcresultPath) else {
            return
        }
        
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

    func extractLogs(xcresultPath : String, destination : String) throws {
        guard let actionRecord = try getXCResult(path: xcresultPath) else {
            return
        }

        for (index, actionRecord) in actionRecord.actions.enumerated() {
            // TODO: Alex - note that these aren't actually log files but ActivityLogSection objects. User from StackOverflow was just exporting those
            // out as text files as for the most party they can be human readable, but it won't match what Xcode exports if you open the XCResult
            // and attempt to export out the log. That seems like it may involve having to create our own pretty printer similar to Xcode's to export
            // the ActivityLogSection into a nicely human readable text file.
            //
            // Also note either we missed in formatDescription objects like ActivityLogCommandInvocationSection or Apple added them in later betas. We'll
            // need to add parsing, using the same style we do for ActionTestSummaryIdentifiableObject subclasses
            if let buildResultLogRef = actionRecord.buildResult.logRef {
//                let activityLogSectionJSON = XCResultToolCommand.Get(path: xcresultPath, id: buildResultLogRef.id, outputPath: "", format: .json).run()
//                let activityLogSection = try decoder.decode(ActivityLogSection.self, from: Data(activityLogSectionJSON.utf8))

                XCResultToolCommand.Export(path: xcresultPath, id: buildResultLogRef.id, outputPath: "\(destination)/\(index + 1)_build.txt", type: .file, console: self.console).run()
            }

            if let actionResultLogRef = actionRecord.actionResult.logRef {
//                let activityLogSectionJSON = XCResultToolCommand.Get(path: xcresultPath, id: actionResultLogRef.id, outputPath: "", format: .json).run()
//                let activityLogSection = try decoder.decode(ActivityLogSection.self, from: Data(activityLogSectionJSON.utf8))

                XCResultToolCommand.Export(path: xcresultPath, id: actionResultLogRef.id, outputPath: "\(destination)/\(index + 1)_action.txt", type: .file, console: self.console).run()
            }
        }
    }

    func printVersion() {
        self.console.writeMessage("\(xcparseCurrentVersion)")
    }

    func checkVersion() {
        let latestReleaseURL = URL(string: "https://api.github.com/repos/ChargePoint/xcparse/releases/latest")!

        var releaseRequest = URLRequest(url: latestReleaseURL)
        releaseRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: releaseRequest) { (data, response, error) in
            if error != nil || data == nil {
                return
            }

            do {
                let releaseResponse = try JSONDecoder().decode(GitHubLatestReleaseResponse.self, from: data!)
                if let latestVersion = Version(string: releaseResponse.name) {
                    DispatchQueue.main.async {
                        self.xcparseLatestVersion = latestVersion
                    }
                }
            } catch {
                // Do nothing for now
            }
        }
        task.resume()
    }

    func printLatestVersionInfoIfNeeded() {
        if self.xcparseLatestVersion > xcparseCurrentVersion {
            self.console.writeMessage("New xcparse Version \(self.xcparseLatestVersion) is available! Update using \"brew upgrade xcparse\".")
        }
    }
    
    func staticMode() throws {
        checkVersion()

        var registry = CommandRegistry(usage: "<command> <options>",
                                       overview: "This program can extract screenshots and coverage files from an *.xcresult file.")
        registry.register(command: ScreenshotsCommand.self)
        registry.register(command: CodeCoverageCommand.self)
        registry.register(command: LogsCommand.self)
        registry.register(command: VersionCommand.self)
        registry.run()

        self.printLatestVersionInfoIfNeeded()
    }
    
    func interactiveMode() throws {
        checkVersion()
        console.writeMessage("Welcome to xcparse \(xcparseCurrentVersion). This program can extract screenshots and coverage files from an *.xcresult file.")

        var shouldQuit = false
        while !shouldQuit {
            self.printLatestVersionInfoIfNeeded()
            console.writeMessage("Type 's' to extract screenshots, 'l' for logs, 'x' for code coverage files, 'v' for verbose, 'h' for help, or 'q' to quit.")
            let (option, value) = getOption(console.getInput())
            switch option {
            case .screenshot:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your screenshots:")
                let destinationPath = console.getInput()
                try extractScreenshots(xcresultPath: path, destination: destinationPath)
            case .log:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your logs:")
                let destinationPath = console.getInput()
                try extractLogs(xcresultPath: path, destination: destinationPath)
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
                console.printInteractiveUsage()
            default:
                console.writeMessage("Unknown option \(value)", to: .error)
                console.printInteractiveUsage()
            }
        }
    }
    
    
}
