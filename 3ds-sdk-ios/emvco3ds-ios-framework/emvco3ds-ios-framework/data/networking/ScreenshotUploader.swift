//
//  ScreenshotUploader.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire

class ScreenshotUploader<T : ScreenshotUploadProtocol>: AbstractNetworkRequest {
    
    let delegate : T
    @objc let screenshotMessage : ScreenshotMessage
    @objc let myActivityIndicator: UIActivityIndicatorView
    
    init(delegate: T, screenshotMessage : ScreenshotMessage, myActivityIndicator : UIActivityIndicatorView ) {
        self.delegate = delegate
        self.screenshotMessage = screenshotMessage
        self.myActivityIndicator = myActivityIndicator
    }
    
    private  func getURL() -> String {
        return "\(ConfigurationManager.PROTOCOL)://\(ConfigurationManager.REFERENCE_APP_SERVER_IP):\(ConfigurationManager.REFERENCE_APP_SERVER_PORT)\(ConfigurationManager.REFERENCE_APP_SERVER_SCREENSHOT_ENDPOINT)"
    }
    
    override func abstractOnResult(tag:String?){
        DispatchQueue.main.async() {
             self.myActivityIndicator.stopAnimating()
        }
    }
    
    override func abstractOnError(tag:String?, errorMessage:String, statusCode: Int?){
         Log.e(object: self, message: "Screenshot upload failed")
         self.delegate.onError(message: errorMessage)
    }
    
    override func abstractOnSuccess (tag:String?, response: Any?, urlResponse : HTTPURLResponse? = nil ){
        Log.s (object: self, message: "Screenshot uploaded")
        self.delegate.onSuccessfull(message: "Uploaded is successful!")
    }
    
    @objc func upload (screenshot : UIImage){
        Log.i(object: self, message: "Preparing screenshot")
        let imageData = screenshot.pngData()!
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        screenshotMessage.base64String = strBase64
        let body = screenshotMessage.toJSONString()!
        Log.i(object: self, message: "Sending screenshot")
        post(stringData: body, url: getURL())
    }
}

