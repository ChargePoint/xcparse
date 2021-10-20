//
//  String+ASCII.swift
//  
//
//  Created by Alexander Botkin on 7/5/20.
//

import Foundation

public extension String {
    func lossyASCIIString() -> String? {
        let string = self.precomposedStringWithCanonicalMapping
        guard let lossyASCIIData = string.data(using: .ascii, allowLossyConversion: true) else {
            return nil
        }
        guard let lossyASCIIString = String(data: lossyASCIIData, encoding: .ascii) else {
            return nil
        }
        return lossyASCIIString
    }
}
