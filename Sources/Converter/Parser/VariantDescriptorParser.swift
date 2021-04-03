//
//  VariantDescriptorParser.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/29/21.
//

import Foundation

final class VariantDescriptorParser: ModelParser<[DeviceModel]> {
    typealias keys = DeviceModel.ParsingKeys

    override func parseText() {
        guard !text.isEmpty else { return }
        let text = Array(self.text)

        // start index of each model that we need to parse
        var start = 0
        var models = [DeviceModel]()

        // get the value between "[" and "]"
        for i in text.indices {
            if text[i] == "[" {
                start = i+1
            } else if text[i] == "]" {
                let model = parseToModel(text: Array(text[start..<i]))
                models.append(model)
            }
        }

        let universalVariant = VariantDescriptorParser.universalVariantText
        if String(text).lowercased().contains(universalVariant) {
            let model = DeviceModel(device: universalVariant.capitalized,
                                    osVersion: "")
            models.append(model)
        }

        result = models
    }

    func parseToModel(text: String) -> DeviceModel {
        return parseToModel(text: Array(text))
    }

    func parseToModel(text: [Character]) -> DeviceModel {
        func isSeparator(text: [Character], i: Int) -> Bool {
            return i-1 > text.count || i+1 >= text.count || !(text[i-1].isNumber && text[i+1].isNumber)
        }

        // split the string based on key value pairs
        var properties = [String: String]()

        // start point of the string that we are going to parse
        var start = 0

        // we need to temporarely store the key that we found until we have the value of it parse
        var key = ""

        for i in text.indices {
            if text[i] == ":" { // the separator between key and value
                key = String(text[start..<i])
                start = Int(i) + 1
            } else if text[i] == "," && isSeparator(text: text, i: i) { // check if the comma is a separator between properties
                properties[key] = String(text[start..<i]).trimmingCharacters(in: .whitespaces)
                key = ""
                start = Int(i) + 2
            } else if i == text.count-1 && start < i { // append last properties that we traverse
                properties[key] = String(text[start...]).trimmingCharacters(in: .whitespaces)
                key = ""
            }
        }

        return DeviceModel(device: properties[keys.device.rawValue] ?? "Unknown",
                           osVersion: properties[keys.osVersion.rawValue] ?? "Unknown")
    }
}

extension VariantDescriptorParser {
    static let universalVariantText = "universal"
}
