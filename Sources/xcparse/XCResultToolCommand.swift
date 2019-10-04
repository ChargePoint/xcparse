//
//  XCResultToolCommand.swift
//  xcparse
//
//  Created by Nikita Zamalyutdinov on 10/03/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

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
}
