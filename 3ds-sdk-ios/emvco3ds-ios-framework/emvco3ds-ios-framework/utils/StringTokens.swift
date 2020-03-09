//  Strings.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

public class StringTokens: NSObject {
    @objc let txtFrictionlessStatusY: String = "Authenticated Successfully"
    @objc let txtFrictionlessStatusA: String = "Not Authenticated, but a proof of attempted authentication is provided"
    @objc let txtFrictionlessStatusN: String = "Not Authenticated. Transaction denied"
    @objc let txtFrictionlessStatusU: String = "Authentication could not be performed; Technical or other problem, as indicated in ARes or PReq"
    @objc let txtFrictionlessStatusR: String = "Authentication Rejected; Issuer is rejecting authentication and request that authorisation not be attempted"
    @objc let txtFrictionlessStatusD: String = "Received an unknown transaction status on ARes"
    @objc let txtChallengeUnknown: String = "Received an unknown transaction status on CRes"
    @objc let txtChallengeTimeout: String = "Challenge Timeout"
    @objc let txtChallengeCancelled: String = "Challenge Cancelled"
    @objc let txtChallengeRuntimeError: String = "Challenge Runtime Error"
    @objc let txtAResError: String = "Received error on ARes"
    @objc let txtAReqError: String = "AReq Error"
}
