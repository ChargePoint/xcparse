//
//  ResultFactory.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/29/21.
//

import Foundation

final class ResultFactory {
    /// A factory class for parsing text
    ///
    /// Use this method to get the result for each parser.
    /// - Warning: Returns optional any type. if the parser is unable to find the data it will returns nil.
    /// - Parameter:
    ///             - text: the text you want to parse
    ///             - modelType: the
    /// - Returns: The result for each parser in any data type.
    func parse(from text: String, using parser: VariantModel.ParsingKeys) -> Any? {
        let result: Any?
        switch parser {
        case .variant:
            result = VariantParser(text: text).result
        case .supportedVariantDescriptors:
            result = VariantDescriptorParser(text: text).result
        case .appOnDemandResourcesSize:
            result = AppSizeParser(text: text).result
        case .appSize:
            result = AppSizeParser(text: text).result
        case .onDemandResourcesSize:
            result = AppSizeParser(text: text).result
        }
        return result
    }
}
