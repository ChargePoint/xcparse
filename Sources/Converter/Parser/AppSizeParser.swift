//
//  AppSizeParser.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/29/21.
//

import Foundation

final class AppSizeParser: ModelParser<AppSizeModel> {
    typealias keys = AppSizeModel.CodingKeys
    var standardizedUnit: MemorySize.Unit = .megabytes

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

        if let compressedString = properties[keys.compressed.rawValue],
           let uncompressedString = properties[keys.uncompressed.rawValue],
           let compressedValue = MemorySize(text: compressedString)?.megabytes,
           let uncompressedValue = MemorySize(text: uncompressedString)?.megabytes
           {
            let compressedRawValue = compressedString.lowercased() == MemorySize.zeroSize ? "0 KB" : compressedString
            let compressed = SizeModel(rawValue: compressedRawValue,
                                       value: compressedValue,
                                       unit: standardizedUnit)
            let uncompressedRawValue = uncompressedString.lowercased() == MemorySize.zeroSize ? "0 KB" : uncompressedString
            let uncompressed = SizeModel(rawValue: uncompressedRawValue,
                                       value: uncompressedValue,
                                       unit: standardizedUnit)
            result = AppSizeModel(compressed: compressed, uncompressed: uncompressed)
        } else {
            result = AppSizeModel()
        }
    }
}

