//
//  VViewController.swift
//  emvco3ds-ios-app
//
//  Created by Vaibhav on 10/01/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.

import UIKit
import Foundation
import CryptoSwift
import NVActivityIndicatorView


class AuthenticationRequestParameters: ults_AuthenticationRequestParameters {
    var sdkReferenceNumber: String = "3DS_LOA_SDK_PPFU_020100_00007"
    var deviceData: String
    var sdkTransactionID: String
    var sdkAppID: String
    var sdkEphemeralPublicKey: String
    var messageVersion: String = "2.1.0"
    
    
    init() {

        deviceInfo.sharedDeviceInfo.generateSDKEphemeral()
        self.sdkTransactionID = deviceInfo.sharedDeviceInfo.sdkTransactionID
        self.sdkAppID =  deviceInfo.sharedDeviceInfo.sdkappId
        
        let dic = ["crv": "P-256","kty": "EC","x": deviceInfo.sharedDeviceInfo.sdkEphemeralPublicXNY!["x"],"y": deviceInfo.sharedDeviceInfo.sdkEphemeralPublicXNY!["y"]]
        self.sdkEphemeralPublicKey = String(data: try! JSONSerialization.data(withJSONObject: dic, options: []), encoding: .utf8)!
        let rsa = true
        if rsa {
            //RSA
            let number = Int.random(in: 0 ..< 10)
            if number % 2 == 0 {
                self.deviceData = AReqEncrytion().rsaOapA128GCM()
            } else {
                self.deviceData = AReqEncrytion().rsaOapCBC()
            }
        } else {
            //EC
            self.deviceData = AReqEncrytion().ecdhA128GCM()
            //not working
            //self.deviceData = AReqEncrytion().ecdhA128CBCHS256()
        }
    }
    
    func getDeviceData() -> String {
        return self.deviceData
    }
    
    
    func getSDKTransactionID() -> String {
        return self.sdkTransactionID
    }
    
    
    func getSDKAppID() -> String {
        return self.sdkAppID
    }
    
    
    func getSDKReferenceNumber() -> String {
        return self.sdkReferenceNumber
    }
    
    
    func getSDKEphemeralPublicKey() -> String {
        return self.sdkEphemeralPublicKey
    }
    
    
    func getMessageVersion() -> String {
        return self.messageVersion
    }
}

class  Transaction: ults_Transaction {
    
    var challengeNo = 0
    var id: String
    var msg: String
    var progressHud : ProgressView?
    var acsURL : String!
    var cUI : UINavigationController?
    
    init(_ id: String, _ msg: String) {
        self.id = id
        self.msg = msg
    }
    
    
    func getAuthenticationRequestParameters() -> ults_AuthenticationRequestParameters {
        return AuthenticationRequestParameters()
    }
    
