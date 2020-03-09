//  AbstractNetRequest.swift
//  emvco3ds-ios-app
//  Created by Virendra patil on 15/02/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.


import UIKit
import Alamofire
import ObjectMapper
import emvco3ds_ios_framework
import emvco3ds_protocols_ios

class AbstractNetRequest: NSObject {
    
    
    
    var acsURL = ""
    let preconditionWarning = "This method must be overridden"
    let networkManager = NetworkManager()
    
    var transation : Transaction? = nil
    var challengeParameters : ults_ChallengeParameters?
    var challengeStatusReceiver : ults_ChallengeStatusReceiver?
    var cUI : UIViewController?
    
    func get<T: Mappable> (url: URL, tag: String?, headers: HTTPHeaders?)->T?{
        Log.i(object: self, message: "Abstract get "+url.absoluteString)
        networkManager.sessionManager.request(url,  headers: headers).responseObject { (response: DataResponse<T>) in
            Log.i(object: self, message: "Abstract get response received")
            self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
            self.handleSuccessIfAny(tag:tag, response: response, urlResponse : response.response)
        }
        return nil
    }
    
    
    func delete(url: URL, tag: String?) {
        let headers : HTTPHeaders  = ["method": "DELETE"]
        networkManager.sessionManager.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers).response{
            response in
            self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
            self.showResponse(data: response.data)
            self.handleDefaultSucessIfAny(tag:tag, response: response)
            }.validate(statusCode: 200 ..< 300)
    }
    
    
    func post<T: Mappable>(stringData: String, url: String, tag: String? = nil)->T?{
        let postHeaders : HTTPHeaders  = ["content-type" : "application/json;charset=UTF-8"]
        let data = stringData.data(using: .utf8)!
        networkManager.sessionManager.upload(data, to: url ,method : Alamofire.HTTPMethod.post, headers: postHeaders).responseObject{
            (response: DataResponse<T>)  in
            self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
            self.handleSuccessIfAny(tag:tag, response: response, urlResponse : response.response)
            }.validate(statusCode: 200 ..< 300)
        return nil
    }
    
    
    func post(stringData: String, url: String, tag: String? = nil , transation : Transaction , challengeParameters: ults_ChallengeParameters, challengeStatusReceiver: ults_ChallengeStatusReceiver , ui: UIViewController?) {
        self.acsURL = url
        let postHeaders : HTTPHeaders  = ["content-type" : "application/jose;charset=UTF-8", "method": "POST"]
        let data = stringData.data(using: .utf8)!
        self.transation = transation
        self.challengeParameters = challengeParameters
        self.challengeStatusReceiver = challengeStatusReceiver
        self.cUI = ui
        networkManager.sessionManager.upload(data, to: url ,method : Alamofire.HTTPMethod.post, headers: postHeaders).response{
            response in
            //print(response.timeline)
            self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
            self.showResponse(data: response.data)
            self.handleDefaultSucessIfAny(tag:tag, response: response)
            }.validate(statusCode: 200 ..< 300)
    }
    
    
    func handleResponse(tag: String? , httpUrlResponse:HTTPURLResponse?, error: Error?) {
        Log.i(object: self, message: "Abstract handle response")
        //self.abstractOnResult(tag: tag)
        self.showResponseCode(httpUrlResponse: httpUrlResponse)
        self.handleErrorIfAny(tag: tag, error: error, response: httpUrlResponse )
    }
    
    
    func handleDefaultSucessIfAny(tag:String? , response: DefaultDataResponse) {
        let error = response.error
        if (error == nil) {
            self.abstractOnSuccess(tag: tag, response: nil)
        }
    }
    
    
    func handleSuccessIfAny<T>(tag:String? , response: DataResponse<T>, urlResponse :HTTPURLResponse?) {
        Log.i(object: self, message: "Abstract handle success")
        let error = response.error
        if (error == nil) {
            self.abstractOnSuccess(tag: tag, response: response.result.value)
        }
    }
    
    
    func showResponse(data: Data?) {
        if data == nil || data?.count == 0 {
            
                print("No resonse this issue")
                let errorMessage = ErrorMessage.init((self.challengeParameters?.getAcsTransactionID())!, "201", "Name of required element(s) that was omitted; if more than one element is detected, this is a comma delimited list.", "Protocol Error")
                let protocolErrorevent = ProtocolErrorEvent.init((self.challengeParameters?.getAcsTransactionID())!, errorMessage)
                challengeStatusReceiver?.protocolError(protocolErrorevent)
                let e = RuntimeErrorEvent.init("203", "Invalid Argument")
                challengeStatusReceiver!.runtimeError(e)
            
            } else {
            let responseBodyString = String(data: data!, encoding: String.Encoding.utf8)!
            Log.i(object: self, message: "\(String(describing: responseBodyString))")
            //self.cUI?.navigationController?.dismiss(animated: true, completion: nil)
            if responseBodyString != "" {
                Cres().decodeCres(respose: responseBodyString, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, acsURL: acsURL)
//            } else {
//                let errorMessage =  ErrorMessage.init((self.challengeParameters?.getAcsTransactionID())!, "201", "Tag Mismatch", "Protocol Error")
//                let protocolErrorevent = ProtocolErrorEvent.init((self.challengeParameters?.getAcsTransactionID())!, errorMessage)
//                challengeStatusReceiver?.protocolError(protocolErrorevent)
//                //let e = RuntimeErrorEvent.init("201", "Invalid Argument")
//                //challengeStatusReceiver!.runtimeError(e)
//            }
            try! transation?.close()
         
        }
            Log.i(object: self, message: "no response")
        }
        self.cUI?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func showResponseCode(httpUrlResponse: HTTPURLResponse?) {
        Log.i(object: self, message: "Abstract showResponseCode")
        let responseCode = httpUrlResponse?.statusCode
        if (responseCode != nil) {
            Log.i(object: self, message: "response code = \(responseCode!)")
        }
    }
    
    
    func handleErrorIfAny(tag:String? , error: Error?, response: HTTPURLResponse?) {
        Log.i(object: self, message: "Abstract handleErrorIfAny")
        if (error != nil) {
            Log.e(object: self, message: error.debugDescription)
            // let e = RuntimeErrorEvent.init("302", "Invalid Argument")
            // challengeStatusReceiver!.runtimeError(e)
            self.abstractOnError(tag:tag, errorMessage: error.debugDescription, statusCode: response?.statusCode)
        }
    }
    
    
    func abstractOnResult(tag:String?) {
        preconditionFailure(preconditionWarning)
    }
    
    
    func abstractOnError(tag:String?, errorMessage:String, statusCode: Int?) {
        //preconditionFailure(preconditionWarning)
    }
    
    
    func abstractOnSuccess (tag:String?, response: Any? , urlResponse : HTTPURLResponse? = nil) {
        //preconditionFailure(preconditionWarning)
    }
}

