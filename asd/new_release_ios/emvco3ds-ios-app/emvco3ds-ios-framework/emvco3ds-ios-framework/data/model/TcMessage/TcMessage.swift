//  TcMessage.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.


import UIKit
import ObjectMapper

class TcMessage: Mappable, CustomStringConvertible {
    var description: String {
        return ""
    }
    
    required init? (map: Map){
        // required init to be conform with the Mappable protocol
    }
    
    var header : Header?
    var pAReqFields: [PAReq]?
    var challengeUserData : [ChallengeUserData]?
    
    func mapping(map: Map) {
        header <- map["headers"]
        pAReqFields <- (map["pAreq"], TcMessagePaReqTransformType())
        challengeUserData <- map["challengeUserData"]
    }
}