    var timer: DispatchSourceTimer?
    var didStart = false
    func startTimer(url: String, challengeParameters: ults_ChallengeParameters, challengeStatusReceiver: ults_ChallengeStatusReceiver) {
        let queue = DispatchQueue(label: "com.asiapay.timer")  // you can also use `DispatchQueue.main`, if you want
        timer = DispatchSource.makeTimerSource(queue: queue)
        let sec = 300
        timer?.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(sec), leeway: DispatchTimeInterval.seconds(sec))
        timer!.setEventHandler { [weak self] in
            if self!.didStart == false {
                self!.didStart = true
            } else {
                let err = ErrorCReq.init(threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: "402", errorDescription: "Timeout", errorDetail: "Timeout", message: "")
                DispatchQueue.main.async {
                    self!.cUI?.dismiss(animated: true, completion: nil)
                    //challengeStatusReceiver.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((self!.id)!, "402", "Error", "Error")))
                    APICall.shared.postError(stringData:err.toJson() , url: url, transation: self!, challengeParameters: challengeParameters, challengeStatusReceiver: challengeStatusReceiver, ui: nil, withCode: "")
                    challengeStatusReceiver.timedout()
                    self!.stopTimer()
                }
            }
        }
        timer!.resume()
    }
    
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    
    func doChallenge(_ applicationContext: ults_Context?, _ challengeParameters: ults_ChallengeParameters, _ challengeStatusReceiver: ults_ChallengeStatusReceiver, _ timeOut: Int) throws {
        if challengeParameters.getAcsSignedContent() == "" {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver.runtimeError(e)
            print("invalid ARES issue")
            return
        }
        let arrAcsSignedContent = challengeParameters.getAcsSignedContent().components(separatedBy: ".")
        if arrAcsSignedContent.count != 3 {
            print("invalid ARES issue")
        }
        if arrAcsSignedContent.count != 3 {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver.runtimeError(e)
            return
        }
        let headerDic = try! JSONSerialization.jsonObject(with: Data.init(base64URLEncoded: arrAcsSignedContent[0])!, options: .allowFragments) as! [String : Any]
        if headerDic.keys.count != 2 {
            print("invalid ARES issue")
        }
        guard let sig = Data.init(base64URLEncoded: arrAcsSignedContent[2]) else {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver.runtimeError(e)
            print("invalid ARES issue")
            return
        }
        let msg = arrAcsSignedContent[0] + "." + arrAcsSignedContent[1]
        var certis : [String]?
        if (headerDic["x5c"] as? NSArray) != nil {
            certis = (headerDic["x5c"] as! [String])
        }
        if let userlogin = headerDic["x5c"] as? NSString {
            var headerStr = userlogin.components(separatedBy: ",")
            headerStr[0] = headerStr[0].replacingOccurrences(of: "[", with: "")
            headerStr[0] = headerStr[0].replacingOccurrences(of: "]", with: "")
            headerStr[0] = headerStr[0].replacingOccurrences(of: " ", with: "")
            headerStr[1] = headerStr[1].replacingOccurrences(of: "[", with: "")
            headerStr[1] = headerStr[1].replacingOccurrences(of: "]", with: "")
            headerStr[1] = headerStr[1].replacingOccurrences(of: " ", with: "")
            certis = headerStr
        }
        guard let certData0 = Data.init(base64Encoded: certis![0], options: .ignoreUnknownCharacters) else {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver.runtimeError(e)
            return
        }
        //let certData0 = Data.init(base64Encoded: certis![0], options: .ignoreUnknownCharacters)!
        let certificate0 = SecCertificateCreateWithData(nil, certData0 as CFData)
        var publicKey0 : SecKey?
        if #available(iOS 12.0, *) {
            publicKey0 = SecCertificateCopyKey(certificate0!)!
        } else {
            publicKey0 = SecCertificateCopyPublicKey(certificate0!)
        }
        let certData1 = Data.init(base64Encoded: certis![1], options: .ignoreUnknownCharacters)!
        let certificate1 = SecCertificateCreateWithData(nil, certData1 as CFData)
        var error: Unmanaged<CFError>?
        var verified = false
        if (String(data: SecCertificateCopyNormalizedIssuerSequence(certificate0!)! as Data, encoding: .utf8)?.contains(SecCertificateCopySubjectSummary(certificate1!)! as String))! {
            if (headerDic["alg"] as! String == "ES256") {
                //verified = SecKeyVerifySignature(publicKey0!, SecKeyAlgorithm.ecdsaSignatureMessageX962SHA256, msg.data as CFData, sig as CFData, &error)
                let digest = try! UtilForEncry.sharedUtil.createDigest(input: msg.data)
                let status = SecKeyRawVerify(publicKey0!, .sigRaw, digest, digest.count, sig.bytes, 64)
                if status == 0 {
                    verified = true
                }
            } else {
                if (headerDic["alg"] as! String == "PS256") {
                    verified = SecKeyVerifySignature(publicKey0!, SecKeyAlgorithm.rsaSignatureMessagePSSSHA256, msg.data as CFData, sig as CFData, &error)
                }
            }
        }
        if verified {
            let acsEphemPubKeydic =  try! JSONSerialization.jsonObject(with: Data.init(base64URLEncoded: arrAcsSignedContent[1])!, options: .allowFragments) as! [String : Any]
            acsURL = acsEphemPubKeydic["acsURL"] as! String
            if let acsEphem = acsEphemPubKeydic["acsEphemPubKey"] as? [String : String] {
                //let acsPublicKeyEC = ECPublicKey(crv: ECCurveType.P256, x: acsEphem["x"]! , y: acsEphem["y"]!)
                let acsPublicKeySecEC = deviceInfo.sharedDeviceInfo.getSecKeyfromValues(x: acsEphem["x"]!, y: acsEphem["y"]!)
                //try! acsPublicKeyEC.converted(to: SecKey.self)
                var error44 : Unmanaged<CFError>?
                //var _: Unmanaged<CFError>?
                let sharesecret = SecKeyCopyKeyExchangeResult(deviceInfo.sharedDeviceInfo.sdkEphemeralPrivateKeySec! , SecKeyAlgorithm.ecdhKeyExchangeStandard, acsPublicKeySecEC, [:] as CFDictionary, &error44)! as Data
                //dh = sharesecret as NSData
                let gcm = true
                if gcm {
                    let algId = "00000000"
                    let partyUInfo = "00000000"
                    let partyVInfo = "000000" + String(format:"%02X", "3DS_LOA_SDK_PPFU_020100_00007".count) + "3DS_LOA_SDK_PPFU_020100_00007".toHexadecimal()
                    let suppPubInfo = "00000100"
                    let conkdf = "00000001" + sharesecret.bytes.toHexString().uppercased() + algId + partyUInfo + partyVInfo + suppPubInfo
                    let dhbyte = UtilForEncry.sharedUtil.sha256(data: isDebugged().hexa(conkdf))
                    deviceInfo.sharedDeviceInfo.dh = dhbyte
                    //let creq = CReq(sdkCounterStoA: String(challengeNo), acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID , threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq")
                    //String(challengeNo)
                    //
                    //let creq = CReq(sdkCounterStoA: "000", acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: "fd38a34f-5ec1-455e-8026-34582c326f05" , threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
                    
                    let creq = CReq(sdkCounterStoA: "000", acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID , threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
                    let makefinal = CreqEncryption().getCreq128GCM(acstransId: challengeParameters.getAcsTransactionID(), get3DSServerTransactionID: challengeParameters.get3DSServerTransactionID(), sdkCounter: challengeNo, creqJson: creq.toJson())
                    self.startTimer(url: acsURL, challengeParameters: challengeParameters, challengeStatusReceiver: challengeStatusReceiver)
                    AbstractNetworkRequest().post(stringData:makefinal , url: acsURL, transation: self, challengeParameters: challengeParameters, challengeStatusReceiver: challengeStatusReceiver, ui: nil)

                } else {
                    let kData = sharesecret
                    let k = kData.bytes
                    let ivData = try! UtilForEncry.sharedUtil.randomData(ofLength: 16)
                    let iv = ivData.bytes
                    let auth_Key = k.split().left
                    let enc_key = k.split().right
                    let protectedHeader = "{\"alg\":\"dir\",\"kid\":\"" + challengeParameters.getAcsTransactionID() + "\",\"enc\":\"A128CBC-HS256\"}"
                    let protectedHeaderbase64 = protectedHeader.data(using: .utf8)?.base64URLEncodedString()
                    let aes = try! AES(key: enc_key, blockMode: CBC(iv: iv), padding: .pkcs7)
                    //let cipherData = try! aes.encrypt(enc_key)
                    var counter = "\(challengeNo)"
                    while counter.count != 3 {
                        counter = "0" + counter
                    }
                    let creq = CReq(sdkCounterStoA: counter, acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID , threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
                    let creqStr = creq.toJson()
                    let cipherData = try! aes.encrypt((creqStr).bytes)
                    let cipherDataBase64 = Data(bytes: cipherData).base64URLEncodedString()
                    let aad = protectedHeaderbase64!.toHexadecimal()
                    var al = "0000000000000000" + String(format:"%02X", (aad.count) * 4)
                    al = al.tail(index: al.count - 16)
                    let hmacData = aad + iv.toHexString() + cipherData.toHexString() + al
                    let HmacValue = UtilForEncry.sharedUtil.calculate(from: isDebugged().hexa(hmacData), with: Data(bytes: auth_Key))
                    let HmacValueArr = Array(HmacValue.bytes[0..<16])
                    let authenticationTagBase64 = Data(bytes: HmacValueArr).base64URLEncodedString()
                    var makeFinal = protectedHeaderbase64! + ".."
                    makeFinal = makeFinal + ivData.base64URLEncodedString() + "."
                    makeFinal = makeFinal + cipherDataBase64 + "." + authenticationTagBase64
                    challengeNo = challengeNo + 1
                    AbstractNetworkRequest().post(stringData:makeFinal , url: acsURL, transation: self, challengeParameters: challengeParameters, challengeStatusReceiver: challengeStatusReceiver, ui: nil)
                }
            } else {
                let e = RuntimeErrorEvent.init("203", "Invalid Argument")
                challengeStatusReceiver.runtimeError(e)
            }
        } else {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver.runtimeError(e)
        }
        //ults_ChallengeParameters.getAcsSignedContent()
        //print("acsSignedContent-->\(acsSignedContent)")
        //let Completeevent = CompletionEvent(challengeParameters.getAcsTransactionID(), "Y")
        //challengeStatusReceiver.completed(Completeevent)
        // TODO The context parameter comes from the Specification, you could use it to keep some shared data, if needed
        // TODO Do the challenge processing
        // TODO Call the challengeStatusReceiver with the results
        // ACS signed contented decode with URL ACS_URL / ACS_ePhemerial_key
        // signature verify with root certificate
        // make session secreate key  / (ACS_ePhemerial_key + sdk ephimeral_key)
        // Creq Making and ecnrytion
        // make call to CReq ACS_URL
    }
    
    func getProgressView(_ applicationContext: ults_Context?) throws -> ults_ProgressView {
        // TODO The context parameter comes from the Specification, you could use it to keep some shared data, if needed
        progressHud = ProgressView()
        return progressHud!
    }

    func close() throws {
      
        let frame = CGRect(x: 0 , y: 0, width: 375, height: 600)
        let activityIndicatorView =  NVActivityIndicatorView(frame:frame, type:NVActivityIndicatorView.DEFAULT_TYPE, color: NVActivityIndicatorView.DEFAULT_COLOR, padding: NVActivityIndicatorView.DEFAULT_PADDING)
        activityIndicatorView.stopAnimating()
        // TODO you will probably have to clean up some stuff here, like close connections or dialogs
    }

    func makeErrorCode() { }
    func makeRunTimeErrorCode() { }
}

