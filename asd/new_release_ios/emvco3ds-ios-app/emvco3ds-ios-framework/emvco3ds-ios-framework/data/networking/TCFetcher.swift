//  TCFetcher.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class TCFetcher<T : TestCaseDownloaderProtocol>: AbstractNetworkRequest {
    
    let tagDelete = "deleteTestCases"
    let tagFetch = "fetchTestCases"
    let ErrorTooManyRequests = 429
    
    let delegate : T
    
    init(delegate: T) {
        self.delegate = delegate
    }
    
    func deleteAllTestCases(apiKey : String) {
        
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
    
   
    
    var apiKey: String? = nil
    
    func fetch(apiKey : String) {
        let url = NSURL(string : "\(TCFetcher.getFetchURL())?apiKey=\(apiKey)")! as URL
        Log.i(object: self, message: url.description)
        
        let headers : HTTPHeaders  = [ConfigurationManager.SDK_VENDOR_HEADER_KEY : ConfigurationManager.SDK_VENDOR_KEY_VALUE]
        self.apiKey = apiKey
        
        let _: TcMessage? = get(url: url, tag: tagFetch, headers: headers)
    }
    
    override func abstractOnResult(tag:String?){
        Log.i(object: self, message: "on result")
    }
    
    override func abstractOnError(tag:String?, errorMessage:String, statusCode: Int?){
        if (statusCode == self.ErrorTooManyRequests && self.apiKey != nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.fetch(apiKey: self.apiKey!)
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

