//
//  XCPResultDecoding.swift
//  xcparse
//
//  Created by Alex Botkin on 8/13/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

class XCResultType : Codable {
    let name: String
    
    private enum CodingKeys : String, CodingKey {
        case name = "_name"
    }
}

class XCResultArrayValue<T: Codable> : Codable {
    let values: [T]
    
    private enum CodingKeys : String, CodingKey {
        case values = "_values"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        values = try container.decode(family: XCResultTypeFamily.self, forKey: .values)
    }
}

class XCResultValueType : Codable {
    let type: XCResultType
    let value: String
    
    private enum CodingKeys : String, CodingKey {
        case type = "_type"
        case value = "_value"
    }
    
    func getValue() -> Any? {
        if self.type.name == "Bool" {
            return Bool(self.value)
        } else if self.type.name == "Date" {
            let df = ISO8601DateFormatter()
            df.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            return df.date(from: self.value)
        } else if self.type.name == "Double" {
            return Double(self.value)
        } else if self.type.name == "Int" {
            return Int(self.value)
        } else {
            return self.value
        }
    }
}

public class XCResultNestedObjectType {
    public var name: String
    public var value: String
    public var children = [XCResultNestedObjectType]()
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
open class XCResultObject: Codable {
    public var type: XCResultObjectType
    public var properties: [String : Any] = [:]
    public var children = [XCResultObjectFirstNesting]()
    private enum CodingKeys : String, CodingKey {
        case type = "_type"
    }
    
    public func appendToProperties(propertyList: [String: Any]) {
        for (key, value) in propertyList {
            properties.updateValue(value, forKey: key)
        }
    }
    
    public func getNestedElementValue(dictElement: (key: String, value: Any)) -> String {
        var nestedVal = ""
        if dictElement.value is Int {
            let temp = dictElement.value as! Int
            nestedVal = String(temp)
        }
        else if dictElement.value is Date {
            let temp = dictElement.value as! Date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            nestedVal = formatter.string(from:temp)
        }
        else if dictElement.value is Bool {
            let temp = dictElement.value as! Bool
            nestedVal = String(temp)
        }
        else if dictElement.value is Double {
            let temp = dictElement.value as! Double
            nestedVal = String(temp)
        }
        else if dictElement.value is String {
            nestedVal = dictElement.value as! String
        }
        return nestedVal
    }
    
    public func generateObjectTree() {
        for element in self.properties {
            var val = ""
            val = getNestedElementValue(dictElement: element)
            var nestedItem = XCResultObjectFirstNesting(name: element.key, value: val)
            self.children.append(nestedItem)
            addFirstNestedElement(element: element, nestedItem: nestedItem)
        }
    }
    