class LoadingView: UIViewController ,NVActivityIndicatorViewable {

    func startLoad() {
        let size = CGSize(width: self.view.frame.width/5, height: self.view.frame.width/5)
        startAnimating(size, message: "Loading...",messageFont: UIFont.boldSystemFont(ofSize: 25),type: NVActivityIndicatorType.ballGridPulse)
    }
    func stopLoad() {
         stopAnimating()
    }
}


class  ProgressView: ults_ProgressView {

    let loadview = LoadingView()
    
    func show() {
       loadview.startLoad()
    }

    func close() {
       loadview.stopLoad()
    }
}

//MARK:--------> challenge Parameter
class ChallengeParameters: ults_ChallengeParameters {
    
    func getThreeDSRequestorAppURL() -> String {
        return ""
    }
    
    func setThreeDSRequestorAppURL(_ threeDSRequestorAppURL: String) {
        
    }
    var threeDSServerTransactionID: String
    var acsTransactionID: String
    var acsRefNumber: String
    var acsSignedContent: String
    
    init(_ threeDSServerTransactionID: String, _ acsTransactionID: String, _ acsRefNumber: String, _ acsSignedContent: String) {
        
        self.threeDSServerTransactionID = threeDSServerTransactionID
        self.acsTransactionID = acsTransactionID
        self.acsRefNumber = acsRefNumber
        self.acsSignedContent = acsSignedContent
    }
    
