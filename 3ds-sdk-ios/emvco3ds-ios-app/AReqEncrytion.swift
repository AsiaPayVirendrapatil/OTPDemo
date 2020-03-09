//
//  AReqEncrytion.swift
//  emvco3ds-ios-app
//
//  Created by Vaibhav on 02/05/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.
//

import UIKit
import CryptoSwift
import emvco3ds_ios_framework


class AReqEncrytion: NSObject {
    
    
    func rsaOapA128GCM() -> String {
        let header = ["alg":"RSA-OAEP-256","kid":deviceInfo.sharedDeviceInfo.uuidForDS,"enc":"A128GCM"]
        let headerData = try! JSONSerialization.data(withJSONObject: header, options: [])
        let protectedHeader64 = headerData.base64URLEncodedString()
        let ivData = try! UtilForEncry.sharedUtil.randomData(ofLength: 12)
        let iv = ivData.bytes
        let cek_key_Data = try! UtilForEncry.sharedUtil.randomData(ofLength: 16)
        let cek_key = cek_key_Data.bytes
        let pub = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr/O0BfXWngO9OJDBsqdR5U2h28jrX6Y+LlblTBaYeT2tW7+ca3YzTFXA8duVUwdlWxl3JZCOOeL1feVP6g0TNOHVCkCnirVDLkcozod4aSkNvx+929aDr1ithqhruf0skBc2sMZGBBCNpso6XGzyAf2uZ2+9DvXoKIUYgcr7PQmL2Y0awyQN7KCRcusaotYNz2mOPrL/hAv6hTexkNrQKzFcPwCuc6kN6aNjD+p2CJ51/5p02SNS70nPOmwmg63j6f3n7xVykQ56kNc1l5B5xOpeHJmqk3+hyF1dF/47rQmMFicN41QSvZ5AZJKgWlIn2VQROMkEHkF9ZBRLx1nFTwIDAQAB".getPublicKeyRSA()
        let dataString = deviceInfo.sharedDeviceInfo.getDeviceData()
        let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
        var encryptedData = Data()
        if let encryptedMessageData: Data = SecKeyCreateEncryptedData(pub!, .rsaEncryptionOAEPSHA256, cek_key_Data as CFData, error) as Data? {
            encryptedData = encryptedMessageData
        }
        let enciphermentBase64 = encryptedData.base64URLEncodedString()
        let gcm = GCM(iv: iv, additionalAuthenticatedData: protectedHeader64.bytes, mode: GCM.Mode.detached)
        let aes = try! AES(key: cek_key, blockMode: gcm, padding: .noPadding)
        let cipherData = try! aes.encrypt(dataString.bytes)
        let ciphertextBase64 = Data(bytes: cipherData).base64URLEncodedString()
        let authenticationTagBase64 = Data(bytes: gcm.authenticationTag!).base64URLEncodedString()
        let makeFinal = protectedHeader64 + "." + enciphermentBase64 + "." + ivData.base64URLEncodedString() + "." + ciphertextBase64 + "." + authenticationTagBase64
        return makeFinal
    }
    
    
    func rsaOapCBC() -> String {
        let header = ["alg":"RSA-OAEP-256","kid":deviceInfo.sharedDeviceInfo.uuidForDS,"enc":"A128CBC-HS256"]
        let headerData = try! JSONSerialization.data(withJSONObject: header, options: [])
        let protectedHeader64 = headerData.base64URLEncodedString()
        let kData = try! UtilForEncry.sharedUtil.randomData(ofLength: 32)
        let k = kData.bytes
        let ivData = try! UtilForEncry.sharedUtil.randomData(ofLength: 16)
        let iv = ivData.bytes
        //k = "d2eee3289754186fda15cf02aa7b4628".data.bytes
        //iv = "985f35e8a257587a16425e8c17112bf3".hexaBytes
        let mac_key = k.split().left
        let enc_key = k.split().right
        let pub = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr/O0BfXWngO9OJDBsqdR5U2h28jrX6Y+LlblTBaYeT2tW7+ca3YzTFXA8duVUwdlWxl3JZCOOeL1feVP6g0TNOHVCkCnirVDLkcozod4aSkNvx+929aDr1ithqhruf0skBc2sMZGBBCNpso6XGzyAf2uZ2+9DvXoKIUYgcr7PQmL2Y0awyQN7KCRcusaotYNz2mOPrL/hAv6hTexkNrQKzFcPwCuc6kN6aNjD+p2CJ51/5p02SNS70nPOmwmg63j6f3n7xVykQ56kNc1l5B5xOpeHJmqk3+hyF1dF/47rQmMFicN41QSvZ5AZJKgWlIn2VQROMkEHkF9ZBRLx1nFTwIDAQAB".getPublicKeyRSA()
        let dataString = deviceInfo.sharedDeviceInfo.getDeviceData()
        let error:UnsafeMutablePointer<Unmanaged<CFError>?>? = nil
        var encryptedData = Data()
        if let encryptedMessageData: Data = SecKeyCreateEncryptedData(pub!, .rsaEncryptionOAEPSHA256, kData as CFData, error) as Data? {
            encryptedData = encryptedMessageData
        }
        let enciphermentBase64 = encryptedData.base64URLEncodedString()
        let aes = try! AES(key: enc_key, blockMode: CBC(iv: iv), padding: .pkcs7)
        /*var v : Int = 16 - (dataString.count % 16)
         if v == 16 {
         v = 0
         }
         var tempPadding = ""
         for _ in 0..<v {
         tempPadding = tempPadding + " "
         }
         let cipherData = try! aes.encrypt((dataString + tempPadding).bytes)*/
        let cipherData = try! aes.encrypt(dataString.bytes)
        let ciphertextBase64 = Data(bytes: cipherData).base64URLEncodedString()
        let aad = protectedHeader64.toHexadecimal()
        var al = "0000000000000000" + String(format:"%02X", (aad.count) * 4)
        al = al.tail(index: al.count - 16)
        let hmacData = aad + iv.toHexString() + cipherData.toHexString()  + al
        let HmacValue = UtilForEncry.sharedUtil.calculate(from:Data(fromHexEncodedString: hmacData)! , with: Data(fromHexEncodedString: mac_key.toHexString().uppercased())!)
        //print(HmacValue.toHexString())//29CB6314D4ABB44696D3CDDA4063456A01A52B2E6C6AB238F61B943BB8F24E28
        let HmacValueArr = Array(HmacValue.bytes[0..<16])
        let authenticationTagBase64 = Data(bytes: HmacValueArr).base64URLEncodedString()
        let makeFinal = protectedHeader64 + "." + enciphermentBase64 + "." + ivData.base64URLEncodedString() + "." + ciphertextBase64 + "." + authenticationTagBase64
        return makeFinal
    }
    
    
    