    public func addFirstNestedElement(element: (key: String, value: Any), nestedItem: XCResultNestedObjectType) {
        if let nestedObject = element.value as? XCResultObject {
            for secondElement in nestedObject.properties {
                var nestedVal = ""
                nestedVal = getNestedElementValue(dictElement: secondElement)
                var secondNestedItem = XCResultObjectSecondNesting(name: secondElement.key, value: nestedVal)
                nestedItem.children.append(secondNestedItem)
                addSecondNestedElement(secondElement: secondElement, secondNestedItem: secondNestedItem)
            }
        }
        else if let nestedObjectList = element.value as? [XCResultObject] {
            for arrayElement in nestedObjectList {
                var nestedArrayItem = XCResultObjectSecondNesting(name: arrayElement.type.name, value: "")
                nestedItem.children.append(nestedArrayItem)
                for thirdElement in arrayElement.properties {
                    var secondNestedVal = ""
                    secondNestedVal = getNestedElementValue(dictElement: thirdElement)
                    var thirdNestedItem = XCResultObjectThirdNesting(name: thirdElement.key, value: secondNestedVal)
                    nestedArrayItem.children.append(thirdNestedItem)
                    addThirdNestedElement(thirdElement: thirdElement, thirdNestedItem: thirdNestedItem)
                }
            }
        }
    }
    public func addSecondNestedElement(secondElement: (key: String, value: Any), secondNestedItem: XCResultNestedObjectType) {
        if let secondNestedObject = secondElement.value as? XCResultObject {
            for thirdElement in secondNestedObject.properties {
                var secondNestedVal = ""
                secondNestedVal = getNestedElementValue(dictElement: thirdElement)
                var thirdNestedItem = XCResultObjectThirdNesting(name: thirdElement.key, value: secondNestedVal)
                secondNestedItem.children.append(thirdNestedItem)
                addThirdNestedElement(thirdElement: thirdElement, thirdNestedItem: thirdNestedItem)
            }
        }
        else if let secondNestedObjectList = secondElement.value as? [XCResultObject] {
            for arrayElement in secondNestedObjectList {
                var nestedArrayItem = XCResultObjectThirdNesting(name: arrayElement.type.name, value: "")
                secondNestedItem.children.append(nestedArrayItem)
                for thirdElement in arrayElement.properties {
                    var thirdNestedVal = ""
                    thirdNestedVal = getNestedElementValue(dictElement: thirdElement)
                    var thirdNestedItem = XCResultObjectThirdNesting(name: thirdElement.key, value: thirdNestedVal)
                    nestedArrayItem.children.append(thirdNestedItem)
                    addThirdNestedElement(thirdElement: thirdElement, thirdNestedItem: thirdNestedItem)
                }
            }
        }
    }
    
    public func addThirdNestedElement(thirdElement: (key: String, value: Any), thirdNestedItem: XCResultNestedObjectType) {
        if let fourthNestedObject = thirdElement.value as? XCResultObject {
            for fourthElement in fourthNestedObject.properties {
                var thirdNestedVal = ""
                thirdNestedVal = getNestedElementValue(dictElement: fourthElement)
                var fourthNestedItem = XCResultObjectFourthNesting(name:fourthElement.key, value: thirdNestedVal)
                thirdNestedItem.children.append(fourthNestedItem)
                addFourthNestedElement(fourthElement: fourthElement, fourthNestedItem: fourthNestedItem)
            }
        }
        else if let fourthNestedObjectList = thirdElement.value as? [XCResultObject] {
            for arrayElement in fourthNestedObjectList {
                var nestedArrayItem = XCResultObjectFourthNesting(name: arrayElement.type.name, value: "")
                thirdNestedItem.children.append(nestedArrayItem)
                for fourthElement in arrayElement.properties {
                    var fourthNestedVal = ""
                    fourthNestedVal = getNestedElementValue(dictElement: fourthElement)
                    var fourthNestedItem = XCResultObjectFourthNesting(name: fourthElement.key, value: fourthNestedVal)
                    nestedArrayItem.children.append(fourthNestedItem)
                    addFourthNestedElement(fourthElement: fourthElement, fourthNestedItem: fourthNestedItem)
                }
            }
        }
    }
    
    public func addFourthNestedElement(fourthElement: (key: String, value: Any), fourthNestedItem: XCResultNestedObjectType) {
        if let fifthNestedObject = fourthElement.value as? XCResultObject {
            for fifthElement in fifthNestedObject.properties {
                var fourthNestedVal = ""
                fourthNestedVal = getNestedElementValue(dictElement: fifthElement)
                var fifthNestedItem = XCResultObjectFifthNesting(name:fifthElement.key, value: fourthNestedVal)
                fourthNestedItem.children.append(fifthNestedItem)
                addFifthNestedElement(fifthElement: fifthElement, fifthNestedItem: fifthNestedItem)
            }
        }
        else if let fifthNestedObjectList = fourthElement.value as? [XCResultObject] {
            for arrayElement in fifthNestedObjectList {
                var nestedArrayItem = XCResultObjectFifthNesting(name: arrayElement.type.name, value: "")
                fourthNestedItem.children.append(nestedArrayItem)
                for fifthElement in arrayElement.properties {
                    var fifthNestedVal = ""
                    fifthNestedVal = getNestedElementValue(dictElement: fifthElement)
                    var fifthNestedItem = XCResultObjectFifthNesting(name: fifthElement.key, value: fifthNestedVal)
                    nestedArrayItem.children.append(fifthNestedItem)
                    addFifthNestedElement(fifthElement: fifthElement, fifthNestedItem: fifthNestedItem)
                }
            }
        }
    }
    
