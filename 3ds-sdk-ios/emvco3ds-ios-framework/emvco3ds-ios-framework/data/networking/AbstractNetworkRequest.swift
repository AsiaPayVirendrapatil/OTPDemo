//  BaseNetworkRequest.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire
import ObjectMapper

class AbstractNetworkRequest: NSObject {
    
    @objc let preconditionWarning = "This method must be overridden"
    @objc let networkManager = NetworkManager()
    
    func get<T: Mappable> (url: URL, tag: String?, headers: HTTPHeaders?)->T?{
        Log.i(object: self, message: "Abstract get "+url.absoluteString)
        
        networkManager.sessionManager.request(url,  headers: headers).responseObject { (response: DataResponse<T>) in
            Log.i(object: self, message: "Abstract get response received")
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
        Log.i(object: self, message: "Abstract handle response")
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
        Log.i(object: self, message: "Abstract handle success")
        let error = response.error
        if (error == nil){
            self.abstractOnSuccess(tag: tag, response: response.result.value)
        }
    }
    
    @objc func showResponse(data: Data?){
        if (data != nil) {
            let responseBodyString = String(data: data!, encoding: String.Encoding.utf8)!
            Log.i(object: self, message: "\(String(describing: responseBodyString))")
        }
        else{
            Log.i(object: self, message: "no response")
        }
    }
    @objc func showResponseCode(httpUrlResponse: HTTPURLResponse?){
        Log.i(object: self, message: "Abstract showResponseCode")
        let responseCode = httpUrlResponse?.statusCode
        if (responseCode != nil) {
            Log.i(object: self, message: "response code = \(responseCode!)")
        }
    }
    
    @objc func handleErrorIfAny(tag:String? , error: Error?, response: HTTPURLResponse?){
        Log.i(object: self, message: "Abstract handleErrorIfAny")
        if (error != nil) {
            Log.e(object: self, message: error.debugDescription)
            self.abstractOnError(tag:tag, errorMessage: error.debugDescription, statusCode: response?.statusCode)
        }
    }
    
    @objc func abstractOnResult(tag:String?){
        preconditionFailure(preconditionWarning)
    }
    
    func abstractOnError(tag:String?, errorMessage:String, statusCode: Int?){
         preconditionFailure(preconditionWarning)
    }
    
    @objc func abstractOnSuccess (tag:String?, response: Any? , urlResponse : HTTPURLResponse? = nil){
          preconditionFailure(preconditionWarning)
    }
    
}
