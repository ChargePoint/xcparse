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

/// The super class for all the parser
class ModelParser<E>: Parser {
    var text: String
    var result: E?

    // MARK: - Constructor

    init(text: String) {
        self.text = text
        parseText()
    }

    func parseText() {}
}

/// The main class that convert the report to JSON
public final class ReportConverter {
    /// Use this method to parse a text to list of variant
    ///             - text: the text you want to parse
    /// - Returns: List of variant
    public static func parse(text: String) -> [VariantModel] {
        // Add splitter id so that we know the boundary between each variant
        let splitterID = UUID().uuidString
        let preprocessedData = text.replacingOccurrences(of: "\n\n", with: "\n\(splitterID)\n")

        // split it to multiple array so we can easily iterate it
        let datas = preprocessedData.split(separator: "\n")
        let resultFactory = ResultFactory()

        var variants = [VariantModel]()
        // save the properties and value for each variant
        var dictionary = [String: Any]()

        for data in datas {
            typealias keys = VariantModel.ParsingKeys

            // if we finished parsing the variant we add it to the variants array
            // this is to avoid adding the header / title of the report to our result
            if data.contains(splitterID) && dictionary[keys.variant.rawValue] != nil {
                let variant = (dictionary[keys.variant.rawValue] as? String) ?? ""
                let supportedVariantDescriptors = (dictionary[keys.supportedVariantDescriptors.rawValue] as? [DeviceModel]) ?? [DeviceModel]()
                let appOnDemandResourcesSize = (dictionary[keys.appOnDemandResourcesSize.rawValue] as? AppSizeModel) ?? AppSizeModel()
                let appSize = (dictionary[keys.appSize.rawValue] as? AppSizeModel) ?? AppSizeModel()
                let onDemandResourcesSize = (dictionary[keys.onDemandResourcesSize.rawValue] as? AppSizeModel) ?? AppSizeModel()

                // initialize variant model from all the parser result
                let model = VariantModel(variant: variant,
                                         supportedVariantDescriptors: supportedVariantDescriptors,
                                         appOnDemandResourcesSize: appOnDemandResourcesSize,
                                         appSize: appSize,
                                         onDemandResourcesSize: onDemandResourcesSize)
                variants.append(model)

                // reset all the properties
                dictionary = [String: Any]()
            }

            // the keyword that triggers the parser
            let properties = VariantModel.ParsingKeys.allCases

            for property in properties {
                let key = property.rawValue
                if data.contains(key) {
                    // clean the key from the text
                    // i.e. "Variant: ChargePointAppClip-354363463-...." remove the "Variant: " so we have a clean text that we can parse ("ChargePointAppClip-354363463-....")
                    // i.e. "Supported variant descriptors: [device: iPhone10,3, os-version:14.0], ..." will pass only the "[device: iPhone10,3, os-version:14.0], ..." to the parser
                    let parseableText = String(data).replacingOccurrences(of: key,
                                                                          with: "")
                    dictionary[key] = resultFactory.parse(from: parseableText,
                                                          using: property)
                }
            }
        }

        return variants
    }

    /// write the parsing result to json filer.
    /// - Parameter:
    ///             - text: the text you want to parse.
    ///             - to: the output url directory.
    ///             - outputName: the output file name.
    public static func writeJSON(from text: String, to directoryURL: String, outputName: String = "ConverterResult") {
        let variants = self.parse(text: text)
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
            let data = try encoder.encode(variants)
            if let json = String(data: data, encoding: String.Encoding.utf8) {
                FileController.writeFile(data: json, url: directoryURL, outputName)
            } else {
                print("JSON Empty")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    /// Report all the variant that are over the size limit.
    ///             - variants: list of variant that we want to analyze
    ///             - limit: the memory size limit
    /// - Returns: The list of variant that are over the limit
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
