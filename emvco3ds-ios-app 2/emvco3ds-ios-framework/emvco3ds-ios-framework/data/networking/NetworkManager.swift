//  NetworkManager.swift
//  emvco3ds-ios-app
//
//  Copyright © 2017 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire

class NetworkManager: NSObject {
    
    #if DEBUG
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "tt.local": .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: false,
                validateHost: false
            ),
            "simulator-emvco3ds.tt.local": .disableEvaluation,
            "selftestplatform.com": .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: false,
                validateHost: false
            ),
            "ras-3ds-uat.selftestplatform.com": .disableEvaluation
            
        ]
    #else
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
        "tt.local": .pinCertificates(
        certificates: ServerTrustPolicy.certificates(),
        validateCertificateChain: false,
        validateHost: false
        ),
        "simulator-emvco3ds.tt.local": .disableEvaluation
        ]
    #endif
    
    let sessionManager: SessionManager
    override init() {
        sessionManager = SessionManager(
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }
}
