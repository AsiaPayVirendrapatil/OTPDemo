//
//  CReq.swift
//  emvco3ds-ios-framework
//
//  Created by Virendra patil on 11/02/19.
//  Copyright © 2019 UL. All rights reserved.
//

import UIKit
import ObjectMapper

class CReq: NSObject {
    var threeDSServerTransID: String?
    var acsTransID: String?
    var messageType: String = "CReq"
    var messageVersion: String = "2.1.0"
    var sdkTransID: String?
    var sdkCounterStoA: String?
    var challengeCancel: String?
    var challengeDataEntry: String?
    var challengeHTMLDataEntry: String?
    var challengeWindowSize: String?
    var messageExtension: String?
    var oobContinue: Bool = false
    var resendChallenge : String?
    
    
    
    init(sdkCounterStoA: String, acsTransID: String , sdkTransID: String, threeDSServerTransID: String, challengCancel: String, challengDataEntry: String, challengHTMLDataEntry: String, messageExtension: String, oobContinue: Bool, challengWindowSize: String,messageType : String,resendChallenge : String) {
        self.sdkCounterStoA = sdkCounterStoA
        self.acsTransID = acsTransID
        self.threeDSServerTransID = threeDSServerTransID
        self.sdkTransID = sdkTransID
        self.challengeCancel = challengCancel
        self.challengeDataEntry = challengDataEntry
        self.challengeHTMLDataEntry = challengHTMLDataEntry
        self.challengeWindowSize = challengWindowSize
        self.messageExtension = messageExtension
        self.oobContinue = oobContinue
        self.messageType  = messageType
        self.resendChallenge = resendChallenge
    }
    
    
    func toJson() -> String {
        var creqDic = [
            "acsTransID":self.acsTransID!,
            "messageType":self.messageType,
            "messageVersion":self.messageVersion,
            "sdkCounterStoA":self.sdkCounterStoA!,
            "sdkTransID":self.sdkTransID!,
            "threeDSServerTransID":self.threeDSServerTransID!,
            //"challengeCancel":self.challengeCancel,
            //"challengeDataEntry":self.challengeDataEntry,
            //"challengeHTMLDataEntry":self.challengeHTMLDataEntry,
            //"challengeWindowSize":self.challengeWindowSize,
            //"messageExtension":self.messageExtension,
            "oobContinue":self.oobContinue
            ] as [String : Any]
        if self.challengeDataEntry != "" {
            creqDic["challengeDataEntry"] = self.challengeDataEntry
        }
        if self.resendChallenge != "" {
            creqDic["resendChallenge"] = self.resendChallenge
        }
        if self.challengeCancel != "" {
            creqDic["challengeCancel"] = self.challengeCancel
        }
        if self.challengeHTMLDataEntry != "" {
            creqDic["challengeHTMLDataEntry"] = self.challengeHTMLDataEntry
        }
        if self.messageExtension != "" {
            creqDic["messageExtension"] = self.messageExtension
        }
        if self.challengeWindowSize != "" {
            creqDic["challengeWindowSize"] = self.challengeWindowSize
        }
        let dicData = try! JSONSerialization.data(withJSONObject: creqDic, options: [])
        return String(data: dicData, encoding: .utf8)!
    }
    
}

