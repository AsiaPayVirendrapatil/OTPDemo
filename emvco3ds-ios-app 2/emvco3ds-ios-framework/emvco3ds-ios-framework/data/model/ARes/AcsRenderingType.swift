//
//  AcsRenderingType.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper

class AcsRenderingType: NSObject, Mappable {
    @objc var inteface: String?
    @objc var uiType: String?
    
    required init? (map: Map){
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map) {
        inteface <- map["interface"]
        uiType <- map["uiType"]
    }
}
