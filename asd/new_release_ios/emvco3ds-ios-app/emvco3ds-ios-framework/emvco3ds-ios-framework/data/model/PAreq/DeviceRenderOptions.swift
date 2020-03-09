//
//  DeviceRenderOptions.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper


class DeviceRenderOptions: NSObject, Mappable {
    var interface: String?
    var uiType: [String]?
    var sdkInterface: String?
    var sdkUiType: [String]?
    
    required init?(map : Map) {
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map) {
        interface <- map["interface"]
        uiType <- map["uiType"]
        sdkInterface <- map["sdkInterface"]
        sdkUiType <- map["sdkUiType"]
    }
}