    public func addFifthNestedElement(fifthElement: (key: String, value: Any), fifthNestedItem: XCResultNestedObjectType) {
        if let sixthNestedObject = fifthElement.value as? XCResultObject {
            for sixthElement in sixthNestedObject.properties {
                var fifthNestedVal = ""
                fifthNestedVal = getNestedElementValue(dictElement: sixthElement)
                var sixthNestedItem = XCResultObjectSixthNesting(name:sixthElement.key, value: fifthNestedVal)
                fifthNestedItem.children.append(sixthNestedItem)
                addSixthNestedElement(sixthElement: sixthElement, sixthNestedItem: sixthNestedItem)
            }
        }
        else if let sixthNestedObjectList = fifthElement.value as? [XCResultObject] {
            for arrayElement in sixthNestedObjectList {
                var nestedArrayItem = XCResultObjectSixthNesting(name: arrayElement.type.name, value: "")
                fifthNestedItem.children.append(nestedArrayItem)
                for sixthElement in arrayElement.properties {
                    var sixthNestedVal = ""
                    sixthNestedVal = getNestedElementValue(dictElement: sixthElement)
                    var sixthNestedItem = XCResultObjectSixthNesting(name: sixthElement.key, value: sixthNestedVal)
                    nestedArrayItem.children.append(sixthNestedItem)
                    addSixthNestedElement(sixthElement: sixthElement, sixthNestedItem: sixthNestedItem)
                }
            }
        }
    }
    
    public func addSixthNestedElement(sixthElement: (key: String, value: Any), sixthNestedItem: XCResultNestedObjectType) {
        if let seventhNestedObject = sixthElement.value as? XCResultObject {
            for seventhElement in seventhNestedObject.properties {
                var sixthNestedVal = ""
                sixthNestedVal = getNestedElementValue(dictElement: seventhElement)
                var seventhNestedItem = XCResultObjectSeventhNesting(name:seventhElement.key, value: sixthNestedVal)
                sixthNestedItem.children.append(seventhNestedItem)
                addSeventhNestedElement(seventhElement: seventhElement, seventhNestedItem: seventhNestedItem)
            }
        }
        else if let seventhNestedObjectList = sixthElement.value as? [XCResultObject] {
            for arrayElement in seventhNestedObjectList {
                var nestedArrayItem = XCResultObjectSeventhNesting(name: arrayElement.type.name, value: "")
                sixthNestedItem.children.append(nestedArrayItem)
                for seventhElement in arrayElement.properties {
                    var seventhNestedVal = ""
                    seventhNestedVal = getNestedElementValue(dictElement: seventhElement)
                    var seventhNestedItem = XCResultObjectSeventhNesting(name: seventhElement.key, value: seventhNestedVal)
                    nestedArrayItem.children.append(seventhNestedItem)
                    addSeventhNestedElement(seventhElement: seventhElement, seventhNestedItem: seventhNestedItem)
                }
            }
        }
    }
    
