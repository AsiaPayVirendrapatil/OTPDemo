//
//  Phone.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper

class Phone: NSObject, Mappable {
    
    @objc var cc: String?
    @objc var subscriber: String?
    
    required init?(map : Map) {
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map) {
        cc <- map["cc"]
        subscriber <- map["subscriber"]
    }
    
}
