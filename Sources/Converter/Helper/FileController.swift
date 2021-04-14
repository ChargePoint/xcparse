//
//  FileController.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/25/21.
//

import Foundation

public class FileController {
    // load file with given url
    public static func loadFile(url: String) -> String? {
        var res: String?
        let url = URL(fileURLWithPath: url)
        if let fileContents = try? String(contentsOf: url) {
            res = fileContents
        }

        return res
    }

    // write file to the url directory for the given data
    public static func writeFile(data: String, url: String, _ outputName: String = "report") {
        let url = URL(fileURLWithPath: url)
        let location = url.appendingPathComponent("\(outputName).json")
        do {
            try data.write(to: location, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
}
