//
//  DeviceModel.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/25/21.
//

import Foundation

struct DeviceModel: Codable {
    let device: String
    let osVersion: String

    enum CodingKeys: String, CodingKey, CaseIterable {
        case device
        case osVersion = "os-version"
    }
}
