//
//  PCrq.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper

class PSrq: NSObject, Mappable {
    @objc var messageType: String?
    @objc var messageVersion: String?
    @objc var p_messageVersion: String?
    @objc var threeDSServerTransID: String?
    @objc var p_isTransactionCompleted: String? = "false"
    @objc var p_challengeCancel: String?
    @objc var p_challengeTimeout: String?
    @objc var p_protocolErrorCode: String?
    @objc var p_protocolErrorMessage: String?
    @objc var p_runtimeErrorCode: String?
    @objc var p_runtimeErrorMessage: String?
    
    override init () {
        messageType = "pSrq"
    }
    
    required init? (map: Map){
        // required init to be conform with the Mappable protocol
    }
    
    func mapping(map: Map) {
        messageType <- map["messageType"]
        messageVersion <- map["messageVersion"]
        p_messageVersion <- map["p_messageVersion"]
        threeDSServerTransID <- map["threeDSServerTransID"]
        p_isTransactionCompleted <- map["p_isTransactionCompleted"]
        p_challengeCancel <- map["p_challengeCancel"]
        p_challengeTimeout <- map["p_challengeTimeout"]
        p_protocolErrorCode <- map["p_protocolErrorCode"]
        p_protocolErrorMessage <- map["p_protocolErrorMessage"]
        p_runtimeErrorCode <- map["p_runtimeErrorCode"]
        p_runtimeErrorMessage <- map["p_runtimeErrorMessage"]
    }
}
