//
//  CPTJSONAdapter.swift
//  xcparse
//
//  Created by Alex Botkin on 8/1/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import Mantle


@objc public class CPTJSONAdapter : MTLJSONAdapter {
    
    @objc static public func ActionDeviceRecordJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: ActionDeviceRecord.self);
    }
    
    @objc static public func ActionPlatformRecordJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: ActionPlatformRecord.self);
    }
    
    @objc static public func ActionRecordJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: ActionRecord.self);
    }
    
    @objc static public func ActionResultJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: ActionResult.self);
    }
    
    @objc static public func ActionRunDestinationRecordJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionRunDestinationRecord.self);
    }
    
    @objc static public func ActionSDKRecordJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionSDKRecord.self);
    }
    
    @objc static public func ActionTestPlanRunSummaryJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionTestPlanRunSummary.self);
    }
    
    @objc static public func ActionTestableSummaryJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionTestableSummary.self);
    }
    
    @objc static public func ActionTestActivitySummaryJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionTestActivitySummary.self);
    }
    
    @objc static public func ActionTestAttachmentJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionTestAttachment.self);
    }
    
    @objc static public func ActionTestPerformanceMetricSummaryJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionTestPerformanceMetricSummary.self);
    }
    
    @objc static public func ActionTestSummaryJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionTestSummary.self);
    }
    
    @objc static public func ActionTestSummaryIdentifiableObjectJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionTestSummaryIdentifiableObject.self);
    }
    
    @objc static public func ActionTestFailureSummaryJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionTestFailureSummary.self);
    }
    
    @objc static public func ActionsInvocationRecordJSONTransformer() -> ValueTransformer! {
        return CPTJSONAdapter.dictionaryTransformer(withModelClass: ActionsInvocationRecord.self);
    }
    
    @objc static public func BooleanJSONTransformer() -> ValueTransformer! {
        return MTLValueTransformer(usingReversibleBlock: { (obj: Any?, success: UnsafeMutablePointer<ObjCBool>?, error: NSErrorPointer) -> Any? in
            if obj == nil {
                return nil
            } else if let string = obj as? String {
                return string == "true" ? kCFBooleanTrue : kCFBooleanFalse
            } else if let number = obj as? NSNumber {
                return number.boolValue ? kCFBooleanTrue : kCFBooleanFalse
            } else {
                return nil
            }
        })
    }
    
    @objc static public func CodeCoverageInfoJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: CodeCoverageInfo.self);
    }
    
    @objc static public func DocumentLocationJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: DocumentLocation.self);
    }
    
    @objc static public func IntJSONTransformer() -> ValueTransformer! {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return MTLValueTransformer.mtl_transformer(with: formatter, forObjectClass: NSValue.self)
    }
    
    // TODO: Alex - need to debug why we can't get the Date/NSDate transformers to be picked up by Mantle automatically
    @objc static public func DateJSONTransformer() -> ValueTransformer! {
        return self.NSDateJSONTransformer()
    }
    
    // TODO: Alex - need to debug why we can't get the Date/NSDate transformers to be picked up by Mantle automatically
    @objc static public func NSDateJSONTransformer() -> ValueTransformer! {
        return MTLValueTransformer.mtl_dateTransformer(withDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ", locale: Locale.current)
    }
    
    @objc static public func NSNumberJSONTransformer() -> ValueTransformer! {
        return IntJSONTransformer()
    }
    
    @objc static public func ReferenceJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: Reference.self);
    }
    
    @objc static public func ResultIssueSummariesJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: ResultIssueSummaries.self);
    }
    
    @objc static public func ResultMetricsJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: ResultMetrics.self);
    }
    
    @objc static public func SortedKeyValueArrayJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: SortedKeyValueArray.self);
    }
    
    @objc static public func SortedKeyValueArrayPairJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: SortedKeyValueArrayPair.self);
    }
    
    @objc static public func TestFailureIssueSummaryJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: TestFailureIssueSummary.self);
    }
    
    @objc static public func TypeDefinitionJSONTransformer() -> ValueTransformer! {
        return self.dictionaryTransformer(withModelClass: TypeDefinition.self);
    }
    
    // MARK: ObjC Types
    @objc override open class func transformerForModelProperties(ofObjCType objCType: UnsafePointer<Int8>!) -> ValueTransformer! {
        // See https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
        if (strcmp(objCType, "B") == 0) {
            // Boolean
            return BooleanJSONTransformer()
        } else if (strcmp(objCType, "c") == 0) {
            // For some reason Swift bools come as characters?
            return BooleanJSONTransformer()
        } else if (strcmp(objCType, "q") == 0) {
            // long long
            return IntJSONTransformer()
        } else if (strcmp(objCType, "i") == 0) {
            // int
            return IntJSONTransformer()
        } else if (strcmp(objCType, "d") == 0) {
            // double
            return IntJSONTransformer()
        } else if (strcmp(objCType, "f") == 0) {
            // float
            return IntJSONTransformer()
        }
        
        return nil
    }
}