    func set3DSServerTransactionID(_ transactionID: String) {
        self.threeDSServerTransactionID = transactionID
    }
    
    func setAcsTransactionID(_ transactionID: String) {
        self.acsTransactionID = transactionID
    }
    
    func setAcsRefNumber(_ refNumber: String) {
        self.acsRefNumber = refNumber
    }
    
    func setAcsSignedContent(_ signedContent: String) {
        self.acsSignedContent = signedContent
    }
    
    func get3DSServerTransactionID() -> String {
        return threeDSServerTransactionID
    }
    
    func getAcsTransactionID() -> String {
        return acsTransactionID
    }
    
    func getAcsRefNumber() -> String {
        return acsRefNumber
    }
    
    func getAcsSignedContent() -> String {
        return acsSignedContent
    }
}



//MARK:------------------> ThreeDS2Service
public class ThreeDS2Service: ults_ThreeDS2Service {
    
    var isSdkInitialize : Bool = false
    let messageversionarr = ["2.1.0", "2.2.0"]
    
    public func initialize(_ applicationContext: ults_Context?, _ configParameters: ults_ConfigParameters, _ locale: String?, _ uiCustomization: ults_UiCustomization?) throws {

        //add the device data
        if  !isSdkInitialize{
            print("SDK already initalzed")
        } else {
            //create sdkAppID->pending
//           deviceInfo.sharedDeviceInfo.getDeviceData()
//           let authe = AuthenticationRequestParameters()
//           authe.getSDKAppID()
           //authe.getSDKTransactionID()
            
        }
        
        //applicationContext
        // TODO you will probalby need to store these
    }
    
    
    public func createTransaction(_ directoryServerID: String, _ messageVersion: String?) throws -> ults_Transaction {
        
        var msgversion : String = ""
        
        if messageVersion == "" ||  messageversionarr.contains(messageVersion!) {
            if  messageVersion == "" {
                //msgversion = messageversionarr[0]
            }
        } else {
        }
        return Transaction(directoryServerID, messageVersion!)
    }
    
    
    public func cleanup(_ applicationContext: ults_Context?) throws {
        // TODO some cleanup, if needed
    }
    
    
    public func getSDKVersion() throws -> String {
        return "2.1.0"
    }
    
