//  CardholderNotifier.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire

class CardholderNotifier <T : CardholderNotifierProtocol>: AbstractNetworkRequest {
    let delegate : T
    init (delegate : T) {
        self.delegate = delegate
    }
    
    private func getURL (version : String, projectId : String) -> String {
        
        var url =  "\(ConfigurationManager.CARDHOLDER_ENDPOINT)\(projectId)/"
        url = url.replacingOccurrences(of: "{VERSION_VALUE}", with: "v"+version)
        return url
    }
    
    @objc func notify(pcrqMessage : PSrq, projectId : String) {
        
        let url = URL(string: getURL(version: pcrqMessage.messageVersion!, projectId: projectId))!
        let json = pcrqMessage.toJSONString()!
        Log.i(object: self, message: "pSrq = \(json)")
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        if TestCaseRunner.instance.testCaseRunId != nil {
            request.setValue(TestCaseRunner.instance.testCaseRunId , forHTTPHeaderField: TestCaseRunner.header.testCaseRunId)
        }
        
        if TestCaseRunner.instance.testCaseId != nil {
            request.setValue(TestCaseRunner.instance.testCaseId, forHTTPHeaderField: TestCaseRunner.header.testCaseId)
        }

        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON {
            (response) in
           
            let responseCode = response.response?.statusCode
           
            if (responseCode != nil) {
                Log.i(object: self, message: "response code = \(responseCode!)")
            }
            
            let responseBody = response.data
           
            if (responseBody != nil) {
                let responseBodyString = String(data: responseBody!, encoding: String.Encoding.utf8)!
                Log.i(object: self, message: "pSrs = " + (String(describing: responseBodyString)))
            }
            
            let error = response.error
            
            if (error != nil) {
                self.delegate.onErrorCardholderServer(message: "Error!! Check the log")
            }
            else{
                self.delegate.onSuccessfullyCardholderServerNotified()
            }
        }.validate(statusCode: 200 ..< 300)
    }
}

