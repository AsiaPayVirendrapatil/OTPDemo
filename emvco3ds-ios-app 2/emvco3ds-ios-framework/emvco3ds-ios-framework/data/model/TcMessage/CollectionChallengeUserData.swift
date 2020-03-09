	//
//  CollectionChallengeUserData.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.


import UIKit
import ObjectMapper
class ChallengeUserData: NSObject, Mappable {
    
    @objc static let CHALLENGE_UI = "CHALLENGE_UI"
    @objc static let PROCESSING_SCREEN_AREQ = "PROCESSING_SCREEN_AREQ"
    @objc static let PROCESSING_SCREEN_CREQ = "PROCESSING_SCREEN_CREQ"
    
    @objc var textValue : String?
    var order : Int?
    @objc var uiType : String?
    var singleSelectorIndex : Int?
    @objc var stepIdentifier : String?
    var captureScreenshots : Bool?
    @objc var multipleSelectorIndices : [MultipleSelectorIndex]?
    @objc var challengeHtmlData : String?
    var cancelChallenge : Bool?
    var simulateOobAuth : Bool?
    @objc var screenshotType : String?
    var delayCardholderInput : Int?
    @objc var httpMethod : String?
    var whitelistingDataEntry : Bool?
    
    required init(map : Map) {
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map) {
        textValue <- map["textValue"]
        order <- map["order"]
        uiType <- map["uiType"]
        singleSelectorIndex <- map["singleSelectorIndex"]
        stepIdentifier <- map["stepIdentifier"]
        captureScreenshots <- map["captureScreenshots"]
        multipleSelectorIndices <- map["multipleSelectorIndices"]
        challengeHtmlData <- map["challengeHtmlData"]
        cancelChallenge <- map["cancelChallenge"]
        simulateOobAuth <- map["simulateOobAuth"]
        screenshotType <- map["screenshotType"]
        delayCardholderInput <- map["delayCardholderInput"]
        httpMethod <- map["httpMethod"]
        whitelistingDataEntry <- map["whitelistingDataEntry"]
    }
    
    @objc func getwhitelistingDataEntry() -> Bool{
        if (whitelistingDataEntry == nil){
            return false
        }
        else{
            return whitelistingDataEntry!
        }
    }
    
    @objc func getHttpMethod()->String
    {
        if (httpMethod == nil ){
            return "POST"
        }
        else if (httpMethod?.count == 0){
            return "POST"
        }
        else
        {
            return httpMethod!
        }
    }
}