    func ecdhA128CBCHS256() -> String {
        //let dsPublicKeyEC = ECPublicKey(crv: ECCurveType.P256, x: "2_v-MuNZccqwM7PXlakW9oHLP5XyrjMG1UVS8OxYrgA", y: "rm1ktLmFIsP2R0YyJGXtsCbaTUesUK31Xc04tHJRolc")
        //0x04
        let dsPublicKeySecEC = deviceInfo.sharedDeviceInfo.getSecKeyfromValues(x: "2_v-MuNZccqwM7PXlakW9oHLP5XyrjMG1UVS8OxYrgA", y: "rm1ktLmFIsP2R0YyJGXtsCbaTUesUK31Xc04tHJRolc")
        //try! dsPublicKeyEC.converted(to: SecKey.self)
        //let keyattribute = [kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,kSecAttrKeySizeInBits as String : 256] as CFDictionary
        //var sdkEphemeralPublicKey, sdkEphemeralPrivateKey: SecKey?
        var error44 : Unmanaged<CFError>?
        //SecKeyGeneratePair(keyattribute, &sdkEphemeralPublicKey, &sdkEphemeralPrivateKey)
        let sharesecret = (SecKeyCopyKeyExchangeResult(deviceInfo.sharedDeviceInfo.sdkEphemeralPrivateKeySec!, SecKeyAlgorithm.ecdhKeyExchangeCofactor, dsPublicKeySecEC, [:] as CFDictionary, &error44)! as Data)
        let conKdf = "00000001" + sharesecret.bytes.toHexString().uppercased() + "00000000000000000000000A4630303030303030303100000100"
        let dhbyte = UtilForEncry.sharedUtil.sha256(data: isDebugged().hexa(conKdf))
        let cek_key = Array(dhbyte[16..<32])
        let auth_key = Array(dhbyte[0..<16])
        let ivData = try! UtilForEncry.sharedUtil.randomData(ofLength: 16)
        let iv = ivData.bytes
        let header = ["alg":"dir","kid":deviceInfo.sharedDeviceInfo.uuidForDS,"epk":["kty":"EC","crv":"P-256","x":"2_v-MuNZccqwM7PXlakW9oHLP5XyrjMG1UVS8OxYrgA","y":"rm1ktLmFIsP2R0YyJGXtsCbaTUesUK31Xc04tHJRolc"],"enc":"A128CBC-HS256"] as [String : Any]
        let headerData = try! JSONSerialization.data(withJSONObject: header, options: [])
        let protectedheader64 = headerData.base64URLEncodedString()
        let aes = try! AES(key: cek_key, blockMode: CBC(iv: iv), padding: .pkcs7)
        let deviceData = "{\"DV\":\"1.0\",\"DD\":{\"C001\":\"Android\",\"C002\":\"HTC One_M8\",\"C004\":\"5.0.1\",\"C005\":\"en_US\",\"C006\":\"Eastern Standard Time\",\"C007\":\"06797903-fb61-41ed-94c2-4d2b74e27d18\",\"C009\":\"John's Android Device\"},\"DPNA\":{\"C010\":\"RE01\",\"C011\":\"RE03\"},\"SW\":[\"SW01\",\"SW04\"]}"
        //var v : Int = 16 - deviceData.count % 16
        //if v == 16 {
        //v = 0
        //}
        //var tempPadding = ""
        //for _ in 0..<v {
        //tempPadding = tempPadding + " "
        //}
        //let cipherencrypt = try! aes.encrypt((deviceData + tempPadding).bytes)
        let cipherData = try! aes.encrypt(deviceData.bytes)
        let ciphertextBase64 = Data.init(bytes: cipherData).base64URLEncodedString()
        let aad = protectedheader64.toHexadecimal()
        var al = "0000000000000000" + String(format:"%02X", (aad.count) * 4)
        al = al.tail(index: al.count - 16)
        let hmacData = aad + iv.toHexString() + cipherData.toHexString()  + al
        let HmacValue = UtilForEncry.sharedUtil.calculate(from:Data(fromHexEncodedString: hmacData)! , with: Data(fromHexEncodedString: auth_key.toHexString().uppercased())!)
        //print(HmacValue.toHexString())//29CB6314D4ABB44696D3CDDA4063456A01A52B2E6C6AB238F61B943BB8F24E28
        let HmacValueArr = Array(HmacValue.bytes[0..<16])
        let authenticationTagBase64 = Data(bytes: HmacValueArr).base64URLEncodedString()
        let makeFinal = protectedheader64 + ".." + ivData.base64URLEncodedString() + "." + ciphertextBase64 + "." + authenticationTagBase64
        return makeFinal
    }
    
    
    func ecdhA128GCM() -> String {
        //let dsPublicKeyEC = ECPublicKey(crv: ECCurveType.P256, x: "YktbLuAv0v52erE5LPscomKaOmQsvevxzOyn9k4sF1g", y: "aqQXOZFMoM8QPSZdEf9nU7pPJGu1Aro5N-sXlLC1aVg")
        //"YktbLuAv0v52erE5LPscomKaOmQsvevxzOyn9k4sF1g",
        //"y": "aqQXOZFMoM8QPSZdEf9nU7pPJGu1Aro5N-sXlLC1aVg"
        let dsPublicKeySecEC = deviceInfo.sharedDeviceInfo.getSecKeyfromValues(x: "YktbLuAv0v52erE5LPscomKaOmQsvevxzOyn9k4sF1g", y: "aqQXOZFMoM8QPSZdEf9nU7pPJGu1Aro5N-sXlLC1aVg")
        //let dsPublicKeySecECViaPem = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE2/v+MuNZccqwM7PXlakW9oHLP5XyrjMG1UVS8OxYrgCubWS0uYUiw/ZHRjIkZe2wJtpNR6xQrfVdzTi0clGiVw==".getPublicKeyEC()
        //try! dsPublicKeyEC.converted(to: SecKey.self)
        var error44 : Unmanaged<CFError>?
        let sharesecret = SecKeyCopyKeyExchangeResult(deviceInfo.sharedDeviceInfo.sdkEphemeralPrivateKeySec! , SecKeyAlgorithm.ecdhKeyExchangeStandard, dsPublicKeySecEC, [:] as CFDictionary, &error44)! as Data
        //let algId = "00000001"
        //let partyUInfo = "00000000"
        //let partyVInfo = "000000" + String(format:"%02X", "F000000001".count) + "F000000001".toHexadecimal()
        //let suppPubInfo = "00000080"
        let conKdf = "00000001" + sharesecret.bytes.toHexString().uppercased() + "00000000000000000000000A4630303030303030303100000100"
        //+ algId + partyUInfo + partyVInfo + suppPubInfo
        let dhDerviedKey = UtilForEncry.sharedUtil.sha256(data: isDebugged().hexa(conKdf))
        let cek_key = Array(dhDerviedKey.bytes[0..<16])
        let ivData = try! UtilForEncry.sharedUtil.randomData(ofLength: 12)
        let iv = ivData.bytes
        //let protectedHeader = ["alg":"dir","kid":deviceInfo.sharedDeviceInfo.uuidForDS,"epk":["kty":"EC","crv":"P-256","x":"2_v-MuNZccqwM7PXlakW9oHLP5XyrjMG1UVS8OxYrgA","y":"rm1ktLmFIsP2R0YyJGXtsCbaTUesUK31Xc04tHJRolc"],"enc":"A128GCM"] as [String : Any]
        let protectedHeader = UtilForEncry.sharedUtil.getHeader(pubkey: deviceInfo.sharedDeviceInfo.sdkEphemeralPublicKeySec)
        let protectedHeader64 = protectedHeader.data(using: .utf8)?.base64URLEncodedString()
        let gcm = GCM(iv: iv, additionalAuthenticatedData: protectedHeader64!.bytes, mode: .detached)
        let aes = try! AES(key: cek_key, blockMode: gcm, padding: .noPadding)
        let dataString = deviceInfo.sharedDeviceInfo.getDeviceData()
        //let dataString = "{\"DV\":\"1.0\",\"DD\":{\"C001\":\"Android\",\"C002\":\"HTC One_M8\",\"C004\":\"5.0.1\",\"C005\":\"en_US\",\"C006\":\"Eastern Standard Time\",\"C007\":\"06797903-fb61-41ed-94c2-4d2b74e27d18\",\"C009\":\"John's Android Device\"},\"DPNA\":{\"C010\":\"RE01\",\"C011\":\"RE03\"},\"SW\":[\"SW01\",\"SW04\"]}"
        let cipherData = try! aes.encrypt(dataString.bytes)
        let ciphertextBase64 = Data(bytes: cipherData).base64URLEncodedString()
        let authenticationTagBase64 = Data(bytes: gcm.authenticationTag!).base64URLEncodedString()
        let makeFinal = protectedHeader64! + ".." + ivData.base64URLEncodedString() + "." + ciphertextBase64 + "." + authenticationTagBase64
        return makeFinal
    }
    
}






