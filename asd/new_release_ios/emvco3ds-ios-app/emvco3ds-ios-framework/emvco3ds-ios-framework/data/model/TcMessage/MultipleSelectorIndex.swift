//
//  MultipleSelectorIndex.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.


import UIKit
import ObjectMapper

class MultipleSelectorIndex: NSObject, Mappable {

    var order : Int?
    var isSelected : Bool?
    var selected : Bool?

    required init(map : Map) {
        // required init to be conform with the Mappable protocol
    }

    func mapping(map: Map){
        order <- map["order"]
        isSelected <- map["isSelected"]
        selected <- map["selected"]
    }

}
