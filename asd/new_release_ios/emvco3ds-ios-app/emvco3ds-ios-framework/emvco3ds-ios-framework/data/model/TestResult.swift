//  TestResult.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

class TestResult: NSObject {
    let testResultString: String?
    var tmNotifier: TMNotifier?
    var pcrqMessage: PSrq?
    let isChallengeTransaction: Bool?
    var isSuccess : Bool = true
    
    init(testResultString: String, isChallengeTransaction: Bool) {
        self.testResultString = testResultString
        self.isChallengeTransaction = isChallengeTransaction
    }
}