class Cres {
    
    var transation : Transaction? = nil
    var challengeParameters : ults_ChallengeParameters?
    var challengeStatusReceiver : ults_ChallengeStatusReceiver?
    var acsURL  : String = ""
    
    
    func decodeCres(respose: String ,transation : Transaction, challengeParameters: ults_ChallengeParameters, challengeStatusReceiver: ults_ChallengeStatusReceiver , acsURL : String) {
        self.transation = transation
        self.challengeParameters = challengeParameters
        self.challengeStatusReceiver = challengeStatusReceiver
        self.acsURL = acsURL
        let resArr = respose.components(separatedBy: ".")
        guard let decodedData = Data(base64URLEncoded: resArr[0]) else {
            //let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            //challengeStatusReceiver.runtimeError(e)
            challengeStatusReceiver.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation.id), "203", "T##errorDescription: String##String", "T##errorDetail: String##String")))
            return
        }
        var dic = try! JSONSerialization.jsonObject(with: decodedData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : String]
        if dic["enc"] == "A128GCM" {
            decodeCResA128GCM(response: resArr)
        } else {
            decodeCResCBC128HS(response: resArr)
        }
    }
    
    
    func decodeCResA128GCM(response : [String]) {
        let dh = deviceInfo.sharedDeviceInfo.dh
        let header = response[0].data
        let iv = Data(base64URLEncoded: response[2])
        let ciper = Data(base64URLEncoded: response[3])
        let authTag = Data(base64URLEncoded: response[4])
        let cek = Array((dh?.bytes[16..<32])!)
        let gcm = GCM(iv: (iv?.bytes)!, authenticationTag: (authTag?.bytes)!, additionalAuthenticatedData: header.bytes, mode: .detached)
        let aes = try! AES(key: cek, blockMode: gcm, padding: .noPadding)
        let decryptedAES = try! aes.decrypt((ciper?.bytes)!)
        let jsonDic = try! JSONSerialization.jsonObject(with: Data(bytes: decryptedAES), options: []) as! [String : Any]
        //print(jsonDic)
        self.transation!.progressHud?.close()
        loadUI(jsonDic: jsonDic)
    }
    
    
    func decodeCResCBC128HS(response : [String]) {
        let dh = deviceInfo.sharedDeviceInfo.dh
        let aad = response[0].data
        let iv = Data(base64URLEncoded: response[2])
        let ciper = Data(base64URLEncoded: response[3])
        //let authTag = Data(base64URLEncoded: response[4])
        let cek = Array((dh?.bytes[16..<32])!)
        var al = "0000000000000000" + String(format:"%02X", (aad.count) * 4)
        al = al.tail(index: al.count - 16)
        let hmacData = aad.toHexString() + iv!.toHexString() + ciper!.toHexString()  + al
        _ = UtilForEncry.sharedUtil.calculate(from: isDebugged().hexa(hmacData), with: Data(bytes: cek))
        //let HmacValueArr = Array(HmacValue.bytes[0..<16])
        let cbc = CBC(iv: (iv?.bytes)!)
        let aes = try! AES(key: cek, blockMode: cbc, padding: .pkcs7)
        let cipherData = try! aes.decrypt((ciper?.bytes)!)
        let jsonDic = try! JSONSerialization.jsonObject(with: Data(bytes: cipherData), options: []) as! [String : Any]
        self.transation!.progressHud?.close()
        loadUI(jsonDic: jsonDic)
    }
    
    
    func loadUI(jsonDic : [String: Any]) {
        let creqjson = CresData.init(fromDictionary: jsonDic)
        let SdkCounterStoA = 1
        let supportedMessageVersion = ["2.1.0", "2.2.0"]
        let acsuitypes = ["01","02","03","04","05"]
        let messageExtensionIDs = ["EmvCoID1", "EmvCoID2"]
        var isValid = true
        var ErrorCode = ""
        
        print(jsonDic)
        
        if (creqjson.threeDSServerTransID != (challengeParameters?.get3DSServerTransactionID())! || creqjson.acsTransID != (challengeParameters?.getAcsTransactionID())!) {
            print("issue")
        }
        /*
         if responce().validation(jsonDic: jsonDic, challengeParameters: self.challengeParameters!, transation: self.transation!, acsURL: self.acsURL, challengeStatusReceiver: self.challengeStatusReceiver!) == false {
         return
         }
        */
        
        if ((jsonDic["messageType"] as? String) == nil) {
            ErrorCode = "101"
            isValid = false
            //let errorMessage = ErrorCReq.init(threeDSServerTransID: jsonDic["threeDSServerTransID"] as! String, acsTransID: jsonDic["acsTransID"] as! String, sdkTransID: jsonDic["sdkTransID"] as! String, errorCode: "101")
            //self.transation!.progressHud?.show()
            //AbstractNetRequest().post(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil)
            //isValid = true
        } else if creqjson.challengeCompletionInd == nil || creqjson.challengeCompletionInd == "" {
            ErrorCode = "201"
            isValid = false
        } else if (creqjson.challengeCompletionInd != "Y") && (creqjson.challengeCompletionInd != "N") {
            ErrorCode = "203"
            isValid = false
        } else if creqjson.challengeCompletionInd == "Y" {
            if creqjson.transStatus != nil {
                //|| creqjson.transStatus != "" {
              
                    let Completeevent = CompletionEvent((jsonDic["sdkTransID"] as! String), (jsonDic["transStatus"] as! String))
                    challengeStatusReceiver!.completed(Completeevent)
                    ErrorCode = "301"//"201"
                    isValid = false
              
            } else if creqjson.transStatus == nil || creqjson.transStatus == "" {
                ErrorCode = "201"
                isValid = false
            }
        } else if creqjson.sdkTransID == nil || creqjson.sdkTransID! == "" {
            creqjson.sdkTransID = ""
            ErrorCode = "201"
            isValid = false
        } else if creqjson.sdkTransID != deviceInfo.sharedDeviceInfo.sdkTransactionID {
            ErrorCode = "301"
            isValid = false
        } else if  creqjson.acsTransID == nil || creqjson.acsTransID == "" {
            creqjson.acsTransID = ""
            ErrorCode = "201"
            isValid = false
        } else if creqjson.acsTransID.count != 36 {
            ErrorCode = "301"
            isValid = false
        }  else if creqjson.acsTransID != challengeParameters?.getAcsTransactionID() {
            ErrorCode = "301"
            isValid = false
        } else if creqjson.threeDSServerTransID == nil || creqjson.threeDSServerTransID == "" {
            creqjson.threeDSServerTransID = ""
            ErrorCode = "201"
            isValid = false
        } else if creqjson.threeDSServerTransID != challengeParameters!.get3DSServerTransactionID() {
            creqjson.threeDSServerTransID = ""
            ErrorCode = "301"
            isValid = false
        } else if creqjson.messageType == nil || creqjson.messageType == "" {
            ErrorCode = "201"
            isValid = false
        } else if creqjson.messageType != "CRes" {
            ErrorCode = "101"
            isValid = false
        } else if ((jsonDic["messageType"] as? String) == nil) {
            let errorMessage = ErrorCReq.init(threeDSServerTransID: "", acsTransID: "", sdkTransID: "", errorCode: "302", errorDescription: "errorDescription", errorDetail: "errorDetail")
            self.transation!.progressHud?.show()
            AbstractNetRequest().post(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil)
            isValid = true
        } else if creqjson.challengeInfoText != nil &&  creqjson.challengeInfoText == "" {
            ErrorCode = "203"
            isValid = false
        } else  if creqjson.acsCounterAtoS  ==  nil || creqjson.acsCounterAtoS  ==  "" {
            ErrorCode = "201"
            isValid = false
        } else
//            if Int(creqjson.acsCounterAtoS)  != SdkCounterStoA - 1 {
//            ErrorCode = "302"
//            isValid = false
//        } else
            if creqjson.messageVersion == nil || creqjson.messageVersion! == "" {
            ErrorCode = "201"
            isValid = false
        } else if !supportedMessageVersion.contains(creqjson.messageVersion!) {
            ErrorCode = "203"
            isValid = false
        } else if creqjson.acsUiType == nil || creqjson.acsUiType == "" {
            ErrorCode = "201"//"201"
            isValid = false
        } else if !acsuitypes.contains(creqjson.acsUiType!) {
            ErrorCode = "203"
            isValid = false
        } else if (creqjson.messageExtension != nil) {
            let arr = creqjson.messageExtension! as NSArray
            if (creqjson.messageExtension?.count ?? 0)!  > 10 {
                ErrorCode = "203"
                isValid = false
            }
            for i in 0 ..< arr.count {
                let data = try! JSONSerialization.data(withJSONObject: (arr.object(at: i)as AnyObject).value(forKey: "data") as Any, options: [])
                if (arr.object(at: i)as AnyObject).value(forKey: "criticalityIndicator")as! Bool {
                    if !messageExtensionIDs.contains((arr.object(at: i)as AnyObject).value(forKey: "id")as! String) {
                        ErrorCode = "202"
                        isValid = false                        }
                } else  if ((arr.object(at: i)as AnyObject).value(forKey: "data") as! NSDictionary).count == 0 || data.count > 8059 {
                    ErrorCode = "203"
                    isValid = false
                } else if ((arr.object(at: i)as AnyObject).value(forKey: "id")as! String).count > 64 {
                    ErrorCode = "203"
                    isValid = false
                } else if ((arr.object(at: i)as AnyObject).value(forKey: "name")as! String).count > 64 {
                    ErrorCode = "203"
                    isValid = false
                }
            }
            let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID, acsTransID: creqjson.acsTransID, sdkTransID: creqjson.sdkTransID, errorCode: ErrorCode, errorDescription: "errorDescription", errorDetail: "errorDetail")
            self.transation!.progressHud?.show()
            AbstractNetRequest().post(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil)
        } else if creqjson.acsUiType == "05" {
            if creqjson.acsHTML == nil || creqjson.acsHTML == "" {
                ErrorCode = "201"
                isValid = false
            }
        } else {
            if creqjson.challengeInfoHeader == nil || creqjson.challengeInfoHeader == "" || creqjson.challengeInfoText == nil || creqjson.challengeInfoText == "" {
                ErrorCode = "201"
                isValid = false
            } else {
                if creqjson.acsUiType == "01" {
                    if creqjson.challengeInfoLabel == nil || creqjson.challengeInfoLabel == "" || creqjson.submitAuthenticationLabel == nil || creqjson.submitAuthenticationLabel == "" {
                        ErrorCode = "201"
                        isValid = false
                    }
                }
                if creqjson.acsUiType == "02" || creqjson.acsUiType == "03" {
                    if creqjson.challengeInfoLabel == nil || creqjson.challengeInfoLabel == "" || creqjson.challengeSelectInfo == nil || creqjson.submitAuthenticationLabel == nil || creqjson.submitAuthenticationLabel == "" {
                        ErrorCode = "201"
                        isValid = false
                    }
                }
                if creqjson.acsUiType == "04" {
                    if creqjson.oobContinueLabel == nil || creqjson.oobContinueLabel == "" {
                        ErrorCode = "201"
                        isValid = false
                    }
                }
            }
        }
        if isValid == false {
            let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID ?? (challengeParameters?.get3DSServerTransactionID())!, acsTransID: creqjson.acsTransID ?? (challengeParameters?.getAcsTransactionID())!, sdkTransID: creqjson.sdkTransID ?? deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: ErrorCode, errorDescription: "errorDescription", errorDetail: "errorDetail")
            self.transation!.progressHud?.show()
            AbstractNetRequest().post(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil)
            return
        }
        guard ((jsonDic["challengeCompletionInd"] as? String) != nil) else {
            let e = RuntimeErrorEvent.init("101", "Invalid Argument")
            challengeStatusReceiver!.runtimeError(e)
            //challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "101", "T##errorDescription: String##String", "T##errorDetail: String##String")))
            return
        }
        if ((jsonDic["challengeCompletionInd"] as! String) == "Y") {
            guard jsonDic["transStatus"] != nil else {
                challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "302", "T##errorDescription: String##String", "T##errorDetail: String##String")))
                //let e = RuntimeErrorEvent.init("203", "Invalid Argument")
                //challengeStatusReceiver!.runtimeError(e)
                return
            }
            let Completeevent = CompletionEvent((jsonDic["sdkTransID"] as! String), (jsonDic["transStatus"] as! String))
            challengeStatusReceiver!.completed(Completeevent)
        } else {
            let mainStoryBoard = UIStoryboard(name: "UIChallengeMain", bundle: nil)
            var navigationController : UINavigationController?
            var paymentView  : PaymentView?
            var webhtmlView  : WebhtmlView?
            var paymentView1  : SingleSelePaymentTem?
            guard (creqjson.acsUiType != nil) || (creqjson.acsUiType == "") else {
                let e = RuntimeErrorEvent.init("203", "Invalid Argument")
                challengeStatusReceiver!.runtimeError(e)
                return
            }
            if Int(creqjson.acsUiType) == 1 {
                paymentView = (mainStoryBoard.instantiateViewController(withIdentifier: "PaymentView") as! PaymentView)
                paymentView!.setCRes = creqjson
                paymentView!.transation = self.transation
                paymentView!.challengeStatusReceiver = challengeStatusReceiver
                paymentView!.challengeParameters = challengeParameters
                paymentView!.acsURL = acsURL
                navigationController = UINavigationController.init(rootViewController: paymentView!)
            } else  if Int(creqjson.acsUiType) == 2 || Int(creqjson.acsUiType) == 3 || Int(creqjson.acsUiType) == 4 {
                paymentView1 = (mainStoryBoard.instantiateViewController(withIdentifier: "SingleSelePaymentTem") as! SingleSelePaymentTem)
                paymentView1!.setCRes = creqjson
                paymentView1!.transation = self.transation
                paymentView1!.challengeStatusReceiver = challengeStatusReceiver
                paymentView1!.challengeParameters = challengeParameters
                paymentView1!.acsURL = acsURL
                navigationController = UINavigationController.init(rootViewController: paymentView1!)
            } else if Int(creqjson.acsUiType) == 5 {
                webhtmlView = (mainStoryBoard.instantiateViewController(withIdentifier: "WebhtmlView") as! WebhtmlView)
                webhtmlView!.setCRes = creqjson
                webhtmlView!.transation = self.transation
                webhtmlView!.challengeStatusReceiver = challengeStatusReceiver
                webhtmlView!.challengeParameters = challengeParameters
                webhtmlView!.acsURL = acsURL
                navigationController = UINavigationController.init(rootViewController: webhtmlView!)
            }
            UIApplication.shared.keyWindow?.rootViewController!.present(navigationController!, animated: true, completion: nil)
        }
    }
}



