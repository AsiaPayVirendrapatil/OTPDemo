//  TransactionManager.swift
//  emvco3ds-ios-app
//  Copyright © 2017 UL Transaction Security All rights reserved.

import UIKit
import ObjectMapper


public protocol TransactionManagerDelegate: class {
    func errorEventReceived()
}

public class TransactionManager: NSObject, ults_ChallengeStatusReceiver, GenericNetworkProtocol {
    public func nothingFonaHappended() {
        
    }
    
    
    @objc let TESTPLAN_2_2_PLUS = "2.2"
    @objc let REF_APP_LINK = "com.ul-ts.emvco3ds-ios-app://?transID="
    @objc let HEADER_LABEL = "SECURE CHECKOUT"
    @objc let TOOLBAR_BACKGROUND = "#83ADD7"
    
    @objc static let instance = TransactionManager()
    static var sdkProgressDialog: ults_ProgressView? = nil
    var service: ults_ThreeDS2Service? = nil
    var sdkTransaction: ults_Transaction? = nil
    @objc var isSdkInitialized: Bool = false
    @objc var psrqMessage : PSrq?
    var isChallengeTransaction : Bool? = false
    @objc var uiViewController: UIViewController?
    
    //let factory =  Emvco3dsFramework.factory // Factory()
    
    let factory = SampleFactory()
    
    @objc var areqAresRequest : RequesterConnector? = nil
    
    weak var delegate: TransactionManagerDelegate?
    
    @objc public func getSdkVersion() -> String {
        var result = "(Unknown)"
        self.initSdkOnce()
        if (service != nil){
            try? result = service!.getSDKVersion()
        }
        return result
    }
    
    public func Laodsdk(pareq : PAReq)  {
        
        let transactionManager : TransactionManager = TransactionManager.instance
        transactionManager.initializeSdk()
        TransactionManager.sdkProgressDialog?.show()
        
        //let pAreq = self.tcMessage?.pAReqFields![self.paIdx]
        //pAreq?.p_testCaseRunId = self.tcMessage?.header?.pAreqId
        //projectId = self.tcMessage?.header!.projectId!
        
        //Log.i(object: self, message: "Executing pAReq \(self.paIdx+1) of \(self.tcMessage?.pAReqFields?.count ?? 0)")
        transactionManager.startAResAResFlow(pAreq: pareq, projectId: "830", uiViewController: UIViewController.init())
        
    }
//        @objc public func startTransaction(uiViewController : UIViewController) {
//
//            Log.i(object: self, message: "Start transaction")
//            let transactionManager : TransactionManager = TransactionManager.instance
//            transactionManager.initializeSdk()
//            TransactionManager.sdkProgressDialog?.show()
//
//            let pAreq = self.tcMessage?.pAReqFields![self.paIdx]
//            pAreq?.p_testCaseRunId = self.tcMessage?.header?.pAreqId
//            projectId = self.tcMessage?.header!.projectId!
//
//            Log.i(object: self, message: "Executing pAReq \(self.paIdx+1) of \(self.tcMessage?.pAReqFields?.count ?? 0)")
//            transactionManager.startAResAResFlow(pAreq: pAreq!, projectId: projectId!, uiViewController: uiViewController)
//
//        }
    @objc public func initializeSdk() {
        do {
            initSdkOnce()
            
            self.sdkTransaction = try self.service?.createTransaction("F000000000", "2.1.0")
            //TransactionManager.sdkProgressDialog = try self.sdkTransaction!.getProgressView(nil)
        }
        catch _ {
        }
    }
    
    @objc func initSdkOnce(){
        do {
            if (!self.isSdkInitialized){
                let config = factory.newConfigParameters()
                self.service = factory.newThreeDS2Service()
                let uiConfig = factory.newUiCustomization()
                // Customize Challenge Header Text
                //let toolbarCustomization = factory.newToolbarCustomization()
                //try? toolbarCustomization.setHeaderText(HEADER_LABEL)
                //try? toolbarCustomization.setBackgroundColor(TOOLBAR_BACKGROUND)
                //try? uiConfig.setToolbarCustomization(toolbarCustomization)
                
                let locale = NSLocale.autoupdatingCurrent.languageCode! + "-" + NSLocale.autoupdatingCurrent.regionCode!
                try self.service!.initialize(nil, config, locale, uiConfig)
                self.isSdkInitialized = true
            }
            else {
            }
        }
        catch _ {
        }
    }
    
    /*
     * Execute Authentication Request
     */
    @objc public func startAResAResFlow(pAreq : PAReq, projectId :  String, uiViewController: UIViewController) {
        
        self.uiViewController = uiViewController
        
        // Setup SDK Authentication Request Parameters
        let authRequestParams: ults_AuthenticationRequestParameters = try! self.sdkTransaction!.getAuthenticationRequestParameters()
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
        
        areqAresRequest = RequesterConnector(delegate: self, projectId: projectId, pAreq: pAreq)
        areqAresRequest?.areqRequest()
    }
    