    public func getWarnings() -> Array<ults_Warning> {
        return Array<ults_Warning>()
    }
}

class Warning: ults_Warning {
    var id: String
    var msg: String
    var severity: ults_Severity
    
    init(_ id: String, _ msg: String, _ severity: ults_Severity) {
        self.id  = id
        self.msg = msg
        self.severity = severity
    }
    
    
    func getID() -> String {
        return id
    }
    
    
    func getMessage() -> String {
        return msg
    }
    
    
    func getSeverity() -> ults_Severity {
        return severity
    }
    
    
    func setID(_ id: String) {
        self.id = id;
    }
    
    
    func setMessage(_ message: String) {
        self.msg = message;
    }
    
    
    func setSeverity(_ severity: ults_Severity) {
        self.severity = severity
    }
}


class ConfigParameters: ults_ConfigParameters {
    func addParam(_ group: String?, _ paramName: String, _ paramValue: String?) throws {
        // Add implementation
    }
    
    
    func getParamValue(_ group: String?, _ paramName: String) throws -> String {
        // Add implementation
        return ""
    }
    
    
    func removeParam(_ group: String?, _ paramName: String) throws -> String {
        // Add implementation
        return ""
    }
}



class Customization: ults_Customization {
    var textFontName: String
    var textColor: String
    var textFontSize: Int
    
    
    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int) {
        self.textFontName = textFontName
        self.textColor = textColor
        self.textFontSize = textFontSize
    }
    
    
    func setTextFontName(_ fontName: String) throws {
        self.textFontName = fontName
    }
    
    
    func setTextColor(_ hexColorCode: String) throws {
        self.textColor = hexColorCode
    }
    
    
    func setTextFontSize(_ fontSize: Int) throws {
        self.textFontSize = fontSize
    }
    
    
    func getTextFontName() -> String {
        return textFontName
    }
    
    
    func getTextColor() -> String {
        return textColor
    }
    
    
    func getTextFontSize() -> Int {
        return textFontSize
    }
}



class ButtonCustomization: Customization, ults_ButtonCustomization {
    var backgroundColor: String
    var cornerRadius: Int
    
    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int, _ backgroundColor: String, _ cornerRadius: Int) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        super.init(textFontName, textColor, textFontSize)
    }
    
    func setBackgroundColor(_ hexColorCode: String) throws {
        self.backgroundColor = hexColorCode
    }
    
    
    func setCornerRadius(_ cornerRadius: Int) throws {
        self.cornerRadius = cornerRadius
    }
    
    
    func getBackgroundColor() -> String {
        return backgroundColor
    }
    
    func getCornerRadius() -> Int {
        return cornerRadius
    }
}


