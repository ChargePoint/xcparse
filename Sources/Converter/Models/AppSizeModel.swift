//
//  AppOnDemandModel.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/25/21.
//

import Foundation

protocol ModelSize: Codable, Equatable {
    var compressed: SizeModel { get set }
    var uncompressed: SizeModel { get set }
}

class AppSizeModel: ModelSize {
    var compressed: SizeModel
    var uncompressed: SizeModel

    enum CodingKeys: String, CodingKey, CaseIterable {
        case compressed, uncompressed
    }

    // MARK: - Constructor
    
    init(compressed: SizeModel = SizeModel.placeholder(), uncompressed: SizeModel = SizeModel.placeholder()) {
        self.compressed = compressed
        self.uncompressed = uncompressed
    }

    static func == (lhs: AppSizeModel, rhs: AppSizeModel) -> Bool {
        return lhs.compressed == rhs.compressed && lhs.uncompressed == rhs.uncompressed
    }
}

struct SizeModel: Codable, Equatable {
    let rawValue: String
    let value: Double
    let unit: MemorySize.Unit
}

private extension SizeModel {
    static func placeholder() -> SizeModel {
        return SizeModel(rawValue: "Unknown", value: 0, unit: .bytes)
    }
}
