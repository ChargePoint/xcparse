//
//  AppSizeParser.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/29/21.
//

import Foundation

class AppSizeParser: ModelParser<AppSizeModel> {
    typealias keys = AppSizeModel.CodingKeys

    override func parseText() {
        guard !text.isEmpty else { return }
        let parseableText = text.split(separator: ",")
        var properties = [String: String]()

        for text in parseableText {
            for property in AppSizeModel.CodingKeys.allCases {
                let key = property.rawValue
                if text.contains(key) && properties[key]  == nil {
                    let value = text.replacingOccurrences(of: key, with: "")
                    properties[key] = value.trimmingCharacters(in: .whitespaces)
                }
            }
        }

        result = AppSizeModel(compressed: properties[keys.compressed.rawValue] ?? "Unknown",
                              uncompressed: properties[keys.uncompressed.rawValue] ?? "Unknown")
    }
}
