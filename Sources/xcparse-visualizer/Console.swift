//
//  ConsoleIO.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/8/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

enum OutputType {
  case error
  case standard
}

class Console {
    
    // MARK: -
    // MARK: Shell
    // user3064009's answer on https://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild
    func shellCommand(_ command: String) -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        
        return output
    }
    
}