//DS EC Key
/*
 PEM
 -----BEGIN PUBLIC KEY-----
 MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEYktbLuAv0v52erE5LPscomKaOmQs
 vevxzOyn9k4sF1hqpBc5kUygzxA9Jl0R/2dTuk8ka7UCujk36xeUsLVpWA==
 -----END PUBLIC KEY-----
 
 JWK
 {
 "kty": "EC",
 "crv": "P-256",
 "x": "YktbLuAv0v52erE5LPscomKaOmQsvevxzOyn9k4sF1g",
 "y": "aqQXOZFMoM8QPSZdEf9nU7pPJGu1Aro5N-sXlLC1aVg"
 }
 
 */

//DS RSA Key
/*
 PEM
 -----BEGIN RSA PUBLIC KEY-----
 MIIBCgKCAQEAr/O0BfXWngO9OJDBsqdR5U2h28jrX6Y+LlblTBaYeT2tW7+ca3Yz
 TFXA8duVUwdlWxl3JZCOOeL1feVP6g0TNOHVCkCnirVDLkcozod4aSkNvx+929aD
 r1ithqhruf0skBc2sMZGBBCNpso6XGzyAf2uZ2+9DvXoKIUYgcr7PQmL2Y0awyQN
 7KCRcusaotYNz2mOPrL/hAv6hTexkNrQKzFcPwCuc6kN6aNjD+p2CJ51/5p02SNS
 70nPOmwmg63j6f3n7xVykQ56kNc1l5B5xOpeHJmqk3+hyF1dF/47rQmMFicN41QS
 vZ5AZJKgWlIn2VQROMkEHkF9ZBRLx1nFTwIDAQAB
 -----END RSA PUBLIC KEY-----
 
 JWK
 {
 "kty": "RSA",
 "e": "AQAB",
 "n": "r_O0BfXWngO9OJDBsqdR5U2h28jrX6Y-LlblTBaYeT2tW7-ca3YzTFXA8duVUwdlWxl3JZCOOeL1feVP6g0TNOHVCkCnirVDLkcozod4aSkNvx-929aDr1ithqhruf0skBc2sMZGBBCNpso6XGzyAf2uZ2-9DvXoKIUYgcr7PQmL2Y0awyQN7KCRcusaotYNz2mOPrL_hAv6hTexkNrQKzFcPwCuc6kN6aNjD-p2CJ51_5p02SNS70nPOmwmg63j6f3n7xVykQ56kNc1l5B5xOpeHJmqk3-hyF1dF_47rQmMFicN41QSvZ5AZJKgWlIn2VQROMkEHkF9ZBRLx1nFTw"
 }
 */

