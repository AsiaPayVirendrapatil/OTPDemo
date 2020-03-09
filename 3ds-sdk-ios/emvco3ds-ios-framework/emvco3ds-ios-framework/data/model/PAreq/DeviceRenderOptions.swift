//
//  DeviceRenderOptions.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper


class DeviceRenderOptions: NSObject, Mappable {
    @objc var interface: String?
    @objc var uiType: [String]?
    @objc var sdkInterface: String?
    @objc var sdkUiType: [String]?
    
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
