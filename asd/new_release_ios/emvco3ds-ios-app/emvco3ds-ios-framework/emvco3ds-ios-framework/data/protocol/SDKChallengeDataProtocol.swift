//  SDKChallengeDataProtocol.swift
//  emvco3ds-ios-app
//
//  Copyright © 2017 UL Transaction Security. All rights reserved.

import UIKit
import emvco3ds_protocols_ios
import WebKit

class SDKChallengeDataProtocol: NSObject, SDKChallengeProtocol, ScreenshotUploadProtocol, TransactionManagerDelegate {
    
    let CHALLENGE_TYPE_SINGLE_SELECT = "02"
    let CHALLENGE_TYPE_MULTI_SELECT = "03"
    let SIXTY_SECONDS = 60000
    
    static var instance : SDKChallengeDataProtocol = SDKChallengeDataProtocol()
    
    let transactionManager : TransactionManager = TransactionManager.instance
    let testCaseRunner : TestCaseRunner = TestCaseRunner.instance
    
    var challengeIteration : Int = 0
    var topViewController : UIViewController?
    var genericChallengeProtocol : GenericChallengeProtocol?
    var challengeData :  ChallengeUserData?
    
    override init() {
        super.init()
        transactionManager.delegate = self
    }
    
    deinit {
        transactionManager.delegate = nil
    }
    
    func errorEventReceived(){
        Log.e(object: self, message: "Timed out")
        cancelClickSubmitButton()
    }
    
    func onHandleChallenge(uiViewController : UIViewController) {
        Log.i(object: self, message: "onHandleChallenge")
        self.topViewController = uiViewController;
    }
    
    func handleChallenge() {
        Log.i(object: self, message: "handle Challenge")
        TransactionManager.sdkProgressDialog?.close()
        
        if (testCaseRunner.tcMessage != nil) {
            let countChallengeData = testCaseRunner.tcMessage?.challengeUserData?.count ?? 0
            Log.i(object: self, message: "Number of Challenge Data on TestCase = \(countChallengeData)")
            
            if (testCaseRunner.tcMessage?.challengeUserData?.count)! > challengeIteration {
                challengeData = testCaseRunner.tcMessage?.challengeUserData![challengeIteration]
            }
            
            genericChallengeProtocol = self.topViewController as? GenericChallengeProtocol
        }
        
        switch (self.topViewController) {
            case is TextChallengeProtocol:
                Log.i(object: self, message: "TextChallenge Protocol")
                handleTextChallengeProtocol(challengeData: challengeData)
                break
            case is SingleSelectorChallengeProtocol, is MultiSelectChallengeProtocol:
                Log.i(object: self, message: "MultiSelectChallenge Protocol")
                handleMultiSelectChallengeProtocol(challengeData: challengeData)
                break
            case is OutOfBandChallengeProtocol:
                Log.i(object: self, message: "OutOfBandChallenge Protocol")
                handleOutOfBandChallengeProtocol(challengeData: challengeData)
                break
            case is WebChallengeProtocol:
                Log.i(object: self, message: "WebChallenge Protocol")
                handleWebChallengeProtocol(challengeData: challengeData)
                break
            default:
                break
        }
        
        challengeIteration+=1
    }
    
    func handleWebChallengeProtocol (challengeData: ChallengeUserData?){
        if (challengeData != nil) {
            if ((challengeData?.cancelChallenge)!) {
                clickCancelButton()
            }
            else {
                let myWebView : UIWebView!
                
                myWebView = (self.topViewController as! WebChallengeProtocol).getWebView()
                
                if ((challengeData?.captureScreenshots)!) {
                    takeScreenshot(stepIdentifier: (challengeData?.stepIdentifier)!, viewController: self.topViewController!)
                }
                else {
                    webViewDidFinishLoad(myWebView, challengeData: challengeData!)
                }
            }
        }
    }
    
    func handleOutOfBandChallengeProtocol(challengeData: ChallengeUserData?){
        if (challengeData != nil) {
            if ((challengeData?.cancelChallenge)!) {
                clickCancelButton()
            }
            else {
                if ((challengeData?.captureScreenshots)!) {
                    takeScreenshot(stepIdentifier: (challengeData?.stepIdentifier)!, viewController: self.topViewController!)
                }
                else {
                    clickSubmitButton()
                }
            }
        }
        else {
            clickSubmitButton()
        }
    }
    
