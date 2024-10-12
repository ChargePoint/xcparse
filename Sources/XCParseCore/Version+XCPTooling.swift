//
//  Version+XCPTooling.swift
//  XCParseCore
//
//  Created by Alex Botkin on 11/8/19.
//

import Foundation
import TSCUtility

public extension Version {
    static func xcresulttoolCompatibleWithUnicodeExportPath() -> Version {
        return Version(15500, 0, 0)
    }

    static func xcresulttoolWithDeprecatedAPIs() -> Version {
        return Version(23028, 0, 0)
    }

    static func xcresulttool() -> Version? {
        guard let xcresulttoolVersionResult = XCResultToolCommand.Version().run() else {
            return nil
        }
        do {
            let xcresultVersionString = try xcresulttoolVersionResult.utf8Output()

            let components = xcresultVersionString.components(separatedBy: CharacterSet(charactersIn: ",\n"))
            for string in components {
                let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmedString.hasPrefix("xcresulttool version ") {
                    let xcresulttoolVersionString = trimmedString.replacingOccurrences(of: "xcresulttool version ", with: "")
                    // Check to see if we can convert it to a number
                    var xcresulttoolVersion: Version?

                    if let xcresulttoolVersionInt = Int(xcresulttoolVersionString) {
                        xcresulttoolVersion = Version(xcresulttoolVersionInt, 0, 0)
                    } else {
                        xcresulttoolVersion = Version(string: xcresulttoolVersionString)
                    }

                    return xcresulttoolVersion
                }
            }

            return nil
        } catch {
            print("Failed to parse xcresulttool version with error: \(error)")
            return nil
        }
    }
}
