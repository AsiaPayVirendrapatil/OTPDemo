//  Header.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.


import UIKit
import ObjectMapper

class Header: NSObject, Mappable {
    @objc var pAreqId : String?
    var apiKey: Bool?
    var isFound : Bool?
    var isAlreadySent: Bool?
    @objc var projectId : String?
    @objc var testCaseId : String?
    @objc var testPlanId: String?
    @objc var sessionId : String?
    @objc var testIterationId : String?
    @objc var directoryServerId : String?
    var timeoutEnabled : Bool?
    
    required init(map : Map) {
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map){
        pAreqId <- map["pAreqId"]
        apiKey <- map["apiKey"]
        isFound <- map["isFound"]
        isAlreadySent <- map["isAlreadySent"]
        projectId <- map["projectId"]
        testCaseId <- map["testCaseId"]
        testPlanId <- map["testPlanId"]
        sessionId <- map["sessionId"]
        testIterationId <- map["testIterationId"]
        directoryServerId <- map["directoryServerID"]
        timeoutEnabled <- map["timeoutEnabled"]
    }
}
