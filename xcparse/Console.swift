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
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
      switch to {
      case .standard:
        print("\(message)")
      case .error:
        fputs("Error: \(message)\n", stderr)
      }
    }
    
    func printUsage() {

        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        writeMessage("USAGE:")
        writeMessage("\(executableName) -x path destination")
        writeMessage("OR")
        writeMessage("\(executableName) --xcov path destination")
        writeMessage("OR")
        writeMessage("\(executableName) -s path destination")
        writeMessage("OR")
        writeMessage("\(executableName) --screenshots path destination")
        writeMessage("OR")
        writeMessage("\(executableName) -h to show usage information")
        writeMessage("OR")
        writeMessage("\(executableName) --help to show usage information")
        writeMessage("OR")
        writeMessage("\(executableName) -q to quit")
        writeMessage("OR")
        writeMessage("\(executableName) --quit to quit")
    }
    
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
    
    func getInput() -> String {
      let keyboard = FileHandle.standardInput
      let inputData = keyboard.availableData
      let strData = String(data: inputData, encoding: String.Encoding.utf8)!
      return strData.trimmingCharacters(in: CharacterSet.newlines)
    }

}
