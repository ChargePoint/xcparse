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

let xcparseCurrentVersion = Version(0, 5, 0)

enum InteractiveModeOptionType: String {
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

extension Foundation.URL {
    func fileExistsAsDirectory() -> Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                return true // Exists as a directory
            } else {
                return false // Exists as a file
            }
        } else {
            return false // Does not exist
        }
    }

    func createDirectoryIfNecessary(console: Console = Console()) -> Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: self.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                // Directory already exists, do nothing
                return true
            } else {
                console.writeMessage("\(self) is not a directory", to: .error)
                return false
            }
        } else {
            console.shellCommand(["mkdir", self.path])
        }

        return self.fileExistsAsDirectory()
    }
}

struct AttachmentExportOptions {
    var addTestScreenshotsDirectory: Bool = false
    var divideByTargetModel: Bool = false
    var divideByTargetOS: Bool = false

    func baseScreenshotDirectoryURL(path: String) -> Foundation.URL {
        let destinationURL = URL.init(fileURLWithPath: path)
        if self.addTestScreenshotsDirectory {
            return destinationURL.appendingPathComponent("testScreenshots")
        } else {
            return destinationURL
        }
    }

    func screenshotDirectoryURL(_ deviceRecord: ActionDeviceRecord, forBaseURL baseURL: Foundation.URL) -> Foundation.URL {
        var targetDeviceFolderName: String? = nil

        if self.divideByTargetModel && self.divideByTargetOS {
            targetDeviceFolderName = deviceRecord.modelName + " (\(deviceRecord.operatingSystemVersion))"
        } else if self.divideByTargetModel {
            targetDeviceFolderName = deviceRecord.modelName
        } else if self.divideByTargetOS {
            targetDeviceFolderName = deviceRecord.operatingSystemVersion
        }

        if let folderName = targetDeviceFolderName {
            return baseURL.appendingPathComponent(folderName)
        } else {
            return baseURL
        }
    }
}

class XCPParser {
    var xcparseLatestVersion = xcparseCurrentVersion
    
    var console = Console()
    let decoder = JSONDecoder()

    // MARK: -
    // MARK: Parsing Actions
    
    func extractScreenshots(xcresultPath: String, destination: String, options: AttachmentExportOptions = AttachmentExportOptions()) throws {
        var xcresult = XCResult(path: xcresultPath, console: self.console)
        guard let invocationRecord = xcresult.invocationRecord else {
            return
        }

        // Let's figure out where these attachments are going
        let screenshotBaseDirectoryURL = options.baseScreenshotDirectoryURL(path: destination)
        if screenshotBaseDirectoryURL.createDirectoryIfNecessary() != true {
            return
        }

        let actions = invocationRecord.actions.filter { $0.actionResult.testsRef != nil }

        var attachmentsToExportToBaseDirectory: [ActionTestAttachment] = []
        for action in actions {
            guard let testRef = action.actionResult.testsRef else {
                continue
            }

            let targetDeviceRecord = action.runDestination.targetDeviceRecord

            // Determine name for the directory & make the directory if necessary
            let actionScreenshotDirectoryURL = options.screenshotDirectoryURL(targetDeviceRecord, forBaseURL: screenshotBaseDirectoryURL)
            if actionScreenshotDirectoryURL.createDirectoryIfNecessary() != true {
                continue
            }

            // Let's figure out the attachments to export
            guard let testPlanRunSummaries: ActionTestPlanRunSummaries = testRef.modelFromReference(withXCResult: xcresult) else {
                xcresult.console.writeMessage("Error: Unhandled test reference type \(String(describing: testRef.targetType?.getType()))", to: .error)
                continue
            }
            let testableSummaries = testPlanRunSummaries.summaries.flatMap { $0.testableSummaries }
            let testableSummariesAttachments = testableSummaries.flatMap { $0.attachments(withXCResult: xcresult) }

            // Now that we know what we want to export, figure out if it should go to base directory or not
            let exportToBaseScreenshotDirectory = (actionScreenshotDirectoryURL == screenshotBaseDirectoryURL)
            if exportToBaseScreenshotDirectory {
                // Wait to export these all in one nice progress bar at end
                attachmentsToExportToBaseDirectory.append(contentsOf: testableSummariesAttachments)
            } else {
                // Let's get ready to export!
                let displayName = actionScreenshotDirectoryURL.lastPathComponent
                self.exportScreenshots(withXCResult: xcresult, toDirectory: actionScreenshotDirectoryURL, attachments: testableSummariesAttachments, displayName: displayName)
            }
        }

        // Now let's export everything that wanted to just be in the base directory
        if attachmentsToExportToBaseDirectory.count > 0 {
            self.exportScreenshots(withXCResult: xcresult, toDirectory: screenshotBaseDirectoryURL, attachments: attachmentsToExportToBaseDirectory)
        }
    }

