	//
//  CollectionChallengeUserData.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.


import UIKit
import ObjectMapper
class ChallengeUserData: NSObject, Mappable {
    
    static let CHALLENGE_UI = "CHALLENGE_UI"
    static let PROCESSING_SCREEN_AREQ = "PROCESSING_SCREEN_AREQ"
    static let PROCESSING_SCREEN_CREQ = "PROCESSING_SCREEN_CREQ"
    
    var textValue : String?
    var order : Int?
    var uiType : String?
    var singleSelectorIndex : Int?
    var stepIdentifier : String?
    var captureScreenshots : Bool?
    var multipleSelectorIndices : [MultipleSelectorIndex]?
    var challengeHtmlData : String?
    var cancelChallenge : Bool?
    var simulateOobAuth : Bool?
    var screenshotType : String?
    var delayCardholderInput : Int?
    var httpMethod : String?
    
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
    }
    
    func getHttpMethod()->String
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