    func handleMultiSelectChallengeProtocol(challengeData:ChallengeUserData?){
        if (challengeData != nil) {
            if ((challengeData?.cancelChallenge)!) {
                clickCancelButton()
            }
            else {
                if (genericChallengeProtocol?.getChallengeType() == CHALLENGE_TYPE_SINGLE_SELECT) {
                    Log.i(object: self, message: "SingleSelectorChallengeProtocol")
                    let singleSelectChallengeProtocol : SingleSelectorChallengeProtocol = self.topViewController as! SingleSelectorChallengeProtocol
                    singleSelectChallengeProtocol.selectObject((challengeData?.singleSelectorIndex)!)
                    
                }
                else if (genericChallengeProtocol?.getChallengeType() == CHALLENGE_TYPE_MULTI_SELECT) {
                    Log.i(object: self, message: "SDKChallengeDataProtocol - MultiSelectChallengeProtocol")
                    let multiSelectChallengeProtocol : MultiSelectChallengeProtocol = self.topViewController as! MultiSelectChallengeProtocol
                    
                    for multi in (challengeData?.multipleSelectorIndices)! {
                        if multi.isSelected! {
                            multiSelectChallengeProtocol.selectIndex(multi.order!)
                        }
                    }
                }
                
                if ((challengeData?.captureScreenshots)!) {
                    takeScreenshot(stepIdentifier: (challengeData?.stepIdentifier)!, viewController: self.topViewController!)
                }
                else {
                    clickSubmitButton()
                }
            }
        }
    }
    
    func handleTextChallengeProtocol(challengeData: ChallengeUserData?){
        if (challengeData != nil) {
            if ((challengeData?.cancelChallenge)!) {
                clickCancelButton()
            }
            else {
                let textChallengeProtocol : TextChallengeProtocol = self.topViewController as! TextChallengeProtocol
            
                if (challengeData?.textValue != nil) {
                    textChallengeProtocol.typeTextChallengeValue((challengeData?.textValue)!)
                }
                
                if ((challengeData?.captureScreenshots)! && challengeData?.screenshotType == ChallengeUserData.CHALLENGE_UI) {
                    takeScreenshot(stepIdentifier: (challengeData?.stepIdentifier)!, viewController: self.topViewController!)
                }
                else {
                    clickSubmitButton()
                }
            }
        }
    }

    func takeScreenshot(stepIdentifier : String, viewController : UIViewController) {
        genericChallengeProtocol?.expandTextsBeforeScreenshot()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            let screenshot = UIApplication.shared.screenShot!
            MainNavigationController.screenshotMessage?.stepIdentifier = stepIdentifier
            ScreenshotUploader(delegate: self, screenshotMessage: MainNavigationController.screenshotMessage!, myActivityIndicator: self.showLoading(view:viewController.view)).upload(screenshot: screenshot)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView, challengeData : ChallengeUserData) {
        var challengeHtmlData : String
        
        if (challengeData.challengeHtmlData == nil) {
            challengeHtmlData = ""
        }
        else {
            challengeHtmlData = challengeData.challengeHtmlData!
        }
      
        let urlChallenge = String(format:ConfigurationManager.challengeUrl, challengeHtmlData)
        
        let urlRequest = URL (string : urlChallenge)
        
        if (challengeData.getHttpMethod()=="POST"){
            var request = URLRequest(url: urlRequest!)
            request.httpMethod = "POST"
            webView.loadRequest(request)
        }
        else{
            let requestChallenge = URLRequest(url: urlRequest!)
            webView.loadRequest(requestChallenge)
        }
        
        
    }
    
    func onSuccessfull(message: String) {
        clickSubmitButton()
        Log.i(object: self, message: "onSuccessful: "+message)
    }
    
    func onNetworkError(message: String) {
        clickSubmitButton()
        Log.e(object: self, message: "onNetworkError: "+message)
    }
    
    func onError(message: String) {
        clickSubmitButton()
        Log.e(object: self, message: "onError: " + message)
    }
    
    func onUnexpectedError(message: String) {
        clickSubmitButton()
        Log.e(object: self, message: "onUnexpected error "+message)
    }
    
    func showLoading(view : UIView) -> UIActivityIndicatorView {
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = view.center
        myActivityIndicator.startAnimating()
        view.addSubview(myActivityIndicator)
        
        return myActivityIndicator
    }
    
    var workItemClickSubmitbutton : DispatchWorkItem? = nil
    
    func cancelClickSubmitButton(){
        workItemClickSubmitbutton?.cancel()
    }
    
    func clickSubmitButton() {
        if (UserDefaults.standard.bool(forKey: SettingsBundleHelper.SettingsBundleKeys.autoSubmitChallenges)){
            if (challengeData?.delayCardholderInput != nil) {
                let delay = Int((challengeData?.delayCardholderInput)!) * SIXTY_SECONDS
                Log.i(object: self, message: "Wait before input cardholder data =\(delay)")
                
                workItemClickSubmitbutton = DispatchWorkItem(block: {
                    self.clickAction()
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: workItemClickSubmitbutton!)
            }
            else {
                clickAction()
            }
        }
    }

    func clickCancelButton() {
        if (UserDefaults.standard.bool(forKey: SettingsBundleHelper.SettingsBundleKeys.autoSubmitChallenges)){
                genericChallengeProtocol?.clickCancelButton()
        }
    }

    func clickAction() {
        if (self.topViewController is WebChallengeProtocol) {
            let myWebView : UIWebView!
            myWebView = (self.topViewController as! WebChallengeProtocol).getWebView()
            webViewDidFinishLoad(myWebView, challengeData: challengeData!)
        } else {
            genericChallengeProtocol?.clickVerifyButton()
        }
    }
}
