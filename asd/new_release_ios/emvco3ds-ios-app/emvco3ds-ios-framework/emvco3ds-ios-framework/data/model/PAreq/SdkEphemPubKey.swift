//
//  SdkEphemPubKey.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper

class SdkEphemPubKey: NSObject, Mappable {
    var kty: String?
    var crv: String?
    var x: String?
    var y: String?
    
    required init?(map : Map) {
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map) {
        kty <- map["kty"]
        crv <- map["crv"]
        x <- map["x"]
        y <- map["y"]
    }
}
