//
//  XCResultToolCommand.swift
//  xcparse
//
//  Created by Nikita Zamalyutdinov on 10/03/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import TSCBasic
import TSCUtility

let xcresultToolArguments = ["xcrun", "xcresulttool"]

open class XCResultToolCommand {
    let process: TSCBasic.Process

    let xcresult: XCResult
    var console: Console {
        get {
            return self.xcresult.console
        }
    }

    public init(withXCResult xcresult: XCResult, process: TSCBasic.Process = TSCBasic.Process(arguments: ["xcrun", "xcresulttool", "-h"])) {
        self.xcresult = xcresult
        self.process = process
    }
    
    @discardableResult public func run() -> TSCBasic.ProcessResult? {
        do {
            self.console.writeMessage("Command: \(process.arguments.joined(separator: " "))\n", to: .verbose)

            try process.launch()
            let result = try process.waitUntilExit()

            let stderr = try result.utf8stderrOutput()
            if stderr != "" {
                self.console.writeMessage(stderr, to: .error)
            }

            let stdout = try result.utf8Output()
            self.console.writeMessage(stdout, to: .verbose)

            return result
        } catch {
            print("Error when performing command")
            return nil
        }
    }

    public enum FormatType: String {
        case raw = "raw"
        case json = "json"
    }
    
    open class Export: XCResultToolCommand {
        public enum ExportType: String {
            case file = "file"
            case directory = "directory"
        }

        var id: String = ""
        var outputPath: String = ""
        var type: ExportType = ExportType.file
        
        public init(withXCResult xcresult: XCResult, id: String, outputPath: String, type: ExportType) {
            self.id = id
            self.outputPath = outputPath
            self.type = type

            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["export",
                                            "--type", self.type.rawValue,
                                            "--path", xcresult.path,
                                            "--id", self.id,
                                            "--output-path", self.outputPath])
            processArgs.addLegacyFlagIfNeeded()

            let process = TSCBasic.Process(arguments: processArgs)
            super.init(withXCResult: xcresult, process: process)
        }

        public init(withXCResult xcresult: XCResult, attachment: ActionTestAttachment, outputPath: String) {
            if let identifier = attachment.payloadRef?.id {
                self.id = identifier;

                // Now let's figure out the filename & path
                let filename = attachment.filename ?? identifier
                let attachmentOutputPath = URL.init(fileURLWithPath: outputPath).appendingPathComponent(filename)
                self.outputPath = attachmentOutputPath.path
            }

            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["export",
                                            "--type", self.type.rawValue,
                                            "--path", xcresult.path,
                                            "--id", self.id,
                                            "--output-path", self.outputPath])

            processArgs.addLegacyFlagIfNeeded()

            let process = TSCBasic.Process(arguments: processArgs)
            super.init(withXCResult: xcresult, process: process)
        }
    }

    open class Get: XCResultToolCommand {
        var id: String = ""
        var outputPath: String = ""
        var format = FormatType.raw

        convenience public init(path: String, id: String, outputPath: String, format: FormatType, console: Console = Console()) {
            let xcresult = XCResult(path: path, console: console)
            self.init(withXCResult: xcresult, id: id, outputPath: outputPath, format: format)
        }

        public init(withXCResult xcresult: XCResult, id: String, outputPath: String, format: FormatType) {
            self.id = id
            self.outputPath = outputPath
            self.format = format

            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["get",
                                            "--path", xcresult.path,
                                            "--format", self.format.rawValue])
            if self.id != "" {
                processArgs.append(contentsOf: ["--id", self.id])
            }
            if self.outputPath != "" {
                processArgs.append(contentsOf: ["--output-path", self.outputPath])
            }
            processArgs.addLegacyFlagIfNeeded()

            let process = TSCBasic.Process(arguments: processArgs)
            super.init(withXCResult: xcresult, process: process)
        }
    }

    open class Graph: XCResultToolCommand {
        var id: String = ""
        var version: Int?

        public init(withXCResult xcresult: XCResult, id: String, version: Int?) {
            self.id = id
            self.version = version

            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["graph",
                                            "--path", xcresult.path])
            if self.id != "" {
                processArgs.append(contentsOf: ["--id", self.id])
            }
            if let version = self.version {
                processArgs.append(contentsOf: ["--version", "\(version)"])
            }
            processArgs.addLegacyFlagIfNeeded()

            let process = TSCBasic.Process(arguments: processArgs)
            super.init(withXCResult: xcresult, process: process)
        }
    }

    open class MetadataGet: XCResultToolCommand {

        public init(withXCResult xcresult: XCResult) {
            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["metadata", "get",
                                            "--path", xcresult.path])

            let process = TSCBasic.Process(arguments: processArgs)
            super.init(withXCResult: xcresult, process: process)
        }
    }

    open class Version: XCResultToolCommand {

        public init() {
            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["version"])

            let xcresult = XCResult(path: "")
            let process = TSCBasic.Process(arguments: processArgs)
            super.init(withXCResult: xcresult, process: process)
        }
    }
}

// MARK: - Legacy flag

private let shouldAddLegacyFlag: Bool = {
    guard let xcresulttoolVersion = Version.xcresulttool() else {
      return false
    }

    let versionWithDeprecatedAPIs = Version.xcresulttoolWithDeprecatedAPIs()

    return xcresulttoolVersion >= versionWithDeprecatedAPIs
}()

private extension Array where Element: StringProtocol {
  mutating func addLegacyFlagIfNeeded() {
    if shouldAddLegacyFlag {
      self.append("--legacy")
    }
  }
}
