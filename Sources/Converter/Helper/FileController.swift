//
//  FileController.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/25/21.
//

import Foundation

public class FileController {
    // load file with given url
    public static func loadFileContents(url: String) -> String? {
        var res: String?
        let url = URL(fileURLWithPath: url)
        if let fileContents = try? String(contentsOf: url) {
            res = fileContents
        }

        return res
    }

    // write file to the url directory for the given data
    public static func writeFile(data: String, url: String, outputName: String = "report", format: String = "json") {
        let url = URL(fileURLWithPath: url)
        let location = url.appendingPathComponent("\(outputName).\(format)")
        do {
            try data.write(to: location, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
}
