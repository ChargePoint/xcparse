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


public final class ReportConverter {
    public static func parse(text: String) -> [VariantModel] {
        let splitterID = UUID().uuidString
        let preprocessedData = text.replacingOccurrences(of: "\n\n", with: "\n\(splitterID)\n")
        let datas = preprocessedData.split(separator: "\n")
        let resultFactory = ResultFactory()

        var variants = [VariantModel]()
        var dictionary = [String: Any]()

        for data in datas {
            typealias keys = VariantModel.ParsingKeys
            if data.contains(splitterID) && dictionary[keys.variant.rawValue] != nil {
                let variant = (dictionary[keys.variant.rawValue] as? String) ?? ""
                let supportedVariantDescriptors = (dictionary[keys.supportedVariantDescriptors.rawValue] as? [DeviceModel]) ?? [DeviceModel]()
                let appOnDemandResourcesSize = (dictionary[keys.appOnDemandResourcesSize.rawValue] as? AppSizeModel) ?? AppSizeModel()
                let appSize = (dictionary[keys.appSize.rawValue] as? AppSizeModel) ?? AppSizeModel()
                let onDemandResourcesSize = (dictionary[keys.onDemandResourcesSize.rawValue] as? AppSizeModel) ?? AppSizeModel()

                let model = VariantModel(variant: variant,
                                         supportedVariantDescriptors: supportedVariantDescriptors,
                                         appOnDemandResourcesSize: appOnDemandResourcesSize,
                                         appSize: appSize,
                                         onDemandResourcesSize: onDemandResourcesSize)
                variants.append(model)
                dictionary = [String: Any]()
            }

            let properties = VariantModel.ParsingKeys.allCases

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

    public static func writeJSON(from text: String, to: String) {
        let variants = self.parse(text: text)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let data = try encoder.encode(variants)
            if let json = String(data: data, encoding: String.Encoding.utf8) {
                FileController.writeFile(data: json, url: to)
            } else {
                print("JSON Empty")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func flagVariants(_  variants: [VariantModel], limit: MemorySize = MemorySize(megabytes: 10)) -> [String] {
        var result = [String]()

        for variant in variants {
            let appSizeUncompressed = MemorySize(megabytes: variant.appSize.uncompressed.value)
            let appOnDemandSizeUncompressed = MemorySize(megabytes: variant.appOnDemandResourcesSize.uncompressed.value)

            if appSizeUncompressed > limit || appOnDemandSizeUncompressed > limit {
                result.append(variant.variant)
            }
        }

        return result
    }
}
