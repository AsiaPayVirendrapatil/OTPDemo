//
//  PCrq.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import ObjectMapper

class PSrq: NSObject, Mappable {
    var messageType: String?
    var messageVersion: String?
    var p_messageVersion: String?
    var threeDSServerTransID: String?
    var p_isTransactionCompleted: String? = "false"
    var p_challengeCancel: String?
    var p_challengeTimeout: String?
    var p_protocolErrorCode: String?
    var p_protocolErrorMessage: String?
    var p_runtimeErrorCode: String?
    var p_runtimeErrorMessage: String?
    
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
