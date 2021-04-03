//
//  Units.swift
//  AppThinningConverter
//
//  Created by Vido Shaweddy on 3/30/21.
//

import Foundation

public struct MemorySize {
    enum Unit: String, Codable {
        case bytes = "B"
        case kilobytes = "KB"
        case megabytes = "MB"
        case gigabytes = "GB"
    }

    public var bytes: Int64 {
        get {
            return Int64(Double(kilobytes) * 1_024)
        }
    }

    public var kilobytes: Double

    public var megabytes: Double {
        return kilobytes / 1_024
    }

    public var gigabytes: Double {
        return megabytes / 1_024
    }

    public init(bytes: Int64) {
        self.kilobytes = Double(bytes) / 1_024
    }

    public init(bytes: Double) {
        self.kilobytes = bytes / 1_024
    }

    public init(kilobytes: Double) {
        self.kilobytes = kilobytes
    }

    public init(megabytes: Double) {
        self.kilobytes = megabytes * 1_024
    }

    public init(gigabytes: Double) {
        self.kilobytes = gigabytes * 1_024 * 1_024
    }

    public init?(text: String) {
        self.kilobytes = 0
        if let value = parseFrom(text: text) {
            self.kilobytes = value.kilobytes
        } else {
            return nil
        }
    }
}

extension MemorySize {
    var displayString: String {
        switch bytes {
        case 0..<1_024:
            return "\(bytes) bytes"
        case 1_024..<(1_024 * 1_024):
            return "\(String(format: "%.2f", kilobytes)) kb"
        case 1_024..<(1_024 * 1_024 * 1_024):
            return "\(String(format: "%.2f", megabytes)) mb"
        case (1_024 * 1_024 * 1_024)...Int64.max:
            return "\(String(format: "%.2f", gigabytes)) gb"
        default:
            return "\(bytes) bytes"
        }
    }

    func parseFrom(text: String) -> MemorySize? {
        let textToMemoryUnit: [String: MemorySize.Unit] =
            [
                "b": .bytes,
                "byte": .bytes,
                "bytes": .bytes,
                "kb": .kilobytes,
                "kilobyte": .kilobytes,
                "kilobytes": .kilobytes,
                "mb": .megabytes,
                "megabyte": .megabytes,
                "megabytes": .megabytes,
                "gb": .gigabytes,
                "gigabyte": .gigabytes,
                "gigabytes": .gigabytes,
            ]

        guard let unit = textToMemoryUnit[parseUnits(text: text)],
              let size = parseSize(text: text)
        else { return nil }

        switch unit {
        case .bytes:
            return MemorySize(bytes: size)
        case .kilobytes:
            return MemorySize(kilobytes: size)
        case .megabytes:
            return MemorySize(megabytes: size)
        case .gigabytes:
            return MemorySize(gigabytes: size)
        }
    }

    func parseUnits(text: String) -> String {
        if text.lowercased() == Self.zeroSize { return "kb" }
        return parseUnits(text: Array(text))
    }

    func parseUnits(text: [Character]) -> String {
        var unitString = ""

        for character in text where character.isLetter {
            if character != "." && character != "," {
                unitString.append(character.lowercased())
            }
        }

        return unitString
    }

    func parseSize(text: String) -> Double? {
        if text.lowercased() == Self.zeroSize { return 0 }
        return parseSize(text: Array(text))
    }

    func parseSize(text: [Character]) -> Double? {
        var sizeString = ""

        for character in text {
            if character.isNumber || character == "." || character == "," {
                sizeString.append(character)
            }
        }

        return Double(sizeString)
    }
}

extension MemorySize: Comparable {
    public static func < (lhs: MemorySize, rhs: MemorySize) -> Bool {
        return lhs.kilobytes < rhs.kilobytes
    }

    public static func > (lhs: MemorySize, rhs: MemorySize) -> Bool {
        return lhs.kilobytes > rhs.kilobytes
    }

    public static func == (lhs: MemorySize, rhs: MemorySize) -> Bool {
        return lhs.kilobytes == rhs.kilobytes
    }
}

public extension MemorySize {
    static let zeroSize = "zero kb"
}