    func exportScreenshots(withXCResult xcresult: XCResult, toDirectory screenshotDirectoryURL: Foundation.URL, attachments: [ActionTestAttachment], displayName: String = "") {
        if attachments.count <= 0 {
            return
        }

        let header = (displayName != "") ? "Exporting \"\(displayName)\" Screenshots" : "Exporting Screenshots"
        let progressBar = PercentProgressAnimation(stream: stdoutStream, header: header)
        progressBar.update(step: 0, total: attachments.count, text: "")

        for (index, attachment) in attachments.enumerated() {
            progressBar.update(step: index, total: attachments.count, text: "Extracting \"\(attachment.filename ?? "Unknown Filename")\"")

            XCResultToolCommand.Export(withXCResult: xcresult, attachment: attachment, outputPath: screenshotDirectoryURL.path).run()
        }

        progressBar.update(step: attachments.count, total: attachments.count, text: "🎊 Export complete! 🎊")
        progressBar.complete(success: true)
    }
    
    func extractCoverage(xcresultPath : String, destination : String) throws {
        var xcresult = XCResult(path: xcresultPath, console: self.console)
        guard let invocationRecord = xcresult.invocationRecord else {
            return
        }
        
        var coverageReferenceIDs: [String] = []
        var coverageArchiveIDs: [String] = []
        
        for action in invocationRecord.actions {
            if let reportRef = action.actionResult.coverage.reportRef {
                coverageReferenceIDs.append(reportRef.id)
            }
            if let archiveRef = action.actionResult.coverage.archiveRef {
                coverageArchiveIDs.append(archiveRef.id)
            }
        }
        for (reportId, archiveId) in zip(coverageReferenceIDs, coverageArchiveIDs) {
            XCResultToolCommand.Export(withXCResult: xcresult, id: reportId,
                                        outputPath: "\(destination)/action.xccovreport",
                                        type: .file).run()
            XCResultToolCommand.Export(withXCResult: xcresult, id: archiveId,
                                        outputPath: "\(destination)/action.xccovarchive",
                                        type: .directory).run()
        }
    }

    func extractLogs(xcresultPath : String, destination : String) throws {
        var xcresult = XCResult(path: xcresultPath, console: self.console)
        guard let invocationRecord = xcresult.invocationRecord else {
            return
        }

        for (index, actionRecord) in invocationRecord.actions.enumerated() {
            // TODO: Alex - note that these aren't actually log files but ActivityLogSection objects. User from StackOverflow was just exporting those
            // out as text files as for the most party they can be human readable, but it won't match what Xcode exports if you open the XCResult
            // and attempt to export out the log. That seems like it may involve having to create our own pretty printer similar to Xcode's to export
            // the ActivityLogSection into a nicely human readable text file.
            //
            // Also note either we missed in formatDescription objects like ActivityLogCommandInvocationSection or Apple added them in later betas. We'll
            // need to add parsing, using the same style we do for ActionTestSummaryIdentifiableObject subclasses
            if let buildResultLogRef = actionRecord.buildResult.logRef {
//                let activityLogSectionJSON = XCResultToolCommand.Get(withXCResult: xcresult, id: buildResultLogRef.id, outputPath: "", format: .json).run()
//                let activityLogSection = try decoder.decode(ActivityLogSection.self, from: Data(activityLogSectionJSON.utf8))

                XCResultToolCommand.Export(withXCResult: xcresult, id: buildResultLogRef.id, outputPath: "\(destination)/\(index + 1)_build.txt", type: .file).run()
            }

            if let actionResultLogRef = actionRecord.actionResult.logRef {
//                let activityLogSectionJSON = XCResultToolCommand.Get(withXCResult: xcresult, id: actionResultLogRef.id, outputPath: "", format: .json).run()
//                let activityLogSection = try decoder.decode(ActivityLogSection.self, from: Data(activityLogSectionJSON.utf8))

                XCResultToolCommand.Export(withXCResult: xcresult, id: actionResultLogRef.id, outputPath: "\(destination)/\(index + 1)_action.txt", type: .file).run()
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

    // MARK: -
    // MARK: Modes
    
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

    func getInteractiveModeOption(_ option: String) -> (option: InteractiveModeOptionType, value: String) {
      return (InteractiveModeOptionType(value: option), option)
    }
    
    func interactiveMode() throws {
        checkVersion()
        console.writeMessage("Welcome to xcparse \(xcparseCurrentVersion). This program can extract screenshots and coverage files from an *.xcresult file.")

        var shouldQuit = false
        while !shouldQuit {
            self.printLatestVersionInfoIfNeeded()

            console.writeMessage("Type 's' to extract screenshots, 'l' for logs, 'x' for code coverage files, 'v' for verbose, 'h' for help, or 'q' to quit.")

            let (option, value) = getInteractiveModeOption(console.getInput())

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
