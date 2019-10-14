//
//  XCResultToolCommand.swift
//  xcparse
//
//  Created by Nikita Zamalyutdinov on 10/03/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Basic
import Foundation
import SPMUtility

let xcresultToolArguments = ["xcrun", "xcresulttool"]

open class XCResultToolCommand {
    let process: Basic.Process

    let console: Console

    public init(withConsole console: Console = Console(), process: Basic.Process = Basic.Process(arguments: ["xcrun", "xcresulttool", "-h"])) {
        self.console = console
        self.process = process
    }
    
    @discardableResult public func run() -> Basic.ProcessResult? {
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
        
        var path: String = ""
        var id: String = ""
        var outputPath: String = ""
        var type: ExportType = ExportType.file
        
        public init(path: String, id: String, outputPath: String, type: ExportType, console: Console = Console()) {
            self.path = path
            self.id = id
            self.outputPath = outputPath
            self.type = type

            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["export",
                                            "--type", self.type.rawValue,
                                            "--path", self.path,
                                            "--id", self.id,
                                            "--output-path", self.outputPath])

            let process = Basic.Process(arguments: processArgs)
            super.init(withConsole: console, process: process)
        }

        public init(path: String, attachment: ActionTestAttachment, outputPath: String, console: Console = Console()) {
            self.path = path

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
                                            "--path", self.path,
                                            "--id", self.id,
                                            "--output-path", self.outputPath])

            let process = Basic.Process(arguments: processArgs)
            super.init(withConsole: console, process: process)
        }
    }

    open class Get: XCResultToolCommand {
        var path: String = ""
        var id: String = ""
        var outputPath: String = ""
        var format = FormatType.raw

        public init(path: String, id: String, outputPath: String, format: FormatType, console: Console = Console()) {
            self.path = path
            self.id = id
            self.outputPath = outputPath
            self.format = format

            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["get",
                                            "--path", self.path,
                                            "--format", self.format.rawValue])
            if self.id != "" {
                processArgs.append(contentsOf: ["--id", self.id])
            }
            if self.outputPath != "" {
                processArgs.append(contentsOf: ["--output-path", self.outputPath])
            }

            let process = Basic.Process(arguments: processArgs)
            super.init(withConsole: console, process: process)
        }
    }

    open class Graph: XCResultToolCommand {
        var id: String = ""
        var path: String = ""
        var version: Int?

        public init(id: String, path: String, version: Int?, console: Console = Console()) {
            self.id = id
            self.path = path
            self.version = version

            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["graph",
                                            "--path", self.path])
            if self.id != "" {
                processArgs.append(contentsOf: ["--id", self.id])
            }
            if let version = self.version {
                processArgs.append(contentsOf: ["--version", "\(version)"])
            }

            let process = Basic.Process(arguments: processArgs)
            super.init(withConsole: console, process: process)
        }
    }

    open class MetadataGet: XCResultToolCommand {
        var path: String = ""

        public init(path: String, console: Console = Console()) {
            self.path = path

            var processArgs = xcresultToolArguments
            processArgs.append(contentsOf: ["metadata", "get",
                                            "--path", self.path])

            let process = Basic.Process(arguments: processArgs)
            super.init(withConsole: console, process: process)
        }
    }
}
