//
//  XCResultToolCommand.swift
//  xcparse
//
//  Created by Nikita Zamalyutdinov on 10/03/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import XCParseCore

class XCResultToolCommand {
    
    let commandPrefix = "xcrun xcresulttool"
    
    let console = Console()
    
    @discardableResult func run() -> String {
        preconditionFailure("This method should be overriden")
    }

    enum FormatType: String {
        case raw = "raw"
        case json = "json"
    }
    
    class Export: XCResultToolCommand {
        enum ExportType: String {
            case file = "file"
            case directory = "directory"
        }
        
        var path: String = ""
        var id: String = ""
        var outputPath: String = ""
        var type: ExportType = ExportType.file
        
        init(path: String, id: String, outputPath: String, type: ExportType) {
            self.path = path
            self.id = id
            self.outputPath = outputPath
            self.type = type
        }

        init(path: String, attachment: ActionTestAttachment, outputPath: String) {
            self.path = path

            if let identifier = attachment.payloadRef?.id {
                self.id = identifier;

                // Now let's figure out the filename & path
                let filename = attachment.filename ?? identifier
                let attachmentOutputPath = URL.init(fileURLWithPath: outputPath).appendingPathComponent(filename)

                self.outputPath = attachmentOutputPath.path
            }
        }
        
        @discardableResult override func run() -> String {
            let command = "\(commandPrefix) export --path \"\(self.path)\" --id \(self.id) --output-path \"\(self.outputPath)\" --type \(self.type.rawValue)"
            return console.shellCommand(command)
        }
    }

    class Get: XCResultToolCommand {
        var path: String = ""
        var id: String = ""
        var outputPath: String = ""
        var format = FormatType.raw

        init(path: String, id: String, outputPath: String, format: FormatType) {
            self.path = path
            self.id = id
            self.outputPath = outputPath
            self.format = format
        }

        @discardableResult override func run() -> String {
            var command = "\(commandPrefix) get --path \"\(self.path)\" --format \(self.format)"
            if self.id != "" {
                command += " --id \"\(self.id)\""
            }
            if self.outputPath != "" {
                command += " > \"\(self.outputPath)\""
            }

            return console.shellCommand(command)
        }
    }

    class Graph: XCResultToolCommand {
        var id: String = ""
        var path: String = ""
        var version: Int?

        init(id: String, path: String, version: Int?) {
            self.id = id
            self.path = path
            self.version = version
        }

        @discardableResult override func run() -> String {
            var command = "\(commandPrefix) graph --path \"\(self.path)\""
            if self.id != "" {
                command += " --id \"\(self.id)\""
            }
            if let version = self.version {
                command += " --version \(version)"
            }

            return console.shellCommand(command)
        }
    }

    class MetadataGet: XCResultToolCommand {
        var path: String = ""

        init(path: String) {
            self.path = path
        }

        @discardableResult override func run() -> String {
            let command = "\(commandPrefix) metadata get --path \"\(self.path)\""

            return console.shellCommand(command)
        }
    }
}
