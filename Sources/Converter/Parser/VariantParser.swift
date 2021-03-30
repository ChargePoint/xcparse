//
//  VariantParser.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/29/21.
//

import Foundation

class VariantParser: ModelParser<String> {
    override func parseText() {
        guard !text.isEmpty else { return }
        result = text.replacingOccurrences(of: "Variant: ", with: "")
    }
}
