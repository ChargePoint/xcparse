//
//  ConsoleIO.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/8/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Basic
import Foundation

public enum OutputType {
  case error
  case standard
  case verbose
}

open class Console {
    public var verbose = false

    public init(verbose: Bool = false) {
        self.verbose = verbose
    }
    
    public func writeMessage(_ message: String, to: OutputType = .standard) {
      switch to {
      case .standard:
        if message != "" {
            print("\(message)")
        }
      case .verbose:
        if self.verbose == true && message != "" {
            print("\(message)")
        }
      case .error:
        fputs("Error: \(message)\n", stderr)
      }
    }
    
    public func printUsage() {
        writeMessage("usage (static mode): xcparse [-hq] [-s xcresultPath destination] [-x xcresultPath destination]\n")
        writeMessage("xcparse only accepts a single option at a time.\n")
        writeMessage("usage (interactive mode): xcparse\n")
        writeMessage(" -s, --screenshots : Extracts screenshots from xcresult file at xcresultPath and saves it in destination folder.")
        writeMessage(" -x, --xcov : Extracts coverage from xcresult file at xcresultPath and saves it in destination folder.")
        writeMessage(" -l, --logs : Extracts logs from xcresult file at xcresultPath and saves them to destination folder.")
        writeMessage(" -v, --verbose : Run in verbose mode.")
        writeMessage(" -h, --help : Prints usage message.")
        writeMessage(" -q, --quit : Exits interactive mode. Cannot be used in static mode.")
    }
    
    // MARK: -
    // MARK: Shell
    @discardableResult public func shellCommand(_ command: [String]) -> String {
        self.writeMessage("Command: \(command.joined(separator: " "))\n", to: .verbose)

        let process = Basic.Process(arguments: command)
        do {
            try process.launch()
            let result = try process.waitUntilExit()

            let retval = try result.utf8Output()
            self.writeMessage(retval, to: .verbose)
            return retval
        } catch {
            print("Error when performing command")
            return ""
        }
    }
    
    public func getInput() -> String {
      let keyboard = FileHandle.standardInput
      let inputData = keyboard.availableData
      let strData = String(data: inputData, encoding: String.Encoding.utf8)!
      return strData.trimmingCharacters(in: CharacterSet.newlines)
    }

}
