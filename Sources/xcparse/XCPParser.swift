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

let xcparseCurrentVersion = Version(1, 0, 0)

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

    func createDirectoryIfNecessary(createIntermediates: Bool = false, console: Console = Console()) -> Bool {
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
            if createIntermediates == true {
                console.shellCommand(["mkdir", "-p", self.path])
            } else {
                console.shellCommand(["mkdir", self.path])
            }
        }

        return self.fileExistsAsDirectory()
    }
}

struct AttachmentExportOptions {
    var addTestScreenshotsDirectory: Bool = false
    var divideByTargetModel: Bool = false
    var divideByTargetOS: Bool = false
    var divideByTestRun: Bool = false
    var divideByTest: Bool = false

    var testSummaryFilter: (ActionTestSummary) -> Bool = { _ in
        return true
    }
    var activitySummaryFilter: (ActionTestActivitySummary) -> Bool = { _ in
        return true
    }
    var attachmentFilter: (ActionTestAttachment) -> Bool = { _ in
        return true
    }

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

        if self.divideByTargetModel == true, self.divideByTargetOS == true {
            targetDeviceFolderName = deviceRecord.modelName + " (\(deviceRecord.operatingSystemVersion))"
        } else if self.divideByTargetModel {
            targetDeviceFolderName = deviceRecord.modelName
        } else if self.divideByTargetOS {
            targetDeviceFolderName = deviceRecord.operatingSystemVersion
        }

        if let folderName = targetDeviceFolderName {
            return baseURL.appendingPathComponent(folderName, isDirectory: true)
        } else {
            return baseURL
        }
    }

    func screenshotDirectoryURL(_ testPlanRun: ActionTestPlanRunSummary, forBaseURL baseURL: Foundation.URL) -> Foundation.URL {
        guard let testPlanRunName = testPlanRun.name else {
            return baseURL
        }

        if self.divideByTestRun {
            return baseURL.appendingPathComponent(testPlanRunName, isDirectory: true)
        } else {
            return baseURL
        }
    }

    func screenshotDirectoryURL(_ testSummary: ActionTestSummary, forBaseURL baseURL: Foundation.URL) -> Foundation.URL {
        guard let summaryIdentifier = testSummary.identifier else {
            return baseURL
        }

        if self.divideByTest == true {
            return baseURL.appendingPathComponent(summaryIdentifier, isDirectory: true)
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

    func extractAttachments(xcresultPath: String, destination: String, options: AttachmentExportOptions = AttachmentExportOptions()) throws {
        var xcresult = XCResult(path: xcresultPath, console: self.console)
        guard let invocationRecord = xcresult.invocationRecord else {
            return
        }

        // Let's figure out where these attachments are going
        let screenshotBaseDirectoryURL = options.baseScreenshotDirectoryURL(path: destination)
        if screenshotBaseDirectoryURL.createDirectoryIfNecessary() != true {
            return
        }

        // This is going to be the mapping of the places we're going to export the screenshots to
        var exportURLsToAttachments: [String : [ActionTestAttachment]] = [:]

        let actions = invocationRecord.actions.filter { $0.actionResult.testsRef != nil }
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

            for testPlanRun in testPlanRunSummaries.summaries {
                let testPlanRunScreenshotURL = options.screenshotDirectoryURL(testPlanRun, forBaseURL: actionScreenshotDirectoryURL)
                if testPlanRunScreenshotURL.createDirectoryIfNecessary() != true {
                    continue
                }

                let testableSummaries = testPlanRun.testableSummaries
                let testableSummariesToTestActivity = testableSummaries.flatMap { $0.flattenedTestSummaryMap(withXCResult: xcresult) }
                for (testableSummary, childActivitySummaries) in testableSummariesToTestActivity {
                    if options.testSummaryFilter(testableSummary) == false {
                        continue
                    }

                    let filteredChildActivities = childActivitySummaries.filter(options.activitySummaryFilter)
                    let filteredAttachments = filteredChildActivities.flatMap { $0.attachments.filter(options.attachmentFilter) }

                    let testableSummaryScreenshotURL = options.screenshotDirectoryURL(testableSummary, forBaseURL: testPlanRunScreenshotURL)
                    if testableSummaryScreenshotURL.createDirectoryIfNecessary(createIntermediates: true) != true {
                        continue
                    }

                    // Now that we know what we want to export, save it to the dictionary so we can have all the exports
                    // done at once with one progress bar per URL
                    var existingAttachmentsForURL = exportURLsToAttachments[testableSummaryScreenshotURL.path] ?? []
                    existingAttachmentsForURL.append(contentsOf: filteredAttachments)
                    exportURLsToAttachments[testableSummaryScreenshotURL.path] = existingAttachmentsForURL
                }
            }
        }

        // Let's get ready to export!
        for (exportURLString, attachmentsToExport) in exportURLsToAttachments.sorted(by: { $0.key < $1.key }) {
            let exportURL = Foundation.URL(fileURLWithPath: exportURLString)
            if attachmentsToExport.count <= 0 {
                continue
            }

            let exportRelativePath = exportURL.path.replacingOccurrences(of: screenshotBaseDirectoryURL.path, with: "").trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            let displayName = exportRelativePath.replacingOccurrences(of: "/", with: " - ")

            self.exportAttachments(withXCResult: xcresult, toDirectory: exportURL, attachments: attachmentsToExport, displayName: displayName)
        }
    }

    func exportAttachments(withXCResult xcresult: XCResult, toDirectory screenshotDirectoryURL: Foundation.URL, attachments: [ActionTestAttachment], displayName: String = "") {
        if attachments.count <= 0 {
            return
        }

        let header = (displayName != "") ? "Exporting \"\(displayName)\" Attachments" : "Exporting Attachments"
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
        registry.register(command: AttachmentsCommand.self)
        registry.register(command: VersionCommand.self)
        registry.run()

        self.printLatestVersionInfoIfNeeded()
    }
}