    public func addSeventhNestedElement(seventhElement: (key: String, value: Any), seventhNestedItem: XCResultNestedObjectType) {
        if let eighthNestedObject = seventhElement.value as? XCResultObject {
            for eighthElement in eighthNestedObject.properties {
                var seventhNestedVal = ""
                seventhNestedVal = getNestedElementValue(dictElement: eighthElement)
                var eighthNestedItem = XCResultObjectEighthNesting(name:eighthElement.key, value: seventhNestedVal)
                seventhNestedItem.children.append(eighthNestedItem)
                addEighthNestedElement(eighthElement: eighthElement, eighthNestedItem: eighthNestedItem)
            }
        }
        else if let eighthNestedObjectList = seventhElement.value as? [XCResultObject] {
            for arrayElement in eighthNestedObjectList {
                var nestedArrayItem = XCResultObjectEighthNesting(name: arrayElement.type.name, value: "")
                seventhNestedItem.children.append(nestedArrayItem)
                for eighthElement in arrayElement.properties {
                    var eighthNestedVal = ""
                    eighthNestedVal = getNestedElementValue(dictElement: eighthElement)
                    var eighthNestedItem = XCResultObjectEighthNesting(name: eighthElement.key, value: eighthNestedVal)
                    nestedArrayItem.children.append(eighthNestedItem)
                    addEighthNestedElement(eighthElement: eighthElement, eighthNestedItem: eighthNestedItem)
                }
            }
        }
    }
    
    public func addEighthNestedElement(eighthElement: (key: String, value: Any), eighthNestedItem: XCResultNestedObjectType) {
        if let ninthNestedObject = eighthElement.value as? XCResultObject {
            for ninthElement in ninthNestedObject.properties {
                var eighthNestedVal = ""
                eighthNestedVal = getNestedElementValue(dictElement: ninthElement)
                var ninthNestedItem = XCResultObjectNinthNesting(name:ninthElement.key, value: eighthNestedVal)
                eighthNestedItem.children.append(ninthNestedItem)
                addNinthNestedElement(ninthElement: ninthElement, ninthNestedItem: ninthNestedItem)
            }
        }
        else if let ninthNestedObjectList = eighthElement.value as? [XCResultObject] {
            for arrayElement in ninthNestedObjectList {
                var nestedArrayItem = XCResultObjectNinthNesting(name: arrayElement.type.name, value: "")
                eighthNestedItem.children.append(nestedArrayItem)
                for ninthElement in arrayElement.properties {
                    var ninthNestedVal = ""
                    ninthNestedVal = getNestedElementValue(dictElement: ninthElement)
                    var ninthNestedItem = XCResultObjectNinthNesting(name: ninthElement.key, value: ninthNestedVal)
                    nestedArrayItem.children.append(ninthNestedItem)
                    addNinthNestedElement(ninthElement: ninthElement, ninthNestedItem: ninthNestedItem)
                }
            }
        }
    }
    
    public func addNinthNestedElement(ninthElement: (key: String, value: Any), ninthNestedItem: XCResultNestedObjectType) {
        if let tenthNestedObject = ninthElement.value as? XCResultObject {
            for tenthElement in tenthNestedObject.properties {
                var ninthNestedVal = ""
                ninthNestedVal = getNestedElementValue(dictElement: tenthElement)
                var tenthNestedItem = XCResultObjectTenthNesting(name:tenthElement.key, value: ninthNestedVal)
                ninthNestedItem.children.append(tenthNestedItem)
                addTenthNestedElement(tenthElement: tenthElement, tenthNestedItem: tenthNestedItem)
            }
        }
        else if let tenthNestedObjectList = ninthElement.value as? [XCResultObject] {
            for arrayElement in tenthNestedObjectList {
                var nestedArrayItem = XCResultObjectTenthNesting(name: arrayElement.type.name, value: "")
                ninthNestedItem.children.append(nestedArrayItem)
                for tenthElement in arrayElement.properties {
                    var tenthNestedVal = ""
                    tenthNestedVal = getNestedElementValue(dictElement: tenthElement)
                    var tenthNestedItem = XCResultObjectTenthNesting(name: tenthElement.key, value: tenthNestedVal)
                    nestedArrayItem.children.append(tenthNestedItem)
                    addTenthNestedElement(tenthElement: tenthElement, tenthNestedItem: tenthNestedItem)
                }
            }
        }
    }
    
