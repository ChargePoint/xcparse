//
//  VariantModel.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/25/21.
//

import Foundation

public struct VariantModel: Codable, Equatable {
    let variant: String
    let supportedVariantDescriptors: [DeviceModel]
    let appOnDemandResourcesSize: AppSizeModel
    let appSize: AppSizeModel
    let onDemandResourcesSize: AppSizeModel

    enum ParsingKeys: String, CaseIterable {
        case variant = "Variant: "
        case supportedVariantDescriptors = "Supported variant descriptors: "
        case appOnDemandResourcesSize = "App + On Demand Resources size: "
        case appSize = "App size: "
        case onDemandResourcesSize = "On Demand Resources size: "
    }

    enum CodingKeys: String, CodingKey {
        case variant, supportedVariantDescriptors, appOnDemandResourcesSize, appSize, onDemandResourcesSize
    }
}
