//  TMNotifier.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper


class TMNotifier: NSObject, Mappable {
    
    var testCaseIds : [String]?
    var testPlanId : String?
    var projectId : String?
    var sessionId : String?
    var testCaseRunIdentifier : String?
    var testIterationId : String?
    
    override init () {
        super.init()
    }
    
    required init(map : Map) {
        // required init to be conform with the Mappable protocol
         super.init()
    }
    
    func mapping(map: Map){
        testCaseIds <- map["testCaseIds"]
        testPlanId <- map["testPlanId"]
        projectId <- map["projectId"]
        sessionId <- map["sessionId"]
        projectId <- map["projectId"]
        testCaseRunIdentifier <- map["testCaseRunIdentifier"]
        testIterationId <- map["testIterationId"]
    }
}
