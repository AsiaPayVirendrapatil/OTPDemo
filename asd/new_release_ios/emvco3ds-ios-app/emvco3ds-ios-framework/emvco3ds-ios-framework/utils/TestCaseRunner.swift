//  TestCaseRunner.swift
//  emvco3ds-ios-app
//
//  Copyright © 2017 UL Transaction Security. All rights reserved.

import UIKit
import emvco3ds_protocols_ios

public class TestCaseRunner: NSObject {
    
    static let instance = TestCaseRunner()
    var tcMessage : TcMessage?
    var paIdx : Int
    var projectId : String?
    var testCaseRunId : String?
    var testCaseId : String?
    
    struct header {
        static let testCaseRunId = "x-ul-testcaserun-id"
        static let testCaseId = "x-ul-testcase-id"
    }

    override init() {
        paIdx = 0
        super.init()
    }
    
    public func shouldHandleChallengeData(topViewController: UIViewController) {
        if (topViewController is GenericChallengeProtocol) {
            
            Log.i(object: self, message: "shouldHandleChallengeData()")
            (topViewController as! GenericChallengeProtocol).setChallengeProtocol(sdkChallengeProtocol: SDKChallengeDataProtocol.instance)
             SDKChallengeDataProtocol.instance.onHandleChallenge(uiViewController: topViewController)
        }
    }

    public func startTransaction(uiViewController : UIViewController) {
        Log.i(object: self, message: "Start transaction")
        let transactionManager : TransactionManager = TransactionManager.instance
        transactionManager.initializeSdk()

        TransactionManager.sdkProgressDialog?.show()

        let pAreq = self.tcMessage?.pAReqFields![self.paIdx]
        pAreq?.p_testCaseRunId = self.tcMessage?.header?.pAreqId
        projectId = self.tcMessage?.header!.projectId!
        
        Log.i(object: self, message: "Executing pAReq \(self.paIdx+1) of \(self.tcMessage?.pAReqFields?.count ?? 0)")
        transactionManager.startAResAResFlow(pAreq: pAreq!, projectId: projectId!, uiViewController: uiViewController)
    }

    public func hasNextPareq() -> Bool {
        if (tcMessage != nil) {
            if ((self.tcMessage?.pAReqFields?.count)! > (paIdx + 1)) {
                Log.i(object: self, message: "hasNextPareq = true")
                paIdx = paIdx + 1
                return true;
            }
            Log.i(object: self, message: "hasNextPareq = false")
            return false;
        }
        return false
    }
}

