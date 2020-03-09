//  TransactionManager.swift
//  emvco3ds-ios-app
//
//  Copyright © 2017 UL Transaction Security All rights reserved.

import UIKit
import ObjectMapper
//import emvco3ds_ios_framework


public protocol TransactionManagerDelegate: class {
    func errorEventReceived()
}

public class TransactionManager: NSObject, ults_ChallengeStatusReceiver, GenericNetworkProtocol {
    static let instance = TransactionManager()
    static var sdkProgressDialog: ults_ProgressView? = nil
    
    let testCaseRunner = TestCaseRunner.instance
    
    var service: ults_ThreeDS2Service? = nil
    var sdkTransaction: ults_Transaction? = nil
    var isSdkInitialized: Bool = false
    var testResult: TestResult?
    var psrqMessage : PSrq?
    var isChallengeTransaction : Bool? = false
    var uiViewController: UIViewController?
    
    let localizedStrings = StringTokens()
    let factory =  Emvco3dsFramework.factory // Factory()
    var areqAresRequest : RequesterConnector? = nil
    
    weak var delegate: TransactionManagerDelegate?
    
    public func getSdkVersion() -> String {
        var result = "(Unknown)"
        self.initSdkOnce()
        if (service != nil){
            try? result = service!.getSDKVersion()
        }
        return result
    }

    public func initializeSdk() {
        do {
            initSdkOnce()
            Log.i(object: self, message: "Create transaction for service")
            self.sdkTransaction = try self.service?.createTransaction((self.testCaseRunner.tcMessage?.header?.directoryServerId)!, self.testCaseRunner.tcMessage?.pAReqFields?[self.testCaseRunner.paIdx].messageVersion)
            
            TransactionManager.sdkProgressDialog = try self.sdkTransaction!.getProgressView(nil)
        }
        catch _ {
           Log.e(object: self, message: "Error initializing SDK")
        }
    }
    
    func initSdkOnce(){
        do {
            if (!self.isSdkInitialized){
                
                Log.i(object: self, message: "Initializing SDK")
                let config = factory.newConfigParameters()
                self.service = factory.newThreeDS2Service()
                let uiConfig = factory.newUiCustomization()
                
                let locale = NSLocale.autoupdatingCurrent.languageCode! + "-" + NSLocale.autoupdatingCurrent.regionCode!
                try self.service!.initialize(nil, config, locale, uiConfig)
                self.isSdkInitialized = true
                Log.i(object: self, message: "Initialized SDK")
            }
            else {
                Log.w(object: self, message: "SDK has already been initialized")
            }
        }
        catch _ {
            Log.e(object: self, message: "Error initializing SDK")
        }
    }
    
    /*
     * Execute Authentication Request
     */
    public func startAResAResFlow(pAreq : PAReq, projectId :  String, uiViewController: UIViewController) {
        
        Log.s(object: self, message: "Execute authentication Request")
        self.uiViewController = uiViewController
        
        // Setup SDK Authentication Request Parameters
        let authRequestParams: ults_AuthenticationRequestParameters = self.sdkTransaction!.getAuthenticationRequestParameters()
        let encryptedDeviceInfo: String = authRequestParams.getDeviceData()
        let sdkTransactionId : String = authRequestParams.getSDKTransactionID()
        let sdkEphemeralPublicKey : String = authRequestParams.getSDKEphemeralPublicKey()
        let sdkReferenceNumber : String = authRequestParams.getSDKReferenceNumber()
        let sdkAppID : String = authRequestParams.getSDKAppID()
        
        pAreq.sdkTransID = sdkTransactionId
        pAreq.sdkEphemPubKey = Mapper<SdkEphemPubKey>().map(JSONString: sdkEphemeralPublicKey)
        pAreq.sdkReferenceNumber = sdkReferenceNumber
        pAreq.sdkAppID = sdkAppID
        pAreq.sdkEncData = encryptedDeviceInfo
        pAreq.sdkMaxTimeout = "05"
        pAreq.threeDSRequestorAuthenticationInd = "01"
        
        Log.i(object: self, message: "10. RequesterConnector - areqRequest")
        areqAresRequest = RequesterConnector(delegate: self, projectId: projectId, pAreq: pAreq)
        areqAresRequest?.areqRequest()
    }
    