class ToolbarCustomization: Customization, ults_ToolbarCustomization {
    var backgroundColor: String
    var headerText: String
    
    
    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int, _ backgroundColor: String, _ headerText: String) {
        self.backgroundColor = backgroundColor
        self.headerText = headerText
        super.init(textFontName, textColor, textFontSize)
    }
    
    
    func setBackgroundColor(_ hexColorCode: String) throws {
        self.backgroundColor = hexColorCode
    }
    
    
    func setHeaderText(_ headerText: String) throws {
        self.headerText = headerText
    }
    
    
    func getBackgroundColor() -> String {
        return backgroundColor
    }
    
    
    func getHeaderText() -> String {
        return headerText
    }
}

class LabelCustomization: Customization, ults_LabelCustomization {
    var headingTextColor: String
    var headingTextFontName: String
    var headingTextFontSize: Int
    
    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int, _ headingTextColor: String, _ headingTextFontName: String, _ headingTextFontSize: Int) {
        self.headingTextColor = headingTextColor
        self.headingTextFontName = headingTextFontName
        self.headingTextFontSize = headingTextFontSize
        super.init(textFontName, textColor, textFontSize)
    }
    
    
    func setHeadingTextColor(_ hexColorCode: String) throws {
        self.headingTextColor = hexColorCode
    }
    
    func setHeadingTextFontName(_ fontName: String) throws {
        self.headingTextFontName = fontName
    }
    
    func setHeadingTextFontSize(_ fontSize: Int) throws {
        self.headingTextFontSize = fontSize
    }
    
    func getHeadingTextColor() -> String {
        return headingTextColor
    }
    
    func getHeadingTextFontName() -> String {
        return headingTextFontName
    }
    
    func getHeadingTextFontSize() -> Int {
        return headingTextFontSize
    }
}

class TextBoxCustomization: Customization, ults_TextBoxCustomization {
    var borderWidth: Int
    var borderColor: String
    var cornerRadius: Int
    
    init(_ textFontName: String, _ textColor: String, _ textFontSize: Int, _ borderWidth: Int, _ borderColor: String, _ cornerRadius: Int) {
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.cornerRadius = cornerRadius
        super.init(textFontName, textColor, textFontSize)
    }
    
    func setCornerRadius(_ cornerRadius: Int) throws {
        self.cornerRadius = cornerRadius
    }
    
    func getCornerRadius() -> Int {
        return cornerRadius
    }
    
    func setBorderWidth(_ borderWidth: Int) throws {
        self.borderWidth = borderWidth
    }
    
    func setBorderColor(_ hexColorCode: String) throws {
        self.borderColor = hexColorCode
    }
    
    func getBorderWidth() -> Int {
        return borderWidth
    }
    
    func getBorderColor() -> String {
        return borderColor
    }
}

class UiCustomization: ults_UiCustomization {
    
    func setButtonCustomization(_ buttonCustomization: ults_ButtonCustomization, _ buttonType: ults_ButtonType) throws {
        // TODO implement
    }
    
    func setButtonCustomization(_ buttonCustomization: ults_ButtonCustomization, _ buttonType: String) throws {
        // TODO implement
    }
    
    func setToolbarCustomization(_ toolbarCustomization: ults_ToolbarCustomization) throws {
        // TODO implement
    }
    
    func setLabelCustomization(_ labelCustomization: ults_LabelCustomization) throws {
        // TODO implement
    }
    
    func setTextBoxCustomization(_ textBoxCustomization: ults_TextBoxCustomization) throws {
        // TODO implement
    }
    
    func getButtonCustomization(_ buttonType: ults_ButtonType) throws -> ults_ButtonCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ButtonCustomization("","",0,"",0)
    }
    
    func getButtonCustomization(_ buttonType: String) throws -> ults_ButtonCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ButtonCustomization("","",0,"",0)
    }
    
    func getToolbarCustomization() throws -> ults_ToolbarCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return ToolbarCustomization("","",0,"","")
    }
    
    func getLabelCustomization() throws -> ults_LabelCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return LabelCustomization("","",0,"","",0)
    }
    
    func getTextBoxCustomization() throws -> ults_TextBoxCustomization {
        // TODO implement: not like this, must be a previously stored instance
        return TextBoxCustomization("","",0,0,"",0)
    }
}

class RuntimeErrorEvent: ults_RuntimeErrorEvent {
    var errorCode: String
    var errorMessage: String
    
    init (_ errorCode: String?, _ errorMessage: String) {
        self.errorCode = errorCode!
        self.errorMessage = errorMessage
    }
    
