//  TestManagementNotifier.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire

class TestManagementNotifier <T : TestManagementNotifierProtocol>: AbstractNetworkRequest {
    let delegate : T
    
    init (delegate : T) {
        self.delegate = delegate
    }
    
    private  func getURL () -> String {
        return "\(ConfigurationManager.PROTOCOL)://\(ConfigurationManager.REFERENCE_APP_SERVER_IP):\(ConfigurationManager.REFERENCE_APP_SERVER_PORT)\(ConfigurationManager.RAS_NOTIFY_TEST_MANAEGMENT_ENDPOINT)"
    }
    
    override func abstractOnResult(tag:String?){
        Log.i(object: self, message: "Result retrieved")
    }
    
    override func abstractOnError(tag:String?, errorMessage:String, statusCode: Int?){
        Log.e(object: self, message: "Sending results  failed: \(errorMessage)")
        self.delegate.onError(message: "Error!! Check the log")
    }
    
    override func abstractOnSuccess (tag:String?, response: Any?, urlResponse : HTTPURLResponse? = nil ){
         Log.s(object: self, message: "Sending results To UL Test platform succeeded.")
         self.delegate.onSuccessfullyNotified()
    }
    
    @objc public func notify(tmNotifier: TMNotifier) {
        
        Log.i(object: self, message: "Sending results to UL Test Platform")
        let body = tmNotifier.toJSONString()!
        Log.i(object: self, message: "request body =\(body)")
        post( stringData: body, url:getURL(), tag : "notify")
    }
}
