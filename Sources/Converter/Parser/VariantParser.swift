//
//  VariantParser.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/29/21.
//

import Foundation

final class VariantParser: ModelParser<String> {
    override func parseText() {
        guard !text.isEmpty else { return }
        result = text
    }
}
