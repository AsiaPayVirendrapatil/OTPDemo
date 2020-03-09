//
//  PAReq.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper
public class PAReq: NSObject, Mappable {
    var acctType: String?
    var addrMatch: String?
    var billAddrCity: String?
    var billAddrCountry: String?
    var billAddrLine1: String?
    var billAddrLine2: String?
    var billAddrLine3: String?
    var billAddrPostCode: String?
    var billAddrState: String?
    var shipAddrCity: String?
    var shipAddrCountry: String?
    var shipAddrLine1: String?
    var shipAddrLine2: String?
    var shipAddrLine3: String?
    var shipAddrPostCode: String?
    var shipAddrState: String?
    var deviceChannel: String?
    var deviceRenderOptions: DeviceRenderOptions?
    var email: String?
    var homePhone: Phone?
    var messageCategory: String?
    var messageType: String?
    var messageVersion: String?
    var mobilePhone: Phone?
    var workPhone : Phone?
    var p_messageVersion: String?
    var purchaseCurrency: String?
    var purchaseDate: String?
    var purchaseExponent: String?
    var purchaseInstalData: String?
    var recurringExpiry: String?
    var recurringFrequency: String?
    var threeDSRequestorChallengeInd: String?
    var cardExpiryDate: String?
    var acctNumber: String?
    var cardholderName: String?
    var purchaseAmount: String?
    var threeDSRequestor3RIInd: String?
    var threeDSRequestorName: String?
    var threeDSRequestorURL: String?
    var threeDSRequestorID: String?
    var mcc  : String?
    var merchantCountryCode: String?
    var merchantName : String?
    
    var p_testCaseRunId : String?
    var sdkAppID: String?
    var sdkEncData: String?
    var sdkEphemPubKey: SdkEphemPubKey?
    var sdkReferenceNumber: String?
    var sdkTransID: String?
    var acquirerMerchantID: String?
    var acquirerBIN : String?
    var acctID : String?
    var transType : String?
    var threeDSRequestorNPAInd : String?
    var threeDSRequestorAuthenticationInd : String?
    var sdkMaxTimeout : String?
    
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
    }
}
