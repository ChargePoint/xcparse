//
//  ResultFactory.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/29/21.
//

import Foundation

class ResultFactory {
    func parse(from text: String, to modelType: VariantModel.CodingKeys) -> Any? {
        let result: Any?
        switch modelType {
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