    /*
     * AReq/ARes Callbacks
     */
    func onFailure(errorMessage: String) {
        Log.e(object: self, message: "onFailure \(errorMessage)")
        testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtAReqError)
    }
    
    func onResponse(responseObject: NSObject) {
        areqAresRequest = nil
        if (testCaseRunner.tcMessage != nil) {
            handleResponse(responseObject: responseObject)
        }
    }
    
    func handleResponse (responseObject: NSObject){
        Log.i(object: self, message: "11. handle response")
        
        if (testCaseRunner.tcMessage != nil) {
            
            self.isChallengeTransaction = false
            let aRes = responseObject as! ARes

            psrqMessage = PSrq()
            psrqMessage?.messageVersion = aRes.messageVersion
            psrqMessage?.threeDSServerTransID = aRes.threeDSServerTransID
            psrqMessage?.p_messageVersion = aRes.p_messageVersion

            if (aRes.transStatus != nil){
                Log.i(object: self, message: "handle response for transStatus= \(aRes.transStatus!)")
            }
            
            switch (aRes.transStatus) {
                case "C"?:
                    Log.i(object: self, message: "12. create challenge parameters")
                    let challengeParameters = createChallengeParameters(aRes: aRes)
                    self.isChallengeTransaction = true
                    let timeout : Int32 =  5
                    SDKChallengeDataProtocol.instance.challengeIteration = 0
                    executeChallenge(delegate: self, challengeParameters: challengeParameters , timeout: timeout)
                
                case "Y"?:
                    testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtFrictionlessStatusY)
                case "A"?:
                    testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtFrictionlessStatusA)
                case "N"?:
                    testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtFrictionlessStatusN)
                case "U"?:
                    testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtFrictionlessStatusU)
                case "R"?:
                    testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtFrictionlessStatusR)
                default:
                    testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtFrictionlessStatusD)
                }
        }
    }
    
    func createChallengeParameters(aRes: ARes) -> ults_ChallengeParameters{
        let challengeParameters = factory.newChallengeParameters()
        challengeParameters.setAcsSignedContent(aRes.acsSignedContent!)
        challengeParameters.setAcsRefNumber(aRes.acsReferenceNumber!)
        challengeParameters.setAcsTransactionID(aRes.acsTransID!)
        challengeParameters.set3DSServerTransactionID(aRes.threeDSServerTransID!)
        //challengeParameters.acsRenderingType = aRes.acsRenderingType?.uiType
        return challengeParameters
    }
    
    func onErrorResponse(errorMessage: String) {
        Log.e(object: self, message: "onErrorResponse \(errorMessage)")
        testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtAResError)
    }
    
    /*
     * Execute Challenge
     */
    func executeChallenge(delegate : ults_ChallengeStatusReceiver ,challengeParameters : ults_ChallengeParameters, timeout : Int32) {
       
        DispatchQueue.main.async(){
            do {
                Log.s(object: self, message: "Execute challenge")
                try self.sdkTransaction!.doChallenge(nil,challengeParameters, delegate, Int(timeout))
            } catch _ {
                self.sdkRuntimeException()
            }
        }
    }
    
    /*
     * CReq/CRes Callbacks
     */
    public func completed(_ e: ults_CompletionEvent) {
        let transactionStatus : String? = e.getTransactionStatus()
        Log.i(object: self, message: "completed ")
        var strMessage : String
        
        switch transactionStatus {
            case "Y"?:
                psrqMessage?.p_isTransactionCompleted = "true"
                strMessage = localizedStrings.txtFrictionlessStatusY
                break
            case "N"?:
                psrqMessage?.p_isTransactionCompleted = "false"
                strMessage = localizedStrings.txtFrictionlessStatusN
                break
            default:
                psrqMessage?.p_isTransactionCompleted = "false"
                strMessage = localizedStrings.txtChallengeUnknown
                break
            }
        
        testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:strMessage)
    }
    
    public func cancelled() {
        Log.w (object: self, message:  "TransactionManager - Cancelled")
        psrqMessage?.p_challengeCancel = "01"
        testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtChallengeCancelled)
    }
    
    // ults_ChallengeStatusReceiver event
    public func timedout() {
        Log.e(object: self, message: "TransactionManager - timedOut")
        psrqMessage?.p_challengeTimeout = "true"

        delegate?.errorEventReceived()
        testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtChallengeTimeout)
    }
    
    public func protocolError(_ e: ults_ProtocolErrorEvent) {
        Log.e(object: self, message: "TransactionManager - Protocol error")
        psrqMessage?.p_protocolErrorCode = e.getErrorMessage().getErrorCode()
        psrqMessage?.p_protocolErrorMessage = e.getErrorMessage().getErrorDescription()
        
        delegate?.errorEventReceived()
        testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage: localizedStrings.txtChallengeRuntimeError)
    }
    
    public func runtimeError(_ e: ults_RuntimeErrorEvent) {
        Log.e(object: self, message: "TransactionManager - run time error")
        psrqMessage?.p_runtimeErrorCode = e.getErrorCode()
        psrqMessage?.p_runtimeErrorMessage = e.getErrorMessage()
        
        delegate?.errorEventReceived()
        testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage: localizedStrings.txtChallengeRuntimeError)
    }
    
    func sdkRuntimeException() {
        Log.e(object: self, message: "TransactionManager - sdk run time exception")
        psrqMessage?.p_runtimeErrorCode = "999"
        psrqMessage?.p_runtimeErrorMessage = "SDKRuntime Exception"
        
        delegate?.errorEventReceived()
        testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage: localizedStrings.txtChallengeRuntimeError)
    }
    
    /*
     * Finish TestCase Execution and show Result Screen (!)
     */
    func testFinished(segueIdentifier: String, strTestMessage: String) {
        Log.i(object: self, message: "Test has finished")
        
        areqAresRequest = nil
        TransactionManager.sdkProgressDialog?.close()
        finishTransaction()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if (self.testCaseRunner.hasNextPareq()) {
                Log.i(object: self, message: "16. start transaction")
                self.testCaseRunner.startTransaction(uiViewController: self.uiViewController!)
            }
            else {
                Log.i(object: self, message: "17. show results")
                Emvco3dsFramework.resultsViewController?.notify()
            }
        }
    }
   
    func finishTransaction() {
        Log.i(object: self, message: "15. Finish transaction")
        
        do {
            SDKChallengeDataProtocol.instance.challengeIteration = 0
            if (!isChallengeTransaction!) {
                Log.i(object: self, message: "close transaction")
                try self.sdkTransaction!.close()
            }
            Log.i(object: self, message: "clean up")
            if (self.isSdkInitialized) {
                try self.service?.cleanup(nil)
                self.isSdkInitialized = false
            }
        } catch _ {
            Log.e(object: self, message: "Error on closing SDK transaction")
        }
    }
}

