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
    
    func run() {
        preconditionFailure("This method should be overriden")
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
        
        override func run() {
            let command = "\(commandPrefix) export --path \"\(self.path)\" --id \(self.id) --output-path \"\(self.outputPath)\" --type \(self.type.rawValue)"
            console.shellCommand(command)
        }
    }
}
