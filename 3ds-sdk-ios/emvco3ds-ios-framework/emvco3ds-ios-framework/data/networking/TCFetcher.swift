//  TCFetcher.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class TCFetcher<T : TestCaseDownloaderProtocol>: AbstractNetworkRequest {
    
    @objc let tagDelete = "deleteTestCases"
    @objc let tagFetch = "fetchTestCases"
    @objc let errorTooManyRequests = 429
    
    let delegate : T
    
    init(delegate: T) {
        self.delegate = delegate
    }
    
    @objc func deleteAllTestCases(apiKey : String) {
        
        let url = NSURL(string : "\(TCFetcher.getDeleteAllURL())?apiKey=\(apiKey)")! as URL
        Log.i(object: self, message: url.description)
        delete(url: url, tag: tagDelete)
    }
    
    private static func getFetchURL() -> String {
        return "\(getBaseURL())\(ConfigurationManager.RAS_FETCH_TC_MESSAGE_ENDPOINT)"
    }
    
    private static func getDeleteAllURL() -> String {
        return "\(getBaseURL())\(ConfigurationManager.RAS_DELETE_ALL_TC_MESSAGES_ENDPOINT)"
    }
    
    private static func getBaseURL () -> String {
        return "\(ConfigurationManager.PROTOCOL)://\(ConfigurationManager.REFERENCE_APP_SERVER_IP):\(ConfigurationManager.REFERENCE_APP_SERVER_PORT)"
    }
    
    @objc var apiKey: String? = nil
    
    @objc func fetch(apiKey : String) -> Bool {
        let url = NSURL(string : "\(TCFetcher.getFetchURL())?apiKey=\(apiKey)")! as URL
        Log.i(object: self, message: url.description)
        
        let headers : HTTPHeaders  = [ConfigurationManager.SDK_VENDOR_HEADER_KEY : ConfigurationManager.SDK_VENDOR_KEY_VALUE]
        self.apiKey = apiKey
        let message : TcMessage? = get(url: url, tag: tagFetch, headers: headers)
        let isFound = message?.header?.isFound
        return (isFound == true)
    }
    
    override func abstractOnResult(tag:String?){
        Log.i(object: self, message: "on result")
    }
    
    override func abstractOnError(tag:String?, errorMessage:String, statusCode: Int?){
        if (statusCode == self.errorTooManyRequests && self.apiKey != nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let result = self.fetch(apiKey: self.apiKey!)
                print ("fetch result \(result)")
            }
        }
        else{
            if (tag == self.tagDelete){
                self.delegate.onError(message: "An error happened, check the log!")
            }
            else{
                self.delegate.onNetworkError()
            }
        }
    }
    
    override func abstractOnSuccess (tag:String?, response: Any?, urlResponse : HTTPURLResponse? = nil ){
        if (tag == tagDelete){
            Log.i(object: self, message: "successfully deleted the testcases.")
            self.delegate.onSuccessfullyDeleteAllTestCases()
        }
        
        if (tag == tagFetch){
            Log.i(object: self, message: "Successfully fetched testcases")
            let tcMessage = response as? TcMessage
            if (tcMessage != nil){
                self.delegate.onSuccessfullyFetchedTcMessage(tcMessage: tcMessage!)
            }
        }
    }
}