    public func addTenthNestedElement(tenthElement: (key: String, value: Any), tenthNestedItem: XCResultNestedObjectType) {
        if let eleventhNestedObject = tenthElement.value as? XCResultObject {
            for eleventhElement in eleventhNestedObject.properties {
                var tenthNestedVal = ""
                tenthNestedVal = getNestedElementValue(dictElement: eleventhElement)
                var eleventhNestedItem = XCResultObjectEleventhNesting(name:eleventhElement.key, value: tenthNestedVal)
                tenthNestedItem.children.append(eleventhNestedItem)
            }
        }
        else if let eleventhNestedObjectList = tenthElement.value as? [XCResultObject] {
            for arrayElement in eleventhNestedObjectList {
                var nestedArrayItem = XCResultObjectEleventhNesting(name: arrayElement.type.name, value: "")
                tenthNestedItem.children.append(nestedArrayItem)
                for eleventhElement in arrayElement.properties {
                    var eleventhNestedVal = ""
                    eleventhNestedVal = getNestedElementValue(dictElement: eleventhElement)
                    var eleventhNestedItem = XCResultObjectEleventhNesting(name: eleventhElement.key, value: eleventhNestedVal)
                    nestedArrayItem.children.append(eleventhNestedItem)
                }
            }
        }
    }
}

public class XCResultObjectFirstNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectSecondNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectThirdNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectFourthNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectFifthNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectSixthNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectSeventhNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectEighthNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectNinthNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectTenthNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectEleventhNesting: XCResultNestedObjectType {
    public override init(name: String, value: String) {
        super.init(name: name,value: value)
    }
}

public class XCResultObjectType: Codable {
    public let name: String
    public let supertype: XCResultObjectType?
    
    private enum CodingKeys : String, CodingKey {
        case name = "_name"
        case supertype = "_supertype"
    }
    
    func getType() -> AnyObject.Type {
        if let type = XCResultTypeFamily(rawValue: self.name) {
            return type.getType()
        } else if let parentType = supertype {
            return parentType.getType()
        } else {
            return XCResultObjectType.self
        }
    }
}

// MARK: -
// MARK: Heterogenous Decoding

// Note: This part largely copies the homework of Kewin Remeczki's article on Swift 4 Decodable
//       and heterogenous collections. Likely need to re-examine & refactor parts here to our use case
// See: https://medium.com/@kewindannerfjordremeczki/swift-4-0-decodable-heterogeneous-collections-ecc0e6b468cf

/// These are the generic methods

/// To support a new class family, create an enum that conforms to this protocol and contains the different types.
protocol ClassFamily: Decodable {
    /// The discriminator key.
    static var discriminator: Discriminator { get }
    
    /// Returns the class type of the object coresponding to the value.
    func getType() -> AnyObject.Type
}

/// Discriminator key enum used to retrieve discriminator fields in JSON payloads.
enum Discriminator: String, CodingKey {
    case type = "_type"
}

/// An enum that assist in determining what XCResultObject type we need to parse as
enum XCResultTypeFamily: String, ClassFamily {
    case ActionAbstractTestSummary
    case ActionDeviceRecord
    case ActionPlatformRecord
    case ActionRecord
    case ActionResult
    case ActionRunDestinationRecord
    case ActionSDKRecord
    case ActionTestActivitySummary
    case ActionTestAttachment
    case ActionTestFailureSummary
    case ActionTestMetadata
    case ActionTestPerformanceMetricSummary
    case ActionTestPlanRunSummaries
    case ActionTestPlanRunSummary
    case ActionTestSummary
    case ActionTestSummaryGroup
    case ActionTestSummaryIdentifiableObject
    case ActionTestableSummary
    case ActionsInvocationMetadata
    case ActionsInvocationRecord
    case ActivityLogCommandInvocationSection
    case ActivityLogMajorSection
    case ActivityLogMessage
    case ActivityLogMessageAnnotation
    case ActivityLogSection
    case ActivityLogTargetBuildSection
    case ActivityLogUnitTestSection
    case ArchiveInfo
    case Array
    case Bool
    case CodeCoverageInfo
    case Date
    case DocumentLocation
    case Double
    case EntityIdentifier
    case Int
    case IssueSummary
    case ObjectID
    case Reference
    case ResultIssueSummaries
    case ResultMetrics
    case SortedKeyValueArray
    case SortedKeyValueArrayPair
    case String
    case TestFailureIssueSummary
    case TypeDefinition
    
