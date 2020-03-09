//
//  GenericProtocol.swift
//  emvco3ds_protocols_ios
//
//  Created by Kinaan, William on 16/08/2017.
// Test

import UIKit

@objc public protocol GenericChallengeProtocol {
    /*
     * SDK Hook to Automatically click on Submit Button
     * from the RefApp
     */
    func clickVerifyButton()
    
    /*
     01 Text challenge
     02 Single challenge
     03 Multip challenge
     04 OOB
     05 HTML
     */
    func getChallengeType() -> String
    
    /*
     * SDK Hook to Automatically click on Cancel Button
     * from the RefApp
     */
    func clickCancelButton()
    
    /*
     * SDK Hook to set the SDKChallengeProtocol
     * so the RefApp can be notified by the SDK
     * when the Challenge Screen will be displayed.
     */
    func setChallengeProtocol(sdkChallengeProtocol: SDKChallengeProtocol)
    
    /**
     * <p> Callback to notify the SDK to expand all text areas before RefApp takes a screenshot
     * for Visual Test Cases. </p>
     * **/
    func expandTextsBeforeScreenshot()
}
