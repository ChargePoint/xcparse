//
//  AppOnDemandModel.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/25/21.
//

import Foundation

protocol ModelSize: Codable {
    var compressed: String { get set }
    var uncompressed: String { get set }
}

class AppSizeModel: ModelSize {
    var compressed: String
    var uncompressed: String

    enum CodingKeys: String, CodingKey, CaseIterable {
        case compressed, uncompressed
    }

    init(compressed: String, uncompressed: String) {
        self.compressed = compressed
        self.uncompressed = uncompressed
    }
}
