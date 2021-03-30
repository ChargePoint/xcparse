//
//  ReportParser.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/25/21.
//

import Foundation

protocol Parser {
    associatedtype ModelType
    var text: String { get set }
    var result: ModelType? { get set }
    func parseText()
}

class ModelParser<E>: Parser {
    var text: String
    var result: E?

    init(text: String) {
        self.text = text
        parseText()
    }

    func parseText() {}
}


public final class ReportParser {
    func parse(text: String) -> [VariantModel] {
        // insert unique splitter string so we know if we have new variant
        let splitterID = UUID().uuidString
        let preprocessedData = text.replacingOccurrences(of: "\n\n", with: "\n\(splitterID)\n")

        // split the string based on the break
        let datas = preprocessedData.split(separator: "\n")
        let resultFactory = ResultFactory()

        var variants = [VariantModel]()
        // collect all the properties that a variant need in the dictionary
        var dictionary = [String: Any]()

        for data in datas {
            typealias keys = VariantModel.CodingKeys
            if data.contains(splitterID) && dictionary[keys.variant.rawValue] != nil {
                let variant = (dictionary[keys.variant.rawValue] as? String) ?? ""
                let supportedVariantDescriptors = (dictionary[keys.supportedVariantDescriptors.rawValue] as? [DeviceModel]) ?? [DeviceModel]()
                let appOnDemandResourcesSize = (dictionary[keys.appOnDemandResourcesSize.rawValue] as? AppSizeModel) ?? AppSizeModel(compressed: "Unknown",
                                                                                                                                     uncompressed: "Unknown")
                let appSize = (dictionary[keys.appSize.rawValue] as? AppSizeModel) ?? AppSizeModel(compressed: "Unknown",
                                                                                                   uncompressed: "Unknown")
                let onDemandResourcesSize = (dictionary[keys.onDemandResourcesSize.rawValue] as? AppSizeModel) ?? AppSizeModel(compressed: "Unknown",
                                                                                                                               uncompressed: "Unknown")

                let model = VariantModel(variant: variant,
                                         supportedVariantDescriptors: supportedVariantDescriptors,
                                         appOnDemandResourcesSize: appOnDemandResourcesSize,
                                         appSize: appSize,
                                         onDemandResourcesSize: onDemandResourcesSize)
                variants.append(model)

                // reset dictionary
                dictionary = [String: Any]()
            }

            let properties = VariantModel.CodingKeys.allCases

            for property in properties {
                let key = property.rawValue
                if data.contains(key) {
                    let parseableText = String(data).replacingOccurrences(of: key,
                                                                          with: "")
                    dictionary[key] = resultFactory.parse(from: parseableText,
                                                          to: property)
                }
            }
        }

        return variants
    }

    func writeJSON(from text: String) {
        let variants = self.parse(text: text)
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(variants)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        print(json)
    }

    func flagVariants(_  variants: [VariantModel], limit: Units = Units(megabytes: 10)) -> [String] {
        var result = [String]()

        for variant in variants {
            guard let appSizeUncompressed = Units(text: variant.appSize.uncompressed),
                  let appOnDemandSizeUncompressed = Units(text: variant.appOnDemandResourcesSize.uncompressed)
            else { continue }

            if appSizeUncompressed > limit || appOnDemandSizeUncompressed > limit {
                result.append(variant.variant)
            }
        }

        return result
    }
}
