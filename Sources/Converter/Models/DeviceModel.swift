//
//  DeviceModel.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/25/21.
//

import Foundation

struct DeviceModel: Codable, Equatable {
    let device: String
    let osVersion: String

    enum ParsingKeys: String, CaseIterable {
        case device
        case osVersion = "os-version"
    }

    enum CodingKeys: String, CodingKey {
        case device, osVersion
    }
}
