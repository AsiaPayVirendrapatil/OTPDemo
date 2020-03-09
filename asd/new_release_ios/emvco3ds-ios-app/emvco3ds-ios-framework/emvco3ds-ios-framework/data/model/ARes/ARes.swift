//
//  ARes.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper

class ARes: NSObject, Mappable{
    
    var threeDSServerTransID: String?
    var acsEphemPubKey: String?
    var acsTransID: String?
    var acsReferenceNumber: String?
    var acsRenderingType: AcsRenderingType?
    var acsSignedContent: String?
    var acsURL: String?
    var authenticationType: String?
    var authenticationValue: String?
    var challengeMandated: String?
    var dsReferenceNumber: String?
    var dsTransID: String?
    var eci: String?
    var ireqCode: String?
    var ireqDetail: String?
    var messageExtension: String?
    
    var messageType: String?
    var messageVersion: String?
    var sdkEphemPubKey: SdkEphemPubKey?
    var sdkTransID: String?
    var transStatus: String?
    var transStatusReason: String?
    var errorCode: String?
    var challengeCompletionInd: String?
    var p_messageVersion: String?
    
    var timestamp: String?
    var status: String?
    var acschallengeMandated: String?
   
    required init? (map: Map){
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map) {
        threeDSServerTransID <- map["threeDSServerTransID"]
        acsEphemPubKey <- map["acsEphemPubKey"]
        acsTransID <- map["acsTransID"]
        acsReferenceNumber <- map["acsReferenceNumber"]
        acsRenderingType <- map["acsRenderingType"]
        acsSignedContent <- map["acsSignedContent"]
        acsURL <- map["acsURL"]
        authenticationType <- map["authenticationType"]
        authenticationValue <- map["authenticationValue"]
        challengeMandated <- map["challengeMandated"]
        dsReferenceNumber <- map["dsReferenceNumber"]
        dsTransID <- map["dsTransID"]
        eci <- map["eci"]
        ireqCode <- map["ireqCode"]
        ireqDetail <- map["ireqDetail"]
        messageExtension <- map["messageExtension"]
        
        messageType <- map["messageType"]
        messageVersion <- map["messageVersion"]
        sdkEphemPubKey <- map["sdkEphemPubKey"]
        sdkTransID <- map["sdkTransID"]
        transStatus <- map["transStatus"]
        transStatusReason <- map["transStatusReason"]
        errorCode <- map["errorCode"]
        challengeCompletionInd <- map["challengeCompletionInd"]
        p_messageVersion <- map["p_messageVersion"]
        
        timestamp <- map["timestamp"]
        status <- map["status"]
        acschallengeMandated <- map["acschallengeMandated"]
    }
}
