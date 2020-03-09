//
//  PAReq.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper
public class PAReq: NSObject, Mappable {
    @objc var acctType: String?
    @objc var addrMatch: String?
    @objc var billAddrCity: String?
    @objc var billAddrCountry: String?
    @objc var billAddrLine1: String?
    @objc var billAddrLine2: String?
    @objc var billAddrLine3: String?
    @objc var billAddrPostCode: String?
    @objc var billAddrState: String?
    @objc var shipAddrCity: String?
    @objc var shipAddrCountry: String?
    @objc var shipAddrLine1: String?
    @objc var shipAddrLine2: String?
    @objc var shipAddrLine3: String?
    @objc var shipAddrPostCode: String?
    @objc var shipAddrState: String?
    @objc var deviceChannel: String?
    @objc var deviceRenderOptions: DeviceRenderOptions?
    @objc var email: String?
    @objc var homePhone: Phone?
    @objc var messageCategory: String?
    @objc var messageType: String?
    @objc var messageVersion: String?
    @objc var mobilePhone: Phone?
    @objc var workPhone : Phone?
    @objc var p_messageVersion: String?
    @objc var purchaseCurrency: String?
    @objc var purchaseDate: String?
    @objc var purchaseExponent: String?
    @objc var purchaseInstalData: String?
    @objc var recurringExpiry: String?
    @objc var recurringFrequency: String?
    @objc var threeDSRequestorChallengeInd: String?
    @objc var cardExpiryDate: String?
    @objc var acctNumber: String?
    @objc var cardholderName: String?
    @objc var purchaseAmount: String?
    @objc var threeDSRequestor3RIInd: String?
    @objc var threeDSRequestorName: String?
    @objc var threeDSRequestorURL: String?
    @objc var threeDSRequestorID: String?
    @objc var mcc  : String?
    @objc var merchantCountryCode: String?
    @objc var merchantName : String?
    @objc var p_testCaseRunId : String?
    @objc var sdkAppID: String?
    @objc var sdkEncData: String?
    @objc var sdkEphemPubKey: SdkEphemPubKey?
    @objc var sdkReferenceNumber: String?
    @objc var sdkTransID: String?
    @objc var acquirerMerchantID: String?
    @objc var acquirerBIN : String?
    @objc var acctID : String?
    @objc var transType : String?
    @objc var threeDSRequestorNPAInd : String?
    @objc var threeDSRequestorAuthenticationInd : String?
    @objc var sdkMaxTimeout : String?
    @objc var threeDSRequestorDecMaxTime: String?
    @objc var threeDSRequestorDecReqInd: String?
    
    
    public required init? (map: Map){
        // required init to be conform with the Mappable protocol
    }
    
    public func mapping(map: Map) {
        acctType <- map["acctType"]
        addrMatch <- map["addrMatch"]
        billAddrCity <- map["billAddrCity"]
        billAddrCountry  <- map["billAddrCountry"]
        billAddrLine1 <- map["billAddrLine1"]
        billAddrLine2 <- map["billAddrLine2"]
        billAddrLine3 <- map["billAddrLine3"]
        billAddrPostCode <- map["billAddrPostCode"]
        billAddrState <- map["billAddrState"]
        shipAddrCity <- map["shipAddrCity"]
        shipAddrCountry <- map["shipAddrCountry"]
        shipAddrLine1 <- map["shipAddrLine1"]
        shipAddrLine2 <- map["shipAddrLine2"]
        shipAddrLine3 <- map["shipAddrLine3"]
        shipAddrPostCode <- map["shipAddrPostCode"]
        shipAddrState <- map["shipAddrState"]
        deviceChannel  <- map["deviceChannel"]
        deviceRenderOptions <- map["deviceRenderOptions"]
        email   <- map["email"]
        homePhone <- map["homePhone"]
        messageCategory <- map["messageCategory"]
        messageType <- map["messageType"]
        messageVersion <- map["messageVersion"]
        mobilePhone  <- map["mobilePhone"]
        workPhone <- map["workPhone"]
        p_messageVersion   <- map["p_messageVersion"]
        purchaseCurrency <- map["purchaseCurrency"]
        purchaseDate  <- map["purchaseDate"]
        purchaseExponent <- map["purchaseExponent"]
        purchaseInstalData <- map["purchaseInstalData"]
        recurringExpiry  <- map["recurringExpiry"]
        recurringFrequency <- map["recurringFrequency"]
        threeDSRequestorChallengeInd   <- map["threeDSRequestorChallengeInd"]
        cardExpiryDate   <- map["cardExpiryDate"]
        acctNumber  <- map["acctNumber"]
        cardholderName <- map["cardholderName"]
        purchaseAmount <- map["purchaseAmount"]
        threeDSRequestor3RIInd <- map["threeDSRequestor3RIInd"]
        threeDSRequestorName <- map["threeDSRequestorName"]
        threeDSRequestorURL <- map["threeDSRequestorURL"]
        threeDSRequestorID <- map["threeDSRequestorID"]
        mcc <- map["mcc"]
        merchantCountryCode <- map["merchantCountryCode"]
        merchantName<-map["merchantName"]
        
        sdkAppID <- map["sdkAppID"]
        sdkEncData <- map["sdkEncData"]
        sdkEphemPubKey <- map["sdkEphemPubKey"]
        sdkReferenceNumber <- map["sdkReferenceNumber"]
        sdkTransID <- map["sdkTransID"]
        acquirerMerchantID <- map["acquirerMerchantID"]
        acquirerBIN <- map["acquirerBIN"]
        acctID <- map["acctID"]
        p_testCaseRunId <- map["p_testCaseRunId"]
        transType <- map["transType"]
        threeDSRequestorNPAInd <- map["threeDSRequestorNPAInd"]
        threeDSRequestorAuthenticationInd <- map["threeDSRequestorAuthenticationInd"]
        sdkMaxTimeout <- map["sdkMaxTimeout"]
        threeDSRequestorDecMaxTime <- map["threeDSRequestorDecMaxTime"]
        threeDSRequestorDecReqInd <- map["threeDSRequestorDecReqInd"]
    }
}
