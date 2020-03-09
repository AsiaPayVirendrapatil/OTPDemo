//  Strings.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

public class StringTokens: NSObject {
    let txtFrictionlessStatusY: String = "Authenticated Successfully"
    let txtFrictionlessStatusA: String = "Not Authenticated, but a proof of attempted authentication is provided"
    let txtFrictionlessStatusN: String = "Not Authenticated. Transaction denied"
    let txtFrictionlessStatusU: String = "Authentication could not be performed; Technical or other problem, as indicated in ARes or PReq"
    let txtFrictionlessStatusR: String = "Authentication Rejected; Issuer is rejecting authentication and request that authorisation not be attempted"
    let txtFrictionlessStatusD: String = "Received an unknown transaction status on ARes"
    let txtChallengeUnknown: String = "Received an unknown transaction status on CRes"
    let txtChallengeTimeout: String = "Challenge Timeout"
    let txtChallengeCancelled: String = "Challenge Cancelled"
    let txtChallengeRuntimeError: String = "Challenge Runtime Error"
    let txtAResError: String = "Received error on ARes"
    let txtAReqError: String = "AReq Error"
}