    func getErrorCode() -> String? {
        return errorCode
    }
    
    func getErrorMessage() -> String {
        return errorMessage
    }
}

class ErrorMessage: ults_ErrorMessage {
    var transactionID: String
    var errorCode: String
    var errorDescription: String
    var errorDetail: String

    init(_ transactionID: String, _ errorCode: String, _ errorDescription: String, _ errorDetail: String) {
        self.transactionID=transactionID
        self.errorCode=errorCode
        self.errorDescription=errorDescription
        self.errorDetail=errorDetail
    }
    
    func getTransactionID() -> String {
        return transactionID
    }
    
    func getErrorCode() -> String {
        return errorCode
    }
    
    func getErrorDescription() -> String {
        return errorDescription
    }
    
    func getErrorDetails() -> String {
        return errorDetail
    }
}

class ProtocolErrorEvent: ults_ProtocolErrorEvent {
    var sdkTransactionID: String
    var errorMessage: ErrorMessage
    
    init (_ sdkTransactionID: String, _ errorMessage: ErrorMessage) {
        self.sdkTransactionID = sdkTransactionID
        self.errorMessage = errorMessage
    }
    
    func getErrorMessage() -> ults_ErrorMessage {
        return errorMessage
    }
    
    func getSDKTransactionID() -> String {
        return sdkTransactionID
    }
}

public class CompletionEvent: ults_CompletionEvent {
    var sdkTransactionID: String
    var transactionStatus: String
    
    
    init(_ sdkTransactionID: String, _ transactionStatus: String) {
        self.sdkTransactionID = sdkTransactionID
        self.transactionStatus = transactionStatus
    }
    
    
    public func getSDKTransactionID() -> String {
        return sdkTransactionID
    }
    
    
    public func getTransactionStatus() -> String {
        return transactionStatus
    }
}


public class SampleFactory: ults_Factory {
    public init() {
        
    }
    public func newToolbarCustomization() -> ults_ToolbarCustomization {
        return ToolbarCustomization("Helvetica Neue", "Red", 10, "blue", "Title")

    }
    
    
    public func newAuthenticationRequestParameters(_ sdkTransactionID: String, _ deviceData: String, _ sdkEphemeralPublicKey: String, _ sdkAppID: String, _ sdkReferenceNumber: String, _ messageVersion: String) throws -> ults_AuthenticationRequestParameters {
        
        let ret = AuthenticationRequestParameters()
        ret.sdkTransactionID = sdkTransactionID
        ret.deviceData = deviceData
        ret.sdkEphemeralPublicKey = sdkEphemeralPublicKey
        ret.sdkAppID = sdkAppID
        ret.messageVersion = messageVersion
        
        return ret
    }
    
    public func newRuntimeErrorEvent(_ errorCode: String?, _ errorMessage: String) -> ults_RuntimeErrorEvent {
        return RuntimeErrorEvent(errorCode,errorMessage)
    }
    
    public func newProtolErrorEvent(_ sdkTransactionID: String, _ errorMessage: ults_ErrorMessage) -> ults_ProtocolErrorEvent {
        return ProtocolErrorEvent(sdkTransactionID, errorMessage as! ErrorMessage)
    }
    
    public func newCompletionEvent(_ sdkTransactionID: String, _ transactionStatus: String) -> ults_CompletionEvent {
        return CompletionEvent(sdkTransactionID,transactionStatus)
    }
    
    public func newErrorMessage(_ transactionID: String, _ errorCode: String, _ errorDescription: String, _ errorDetail: String) -> ults_ErrorMessage {
        return ErrorMessage(transactionID,errorCode,errorDescription,errorDetail)
    }
    
    public func newWarning(_ id: String, _ message: String, _ severity: ults_Severity) -> ults_Warning {
        return Warning(id, message, severity)
    }
    
    public func newChallengeParameters() -> ults_ChallengeParameters {
        return ChallengeParameters("","","","")
    }
    
    public func newThreeDS2Service() -> ults_ThreeDS2Service {
        return ThreeDS2Service()
    }
    
    public func newConfigParameters() -> ults_ConfigParameters {
        return ConfigParameters()
    }
    
    public func newUiCustomization() -> ults_UiCustomization {
        return UiCustomization()
    }
}
