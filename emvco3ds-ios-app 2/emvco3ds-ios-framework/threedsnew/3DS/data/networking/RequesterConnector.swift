//  RequesterConnector.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire
import AlamofireObjectMapper

public class RequesterConnector: AbstractNetworkRequest {
    
    let delegate : GenericNetworkProtocol
    @objc let projectId : String
    public let pAreq : PAReq
    
   public init(delegate: GenericNetworkProtocol, projectId : String, pAreq: PAReq) {
        self.delegate = delegate
        self.projectId = projectId
        self.pAreq = pAreq
    }
    
    private  func getURL (version : String) -> String {
        var url = "https://simulator-3ds.selftestplatform.com/{VERSION_VALUE}/3dsServer/"
        //"\(ConfigurationManager.THREE_DS_SERVER_ENDPOINT)\(projectId)/"
        url = url.replacingOccurrences(of: "{VERSION_VALUE}", with: "v"+version)
        return url
    }
    
   public func areqRequest() {
        //if (TestCaseRunner.instance.tcMessage != nil) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            let body = pAreq.toJSONString()!
            let _: ARes? =  post(stringData: body, url: getURL(version: pAreq.messageVersion!) ,  tag: "areqrequest")
//        }
//        else {
//        }
    }
    
    override func abstractOnResult(tag:String?){
        DispatchQueue.main.async() {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    override func abstractOnError(tag:String?, errorMessage:String, statusCode: Int?){
        self.delegate.onFailure(errorMessage: errorMessage)
    }
    
    override func abstractOnSuccess (tag:String?, response: Any?, urlResponse : HTTPURLResponse? = nil ){
        let aRes = response as? ARes
        if (aRes != nil){
            self.handleResult(aRes: aRes!, urlResponse: urlResponse)
        }
    }
    
    private func handleResult(aRes: ARes, urlResponse : HTTPURLResponse? = nil){
    
        if (aRes.errorCode != nil) {
            self.delegate.onErrorResponse(errorMessage: "Received Error on ARes")
        }
        else{
//            if let testCaseRunId = urlResponse?.allHeaderFields[TestCaseRunner.header.testCaseRunId] as? String {
//                TestCaseRunner.instance.testCaseRunId = testCaseRunId
//            }
//            if let testCaseId = urlResponse?.allHeaderFields[TestCaseRunner.header.testCaseId] as? String {
//                TestCaseRunner.instance.testCaseId = testCaseId
//            }
            self.delegate.onResponse(responseObject: aRes)
        }
    }

    deinit {
     }
}
