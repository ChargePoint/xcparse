//
//  URL+Directory.swift
//  
//
//  Created by Alexander Botkin on 7/5/20.
//

import Foundation

public extension Foundation.URL {
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