    static var discriminator: Discriminator = .type
    
    func getType() -> AnyObject.Type {
        switch self {
        case .ActionAbstractTestSummary:
            return XCParseCore.ActionAbstractTestSummary.self
        case .ActionDeviceRecord:
            return XCParseCore.ActionDeviceRecord.self
        case .ActionPlatformRecord:
            return XCParseCore.ActionPlatformRecord.self
        case .ActionRecord:
            return XCParseCore.ActionRecord.self
        case .ActionResult:
            return XCParseCore.ActionResult.self
        case .ActionRunDestinationRecord:
            return XCParseCore.ActionRunDestinationRecord.self
        case .ActionSDKRecord:
            return XCParseCore.ActionSDKRecord.self
        case .ActionTestActivitySummary:
            return XCParseCore.ActionTestActivitySummary.self
        case .ActionTestAttachment:
            return XCParseCore.ActionTestAttachment.self
        case .ActionTestFailureSummary:
            return XCParseCore.ActionTestActivitySummary.self
        case .ActionTestMetadata:
            return XCParseCore.ActionTestMetadata.self
        case .ActionTestPerformanceMetricSummary:
            return XCParseCore.ActionTestPerformanceMetricSummary.self
        case .ActionTestPlanRunSummaries:
            return XCParseCore.ActionTestPlanRunSummaries.self
        case .ActionTestPlanRunSummary:
            return XCParseCore.ActionTestPlanRunSummary.self
        case .ActionTestSummary:
            return XCParseCore.ActionTestSummary.self
        case .ActionTestSummaryGroup:
            return XCParseCore.ActionTestSummaryGroup.self
        case .ActionTestSummaryIdentifiableObject:
            return XCParseCore.ActionTestSummaryIdentifiableObject.self
        case .ActionTestableSummary:
            return XCParseCore.ActionTestableSummary.self
        case .ActionsInvocationMetadata:
            return XCParseCore.ActionsInvocationMetadata.self
        case .ActionsInvocationRecord:
            return XCParseCore.ActionsInvocationRecord.self
        case .ActivityLogCommandInvocationSection:
            return XCParseCore.ActivityLogCommandInvocationSection.self
        case .ActivityLogMajorSection:
            return XCParseCore.ActivityLogMajorSection.self
        case .ActivityLogMessage:
            return XCParseCore.ActivityLogMessage.self
        case .ActivityLogMessageAnnotation:
            return XCParseCore.ActivityLogMessageAnnotation.self
        case .ActivityLogSection:
            return XCParseCore.ActivityLogSection.self
        case .ActivityLogTargetBuildSection:
            return XCParseCore.ActivityLogTargetBuildSection.self
        case .ActivityLogUnitTestSection:
            return XCParseCore.ActivityLogUnitTestSection.self
        case .ArchiveInfo:
            return XCParseCore.ArchiveInfo.self
        case .Array:
            return XCParseCore.XCResultArrayValue<XCResultObject>.self
        case .Bool:
            return XCParseCore.XCResultValueType.self
        case .CodeCoverageInfo:
            return XCParseCore.CodeCoverageInfo.self
        case .Date:
            return XCParseCore.XCResultValueType.self
        case .DocumentLocation:
            return XCParseCore.DocumentLocation.self
        case .Double:
            return XCParseCore.XCResultValueType.self
        case .EntityIdentifier:
            return XCParseCore.EntityIdentifier.self
        case .Int:
            return XCParseCore.XCResultValueType.self
        case .IssueSummary:
            return XCParseCore.IssueSummary.self
        case .ObjectID:
            return XCParseCore.ObjectID.self
        case .Reference:
            return XCParseCore.Reference.self
        case .ResultIssueSummaries:
            return XCParseCore.ResultIssueSummaries.self
        case .ResultMetrics:
            return XCParseCore.ResultMetrics.self
        case .SortedKeyValueArray:
            return AnyObject.self
        case .SortedKeyValueArrayPair:
            return AnyObject.self
        case .String:
            return XCParseCore.XCResultValueType.self
        case .TestFailureIssueSummary:
            return XCParseCore.TestFailureIssueSummary.self
        case .TypeDefinition:
            return XCParseCore.TypeDefinition.self
        }
    }
}

extension KeyedDecodingContainer {
    func decodeXCResultType<T: Codable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T {
        let resultValueType = try self.decode(XCResultValueType.self, forKey: key)
        return resultValueType.getValue() as! T
    }
    
