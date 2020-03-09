//  TcMessagePaReqTransformType.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper

/**
   Transforms JSON (paReq property) into a paReq array,regardless of how it is delivered (single instance on PROD, array on other environments currently)
 */
class TcMessagePaReqTransformType: TransformType {
    func transformToJSON(_ value: [PAReq]?) -> [[String : Any]]? {
        return nil
    }
    
    func transformFromJSON(_ value: Any?) -> [PAReq]? {
        var result = [PAReq]()
        if let array = value as? [[String: Any]]{
            for item in array {
                if let paReq = PAReq(JSON: item) {
                    result.append(paReq)
                }
            }
            return result
        }
        else{
            let json = value as? [String: Any]
            if let paReq = PAReq (JSON: json!){
                result.append(paReq)
            }
            return result
        }
    }
}
