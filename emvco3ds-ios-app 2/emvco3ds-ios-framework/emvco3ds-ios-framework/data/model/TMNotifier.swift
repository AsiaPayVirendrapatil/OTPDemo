//  TMNotifier.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper


class TMNotifier: NSObject, Mappable {
    
    @objc var testCaseIds : [String]?
    @objc var testPlanId : String?
    @objc var projectId : String?
    @objc var sessionId : String?
    @objc var testCaseRunIdentifier : String?
    @objc var testIterationId : String?
    
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