    func decodeXCResultTypeIfPresent<T: Codable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> T? {
        let resultValueType = try self.decodeIfPresent(XCResultValueType.self, forKey: key)
        return resultValueType?.getValue() as! T?
    }
    
    func decodeXCResultObject<T: Codable>(forKey key: K) throws -> T {
        let resultObject = try self.decode(XCResultObject.self, forKey: key)
        if let type = resultObject.type.getType() as? T.Type {
            return try self.decode(type.self, forKey: key)
        } else {
            return try self.decode(T.self, forKey: key)
        }
    }
    
    func decodeXCResultObjectIfPresent<T: Codable>(forKey key: K) throws -> T? {
        let resultObject = try self.decodeIfPresent(XCResultObject.self, forKey: key)
        if let type = resultObject?.type.getType() as? T.Type {
            return try self.decode(type.self, forKey: key)
        } else {
            return nil
        }
    }
    
    /// Decode a heterogeneous list of objects for a given family.
    /// - Parameters:
    ///     - family: The ClassFamily enum for the type family.
    ///     - key: The CodingKey to look up the list in the current container.
    /// - Returns: The resulting list of heterogeneousType elements.
    func decode<T : Codable, U : ClassFamily>(family: U.Type, forKey key: K) throws -> [T] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        var list = [T]()
        var tmpContainer = container
        while !container.isAtEnd {
            let resultObj = try container.decode(XCResultObject.self)
            if let type = resultObj.type.getType() as? T.Type {
                list.append(try tmpContainer.decode(type))
            }
        }
        return list
    }
}

extension JSONDecoder {
    /// Decode a heterogeneous list of objects.
    /// - Parameters:
    ///     - family: The ClassFamily enum type to decode with.
    ///     - data: The data to decode.
    /// - Returns: The list of decoded objects.
    func decode<T: ClassFamily, U: Decodable>(family: T.Type, from data: Data) throws -> [U] {
        return try self.decode([ClassWrapper<T, U>].self, from: data).compactMap { $0.object }
    }
    
    private class ClassWrapper<T: ClassFamily, U: Decodable>: Decodable {
        /// The family enum containing the class information.
        let family: T
        /// The decoded object. Can be any subclass of U.
        let object: U?
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Discriminator.self)
            // Decode the family with the discriminator.
            family = try container.decode(T.self, forKey: T.discriminator)
            // Decode the object by initialising the corresponding type.
            if let type = family.getType() as? U.Type {
                object = try type.init(from: decoder)
            } else {
                object = nil
            }
        }
    }
}

