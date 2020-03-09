//  BaseNetworkRequest.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire
import ObjectMapper

public class AbstractNetworkRequest: NSObject {
    var acsURL = ""
    var transation : Transaction? = nil
    var challengeParameters : ults_ChallengeParameters?
    var challengeStatusReceiver : ults_ChallengeStatusReceiver?
    var cUI : UIViewController?

    @objc let preconditionWarning = "This method must be overridden"
    @objc let networkManager = NetworkManager()

    func get<T: Mappable> (url: URL, tag: String?, headers: HTTPHeaders?)->T?{

        networkManager.sessionManager.request(url,  headers: headers).responseObject { (response: DataResponse<T>) in
            self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
            self.handleSuccessIfAny(tag:tag, response: response, urlResponse : response.response)
        }

        return nil
    }

    @objc func delete(url: URL, tag: String?){
        let headers : HTTPHeaders  = ["method": "DELETE"]
        networkManager.sessionManager.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers).response{
            response in
            self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
            self.showResponse(data: response.data)
            self.handleDefaultSucessIfAny(tag:tag, response: response)

        }.validate(statusCode: 200 ..< 300)
    }

  public func post<T: Mappable>(stringData: String, url: String, tag: String? = nil)->T?{
        let postHeaders : HTTPHeaders  = ["content-type" : "application/json;charset=UTF-8"]
        let data = stringData.data(using: .utf8)!

        networkManager.sessionManager.upload(data, to: url ,method : Alamofire.HTTPMethod.post, headers: postHeaders).responseObject{
            (response: DataResponse<T>)  in
            self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
            self.showResponse(data: response.data)
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
        networkManager.sessionManager.upload(data, to: url ,method : Alamofire.HTTPMethod.post, headers: postHeaders).response { response in
            if response.timeline.requestDuration > 11 {
                let err = ErrorCReq.init(threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: "402", errorDescription: "Timeout", errorDetail: "Timeout", message: "")
                APICall.shared.postError(stringData:err.toJson() , url: self.acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
                let e = RuntimeErrorEvent.init("402", "Timeout")
                challengeStatusReceiver.runtimeError(e)
                //challengeStatusReceiver.timedout()
            } else {
                self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
                self.showResponse1(data: response.data)
                self.handleDefaultSucessIfAny(tag:tag, response: response)
            }
            }.validate(statusCode: 200 ..< 300)
    }

    func showResponse1(data: Data?) {
        if data == nil || data?.count == 0 {
            print("No resonse this issue")
            let errorMessage = ErrorMessage.init((self.challengeParameters?.getAcsTransactionID())!, "201", "Name of required element(s) that was omitted; if more than one element is detected, this is a comma delimited list.", "Protocol Error")
            let protocolErrorevent = ProtocolErrorEvent.init((self.challengeParameters?.getAcsTransactionID())!, errorMessage)
            challengeStatusReceiver?.protocolError(protocolErrorevent)
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver!.runtimeError(e)
        } else {
            let responseBodyString = String(data: data!, encoding: String.Encoding.utf8)!
            if responseBodyString != "" {
                print("responseBodyString ---->\(responseBodyString)")
                Cres.shared.SdkCounterStoA = (transation?.challengeNo)!
                Cres.shared.decodeCres(respose: responseBodyString, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, acsURL: acsURL)
                //} else {
                //let errorMessage =  ErrorMessage.init((self.challengeParameters?.getAcsTransactionID())!, "201", "Tag Mismatch", "Protocol Error")
                //let protocolErrorevent = ProtocolErrorEvent.init((self.challengeParameters?.getAcsTransactionID())!, errorMessage)
                //challengeStatusReceiver?.protocolError(protocolErrorevent)
                //let e = RuntimeErrorEvent.init("201", "Invalid Argument")
                //challengeStatusReceiver!.runtimeError(e)
                //}
                try! transation?.close()
            }
        }
    }
    
    @objc func post(stringData: String, url: String, tag: String? = nil){
        let postHeaders : HTTPHeaders  = ["content-type" : "application/json", "method": "POST"]
        let data = stringData.data(using: .utf8)!

        networkManager.sessionManager.upload(data, to: url ,method : Alamofire.HTTPMethod.post, headers: postHeaders).response{
            response in
             self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
             self.showResponse(data: response.data)
             self.handleDefaultSucessIfAny(tag:tag, response: response)
        }.validate(statusCode: 200 ..< 300)
    }

    @objc func handleResponse(tag: String? , httpUrlResponse:HTTPURLResponse?, error: Error?){
        self.abstractOnResult(tag: tag)
        self.showResponseCode(httpUrlResponse: httpUrlResponse)
        self.handleErrorIfAny(tag: tag, error: error, response: httpUrlResponse )
    }

    func handleDefaultSucessIfAny(tag:String? , response: DefaultDataResponse){
        let error = response.error
        if (error == nil){
            self.abstractOnSuccess(tag: tag, response: nil)
        }
    }

    func handleSuccessIfAny<T>(tag:String? , response: DataResponse<T>, urlResponse :HTTPURLResponse?){
        let error = response.error
        if (error == nil){
            self.abstractOnSuccess(tag: tag, response: response.result.value)
        }
    }

    @objc func showResponse(data: Data?){
        if (data != nil) {
            let responseBodyString = String(data: data!, encoding: String.Encoding.utf8)!
            print(responseBodyString)
        }
        else{
        }
    }
    @objc func showResponseCode(httpUrlResponse: HTTPURLResponse?){
        let responseCode = httpUrlResponse?.statusCode
        if (responseCode != nil) {
        }
    }

    @objc func handleErrorIfAny(tag:String? , error: Error?, response: HTTPURLResponse?){
        if (error != nil) {
            self.abstractOnError(tag:tag, errorMessage: error.debugDescription, statusCode: response?.statusCode)
        }
    }

    @objc func abstractOnResult(tag:String?){
        //preconditionFailure(preconditionWarning)
    }

    func abstractOnError(tag:String?, errorMessage:String, statusCode: Int?){
         //preconditionFailure(preconditionWarning)
    }

    @objc func abstractOnSuccess (tag:String?, response: Any? , urlResponse : HTTPURLResponse? = nil){
          //preconditionFailure(preconditionWarning)
    }
}