class responce {
    
    
    func validation(jsonDic : [String : Any] , challengeParameters : ults_ChallengeParameters , transation: Transaction , acsURL : String , challengeStatusReceiver : ults_ChallengeStatusReceiver) -> Bool {
        let creqjson = CresData.init(fromDictionary: jsonDic)
        //let acsTransID = creqjson.acsTransID
        //let threeDsTransID = creqjson.threeDSServerTransID
        //let sdkTransID = creqjson.sdkTransID
        var errorIssue = ""
        let supportedMessageVersion = ["2.1.0", "2.2.0"]
        let acsuitypes = ["01","02","03","04","05"]
        let messageExtensionIDs = ["EmvCoID1", "EmvCoID2"]
        var isValid = true
        if ((jsonDic["messageType"] as? String) == nil || (jsonDic["messageType"] as? String) == "" ) {
            errorIssue = "MessageExtensionID"
            isValid = false;
        } else if (jsonDic["messageType"] as? String) != "CRes" {
            errorIssue = "MessageType"
            isValid = false;
        } else if creqjson.messageVersion == nil || creqjson.messageVersion! == "" {
            errorIssue = "CResIssue"
            isValid = false;
        } else if !supportedMessageVersion.contains(creqjson.messageVersion!) {
            errorIssue = "UIComponents"
            isValid = false;
        } else if creqjson.acsCounterAtoS == nil || creqjson.acsCounterAtoS == "" {
            errorIssue = "CResIssue"
            isValid = false;
        } else if creqjson.acsCounterAtoS == "counter" {
            errorIssue = "AcsCounterAtoS"
            isValid = false;
        } else if (creqjson.messageExtension != nil) {
            let arr = creqjson.messageExtension! as NSArray
            if NSKeyedArchiver.archivedData(withRootObject: arr).count > 81920 {
                errorIssue = "MessageExtension"
                isValid = false
            } else if (creqjson.messageExtension?.count ?? 0)! > 10 {
                errorIssue = "MessageExtension"
                isValid = false
            } else {
                //for i in creqjson.messageExtension! {
                //var a = i as! String
                //if !messageExtensionIDs.contains(a["criticalityIndicator"] as! String ) {
                
                //}
                //}
            }
            for i in 0 ..< arr.count {
                let data = try! JSONSerialization.data(withJSONObject: (arr.object(at: i)as AnyObject).value(forKey: "data") as Any, options: [])
                if (arr.object(at: i)as AnyObject).value(forKey: "criticalityIndicator")as! Bool {
                    if !messageExtensionIDs.contains((arr.object(at: i)as AnyObject).value(forKey: "id")as! String) {
                        errorIssue = "MessageExtension"
                        isValid = false }
                } else if ((arr.object(at: i)as AnyObject).value(forKey: "data") as! NSDictionary).count == 0 || data.count > 8059 {
                    errorIssue = "MessageExtension"
                    isValid = false
                } else if ((arr.object(at: i)as AnyObject).value(forKey: "id")as! String).count > 64 {
                    errorIssue = "MessageExtension"
                    isValid = false
                } else if ((arr.object(at: i)as AnyObject).value(forKey: "name")as! String).count > 64 {
                    errorIssue = "MessageExtension"
                    isValid = false
                }
            }
            // if (AP.sizeOf(cRes.getMessageExtension()).length > 81920) {
            // errorReq = AP.prepareErrorReq("MessageExtension", _3dsTransID, acsTransID, sdkTransID);
            // return false;
            // }
            // if (creqjson.messageExtension?.count > 10) {
            // errorReq = AP.prepareErrorReq("MessageExtension", _3dsTransID, acsTransID, sdkTransID);
            // return false;
            // }
            // for (MessageExtension me : cRes.getMessageExtension()) {
            // if (me.getCriticalityIndicator()) {
            // if (!Arrays.asList(messageExtensionIDs).contains(me.getId())) {
            // errorReq = AP.prepareErrorReq("MessageExtensionID", _3dsTransID, acsTransID, sdkTransID);
            // return false;
            // }
            // }
            // if (me.getData() == null || me.getData().toString().length() > 8059) {
            // errorReq = AP.prepareErrorReq("MessageExtension", _3dsTransID, acsTransID, sdkTransID);
            // return false;
            // }
            // if (me.getId().length() > 64) {
            // errorReq = AP.prepareErrorReq("MessageExtension", _3dsTransID, acsTransID, sdkTransID);
            // return false;
            // }
            // if (me.getName().length() > 64) {
            // errorReq = AP.prepareErrorReq("MessageExtension", _3dsTransID, acsTransID, sdkTransID);
            // return false;
            // }
            // if (me.getCriticalityIndicator() == null) {
            // errorReq = AP.prepareErrorReq("MessageExtension", _3dsTransID, acsTransID, sdkTransID);
            // return false;
            // }
            // }
        } else if creqjson.challengeInfoTextIndicator == nil || creqjson.challengeInfoTextIndicator == "" {
            errorIssue = "UIComponents"
            isValid = false;
        } else if (creqjson.resendInformationLabel != nil && creqjson.resendInformationLabel == "") {
            errorIssue = "UIComponents"
            isValid = false;
        } else if (creqjson.acsTransID == nil || creqjson.acsTransID == "") {
            errorIssue = "CResIssue"
            isValid = false;
        } else if (creqjson.acsTransID.count != 36) {
            errorIssue = "CResParameters"
            isValid = false;
        } else if (creqjson.acsTransID != challengeParameters.getAcsTransactionID()) {
            errorIssue = "CResParameters"
            isValid = false;
        } else if (creqjson.threeDSServerTransID == nil || creqjson.threeDSServerTransID == "") {
            errorIssue = "CResIssue"
            isValid = false;
        } else if (creqjson.threeDSServerTransID.count != 36) {
            errorIssue = "CResParameters"
            isValid = false;
        } else if creqjson.threeDSServerTransID != challengeParameters.getThreeDSRequestorAppURL() {
            errorIssue = "CResParameters"
            isValid = false;
        } else if (creqjson.sdkTransID == nil || creqjson.sdkTransID == "") {
            errorIssue = "CResIssue"
            isValid = false;
        } else if (creqjson.sdkTransID.count != 36) {
            errorIssue = "CResParameters"
            isValid = false;
        } else if (creqjson.sdkTransID != deviceInfo.sharedDeviceInfo.sdkTransactionID) {
            errorIssue = "CResParameters"
            isValid = false;
        } else if (creqjson.challengeCompletionInd == nil || creqjson.challengeCompletionInd == "") {
            errorIssue = "CResIssue"
            //processError(errorReq.errorCode);
        } else if (creqjson.challengeCompletionInd != "Y") && (creqjson.challengeCompletionInd != "N") {
            errorIssue = "UIComponents"
            isValid = false;
        } else if (creqjson.acsUiType == nil || creqjson.acsUiType == "") {
            errorIssue = "CResIssue"
            isValid = false;
        } else if !acsuitypes.contains(creqjson.acsUiType!) {
            errorIssue = "UIComponents"
            isValid = false;
        } else if (creqjson.acsUiType == "01") {
            if ((creqjson.challengeInfoHeader == nil || creqjson.challengeInfoHeader == "")
                || (creqjson.challengeInfoLabel == nil || creqjson.challengeInfoLabel == "")
                || (creqjson.challengeInfoText == nil || creqjson.challengeInfoText == "")
                || (creqjson.submitAuthenticationLabel == nil || creqjson.submitAuthenticationLabel == "")
                ) {
                errorIssue = "CResIssue"
                isValid = false;
            }
        } else if creqjson.acsUiType == "02" || creqjson.acsUiType == "03" {
            if ((creqjson.challengeInfoHeader == nil || creqjson.challengeInfoHeader == "")
                || (creqjson.challengeInfoLabel == nil || creqjson.challengeInfoLabel == "")
                || (creqjson.challengeInfoText == nil || creqjson.challengeInfoText == "")
                || (creqjson.challengeSelectInfo == nil || (creqjson.challengeSelectInfo?.count)! < 1)
                || (creqjson.submitAuthenticationLabel == nil || creqjson.submitAuthenticationLabel == "")
                ) {
                errorIssue = "CResIssue"
                isValid = false;
            }
        } else if (creqjson.acsUiType == "04") {
            if ((creqjson.challengeInfoHeader == nil || creqjson.challengeInfoHeader == "")
                || (creqjson.challengeInfoText == nil || creqjson.challengeInfoText == "")
                || (creqjson.oobContinueLabel == nil || creqjson.oobContinueLabel == "")
                ) {
                errorIssue = "CResIssue"
                isValid = false;
            }
        } else if (creqjson.acsUiType == "05") && (creqjson.acsHTML == nil || creqjson.acsHTML == "") {
            errorIssue = "CResIssue"
            isValid = false;
        }
        var errorCode = ""
        var errorDescription = ""
        var errorDetail = ""
        switch (errorIssue.lowercased()) {
        case "MessageType".lowercased():
            errorCode = "101"
            //errorReq.setErrorComponent("C"
            errorDescription = "Message is not AReq, ARes, CReq, CRes, PReq, PRes, RReq, or RRes."
            errorDetail = "Message is not AReq, ARes, CReq, CRes, PReq, PRes, RReq, or RRes."
            break;
        case "AcsCounterAtoSNull".lowercased():
            errorCode = "101"
            //errorReq.setErrorComponent("C"
            errorDescription = "Message is not AReq, ARes, CReq, CRes, PReq, PRes, RReq, or RRes."
            errorDetail = "Message is not AReq, ARes, CReq, CRes, PReq, PRes, RReq, or RRes."
            break;
        case "CResIssue".lowercased():
            errorCode = "201"
            //errorReq.setErrorComponent("C"
            errorDescription = "A message element required as defined in Table A.1 is missing from the message."
            errorDetail = "Name of required element(s) that was omitted; if more than one element is detected, this is a comma delimited list."
            break;
        case "MessageExtensionID".lowercased():
            errorCode = "202"
            //errorReq.setErrorComponent("C"
            errorDescription = "Critical message extension not recognised."
            errorDetail = "ID of critical Message Extension(s) that was not recognised; if more than one extension is detected, this is a comma delimited list of message identifiers that were not recognised."
            break;
        case "MessageExtension".lowercased():
            errorCode = "203"
            //errorReq.setErrorComponent("C"
            errorDescription = "Critical message extension not recognised."
            errorDetail = "ID of critical Message Extension(s) that was not recognised; if more than one extension is detected, this is a comma delimited list of message identifiers that were not recognised."
            break;
        case "UIComponents".lowercased():
            errorCode = "203"
            //errorReq.setErrorComponent("C"
            errorDescription = "Data element not in the required format or value is invalid as defined in Table A.1"
            errorDetail = "Name of invalid element(s); if more than one invalid data element is detected, this is a comma delimited list."
            break;
        case "CResParameters".lowercased():
            errorCode = "301"
            //errorReq.setErrorComponent("C"
            errorDescription = "Transaction ID received is not valid for the receiving component."
            errorDetail = "The Transaction ID received was invalid."
            break;
        case "AcsCounterAtoS".lowercased():
            errorCode = "302"
            //errorReq.setErrorComponent("C"
            errorDescription = "Data could not be decrypted by the receiving system due to technical or other reason."
            errorDetail = "CRes Data Issue"
            break;
        case "timeout".lowercased():
            errorCode = "402"
            //errorReq.setErrorComponent("C"
            errorDescription = "Transaction timed-out."
            errorDetail = " Timeout expiry reached for the transaction."
            break;
        default:
            errorCode = "404"
            errorDescription = "Something went wrong"
            errorDetail = "Lot of things went wrong"
        }
        
        if isValid == false {
            let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID ?? (challengeParameters.get3DSServerTransactionID()), acsTransID: creqjson.acsTransID ?? (challengeParameters.getAcsTransactionID()), sdkTransID: creqjson.sdkTransID ?? deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: errorCode , errorDescription: errorDescription , errorDetail: errorDetail)
            transation.progressHud?.show()
            AbstractNetRequest().post(stringData:errorMessage.toJson() , url: acsURL, transation: transation, challengeParameters: challengeParameters, challengeStatusReceiver: challengeStatusReceiver, ui: nil)
            return isValid
        }
        return isValid
    }
    
}