    /*
     * AReq/ARes Callbacks
     */
    @objc public func onFailure(errorMessage: String) {
        //testFinished(segueIdentifier:SegueIdentifers.showResults, strTestMessage:localizedStrings.txtAReqError)
    }
    
    @objc public func onResponse(responseObject: NSObject) {
        areqAresRequest = nil
        //        if (testCaseRunner.tcMessage != nil) {
        handleResponse(responseObject: responseObject)
        //        }
    }
    
    @objc func handleResponse (responseObject: NSObject){
        
        //if (testCaseRunner.tcMessage != nil) {
        
        self.isChallengeTransaction = false
        let aRes = responseObject as! ARes
        
        psrqMessage = PSrq()
        psrqMessage?.messageVersion = aRes.messageVersion
        psrqMessage?.threeDSServerTransID = aRes.threeDSServerTransID
        psrqMessage?.p_messageVersion = aRes.p_messageVersion
        
        if (aRes.transStatus != nil){
        }
        
        switch (aRes.transStatus) {
        case "C"?:
            let challengeParameters = createChallengeParameters(aRes: aRes)
            self.isChallengeTransaction = true
            let timeout : Int32 =  5
            //SDKChallengeDataProtocol.instance.challengeIteration = 0
            executeChallenge(delegate: self, challengeParameters: challengeParameters , timeout: timeout)
            
        case "Y"?:
            testFinished()
        case "A"?:
            testFinished()
        case "N"?:
            testFinished()
        case "U"?:
            testFinished()
        case "R"?:
            testFinished()
        default:
            testFinished()
        }
        //}
    }
    
    func createChallengeParameters(aRes: ARes) -> ults_ChallengeParameters{
        let challengeParameters = factory.newChallengeParameters()
        challengeParameters.setAcsSignedContent(aRes.acsSignedContent!)
        challengeParameters.setAcsRefNumber(aRes.acsReferenceNumber!)
        challengeParameters.setAcsTransactionID(aRes.acsTransID!)
        challengeParameters.set3DSServerTransactionID(aRes.threeDSServerTransID!)
        //challengeParameters.acsRenderingType = aRes.acsRenderingType?.uiType
        
        let autParams = try! self.sdkTransaction?.getAuthenticationRequestParameters()
        let SDKTransactionId = autParams?.getSDKTransactionID()
        if (SDKTransactionId != nil){
            challengeParameters.setThreeDSRequestorAppURL("\(REF_APP_LINK)\(SDKTransactionId!)")
        }
        return challengeParameters
    }
    
    @objc public func onErrorResponse(errorMessage: String) {

    }
    
    /*
     * Execute Challenge
     */
    func executeChallenge(delegate : ults_ChallengeStatusReceiver ,challengeParameters : ults_ChallengeParameters, timeout : Int32) {
        
        DispatchQueue.main.async(){
            do {
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
        var strMessage : String
        
        switch transactionStatus {
        case "Y"?:
            psrqMessage?.p_isTransactionCompleted = "true"
        case "N"?:
            psrqMessage?.p_isTransactionCompleted = "false"
        default:
            psrqMessage?.p_isTransactionCompleted = "false"
        }
        
    }
    
    @objc public func cancelled() {
        psrqMessage?.p_challengeCancel = "01"
    }
    
    // ults_ChallengeStatusReceiver event
    @objc public func timedout() {
        psrqMessage?.p_challengeTimeout = "true"
        delegate?.errorEventReceived()
    }
    
    public func protocolError(_ e: ults_ProtocolErrorEvent) {
        psrqMessage?.p_protocolErrorCode = e.getErrorMessage().getErrorCode()
        psrqMessage?.p_protocolErrorMessage = e.getErrorMessage().getErrorDescription()
        
        delegate?.errorEventReceived()
    }
    
    public func runtimeError(_ e: ults_RuntimeErrorEvent) {
        psrqMessage?.p_runtimeErrorCode = e.getErrorCode()
        psrqMessage?.p_runtimeErrorMessage = e.getErrorMessage()
        
        delegate?.errorEventReceived()
    }
    
    @objc func sdkRuntimeException() {
        psrqMessage?.p_runtimeErrorCode = "999"
        psrqMessage?.p_runtimeErrorMessage = "SDKRuntime Exception"
        
        delegate?.errorEventReceived()
    }
    
    /*
     * Finish TestCase Execution and show Result Screen (!)
     */
    @objc func testFinished() {
        areqAresRequest = nil
        TransactionManager.sdkProgressDialog?.close()
        finishTransaction()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //            if (self.testCaseRunner.hasNextPareq()) {
            //                self.testCaseRunner.startTransaction(uiViewController: self.uiViewController!)
            //            }
            //            else {
            //                Emvco3dsFramework.resultsViewController?.notify()
            //            }
        }
    }
    
    @objc func finishTransaction() {
        do {
            if (!isChallengeTransaction!) {
                try self.sdkTransaction!.close()
            }
            if (self.isSdkInitialized) {
                try self.service?.cleanup(nil)
                self.isSdkInitialized = false
            }
        } catch _ {
        }
    }
}


