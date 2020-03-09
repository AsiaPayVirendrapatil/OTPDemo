//  ScreenshotMessage.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.


import UIKit
import ObjectMapper
class ScreenshotMessage: NSObject, Mappable {
    
    @objc var projectId : String?
    @objc var testPlanId : String?
    @objc var testCaseRunId : String?
    @objc var testCaseId : String?
    @objc var stepIdentifier : String?
    @objc var base64String : String?
    
    override init() {
        // required to allow init without providing params that are not used anyway
    }
    
    required init(map : Map) {
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map){
        projectId <- map["projectId"]
        testPlanId <- map["testPlanId"]
        testCaseRunId <- map["testCaseRunId"]
        testCaseId <- map["testCaseId"]
        stepIdentifier <- map["stepIdentifier"]
        base64String <- map["base64String"]
    }
    
    static func formMessageOutOfTcMessage(tcMessage : TcMessage)-> ScreenshotMessage {
        let screenshotMessage = ScreenshotMessage()
        screenshotMessage.projectId = tcMessage.header?.projectId
        screenshotMessage.testPlanId = tcMessage.header?.testPlanId
        screenshotMessage.testCaseId = tcMessage.header?.testCaseId
        screenshotMessage.testCaseRunId = tcMessage.header?.pAreqId
        return screenshotMessage
    }
}
