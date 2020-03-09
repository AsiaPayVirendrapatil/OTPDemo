//  TestResult.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

class TestResult: NSObject {
    @objc let testResultString: String?
    @objc var tmNotifier: TMNotifier?
    @objc var pcrqMessage: PSrq?
    let isChallengeTransaction: Bool?
    @objc var isSuccess : Bool = true
    
    @objc init(testResultString: String, isChallengeTransaction: Bool) {
        self.testResultString = testResultString
        self.isChallengeTransaction = isChallengeTransaction
    }
}
