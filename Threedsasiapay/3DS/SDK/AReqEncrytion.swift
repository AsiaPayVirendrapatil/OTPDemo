//
//  AReqEncrytion.swift
//  emvco3ds-ios-app
//
//  Created by Vaibhav on 02/05/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.
//

import UIKit
import CryptoSwift
import Alamofire

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
    var SdkCounterStoA = 0
    static let shared = Cres()
    
    func decodeCres(respose: String ,transation : Transaction, challengeParameters: ults_ChallengeParameters, challengeStatusReceiver: ults_ChallengeStatusReceiver , acsURL : String) {
        self.transation = transation
        self.challengeParameters = challengeParameters
        self.challengeStatusReceiver = challengeStatusReceiver
        self.acsURL = acsURL
        let resArr = respose.components(separatedBy: ".")
        guard let decodedData = Data(base64URLEncoded: resArr[0]) else {
            //let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            //challengeStatusReceiver.runtimeError(e)
            challengeStatusReceiver.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation.id), "203", "errorDescription","errorDetail")))
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
        let iv = Data(base64URLEncoded: response[2])
        let ciper = Data(base64URLEncoded: response[3])
        let cek = Array((dh?.bytes[16..<32])!)
        let cbc = CBC(iv: (iv?.bytes)!)
        let aes = try! AES(key: cek, blockMode: cbc, padding: .pkcs7)
        let cipherData = try! aes.decrypt((ciper?.bytes)!)
        let jsonDic = try! JSONSerialization.jsonObject(with: Data(bytes: cipherData), options: []) as! [String : Any]
        self.transation!.progressHud?.close()
        loadUI(jsonDic: jsonDic)
        /*
         let response1 = ["eyJhbGciOiJkaXIiLCJraWQiOiI3OGJkMDM0NS05NDYwLTRmODMtODVkMC0xYTI4MDQ0ZmE0MzEiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2In0","","wBJwXpGhMkqzfrXFTPAklA","_xfrRD5nINovMKMSvKs_O7OLl__TaNFrawIe0MT1sb7UarMI7f3j3OXrKZyttyUwsQzRbJnNCUchZjxhEy6YoWELePyAGqgOT6-TH3rorwK1woVagRCSNe1pbuqDs5aCNroYpoU4DanTddkNK4fomCUZILjiW2BLpbcclaVSz1eesTTLkeUNfJov13QvNVHtiU0DjnP_WXLV9dqGfVu9tyCfTg0FWmzUeVL5vl_OiKvPwkTEmx8hKtfL4udBeGamLNGkV2bxGCcwGHCCOkKMPlpC1CN0gsMZuneRIgPbnhcST7iiLV5Unf1b6n1KQWbsbdg0A443m0gLhKLMm8BtzXT4v3kS5vOYbspfmGO5sFvXwXB2in-dNGiWEkyK9I_eIYWrZa0NOnjVYMq01T2i5Ce4Kl56EIYAXiIyocXP6nkk2rmbr2dtGWtsUZ16JZMmee_CCLPlUY5bMh1O6isldo5BnVWv1siuVVPMeDqiy3ObOh7Hh2fvHuLKiVWNX-CxUvoXvqupnwlcfFzZV9JrT_LymR1Kf2IX9wViL1B2RfGmtCRdv6ddNeT6XlzpW1Y2Dda1FUfMOQo0aTav7f304RtNEyT4Ks6aHfJl4pllP_NdV3Dl0S13NVhMZueuNuNv8i3CNFY6Kz2OtbyRQUB9AFLDb_FGO4OjF2mgh_Ua9hr8msJSYiYo9c-gByj8oBgtVW3K_cyEVL8vwtUt1JLyzgxIHFMBCJDEiDmIYA8MZvqIUC2i5Dhhn1gUfnNRjqeHPOMmSF0nQpoKvewt8trUoHTPFyQWnDrDSd6uFwMXijT8slDK6rKNb2xJxk4RzFt43Mf1-NFUBQTqfBaHLArkjAk6LDf_iKGA-xqYuDxVp90GlXx7FbghG7zbOvDUbFyP9TqxoHX5mV7xZKhe5N7HWkb3mg-9g0jgTfvfSxIIyg9A6E0-gX9rRvvPfxHUZ3ob7RF-34_3gsuqLV1_iVfUXL2OiBhI44D-xBfh9G3f1fwkf-_eHXIOB38bUVlLxsYJkaA9Km_0wCZduRZNJL2r1qoOQ3On3jp34TD8nEYQxNE-8Hcai4ljX-hv3IwYbPijAr9WfQpgbOuio6Splm3bivLsS0nj9DejM2iAjEYFh_tCqTa_ZlvRgtlZkqrDWe2KogGePECTQoTPipagsUN5zwnBEpZo4-CvFYMGE9xX9SHuXMpat__xZT_OWEHqH8dSJiGoDTDaRbcfAo5WYFs5KK-PpIlxr9oik51BE3pb3QP4d8HZaDNRycm5efEOVT7P1ivRwxk1sro54je02SDXHT3rIalAEP-_TdcaN2J66R0","Bg78GJo0emEdCDmxOBBjoA"]
         let dh = isDebugged().hexa("7B5130D15E77E307F753F69978A29EF03E50F59B9F0581A93FB4BDAAC3550F71")
         let iv = Data(base64URLEncoded: response1[2])
         let ciper = Data(base64URLEncoded: response1[3])
         let cek = Array(dh.bytes[16..<32])
         let cbc = CBC.init(iv: (iv?.bytes)!)
         let aes = try! AES(key: cek, blockMode: cbc, padding: .pkcs7)
         let decryptedAES = try! aes.decrypt((ciper?.bytes)!)
         let jsonDic = try! JSONSerialization.jsonObject(with: Data(bytes: decryptedAES), options: []) as! [String : Any]
         print(jsonDic)
         */
    }
    
    
    func loadUI(jsonDic : [String: Any]) {
        let creqjson = CresData.init(fromDictionary: jsonDic)
        let supportedMessageVersion = ["2.1.0", "2.2.0"]
        let acsuitypes = ["01","02","03","04","05"]
        let messageExtensionIDs = ["EmvCoID1", "EmvCoID2"]
        var isValid = true
        var errorCode = ""
        var messageType = ""
        var isChallengeSelectInfoError = false
        
        print(jsonDic)
        /*
         if responce().validation(jsonDic: jsonDic, challengeParameters: self.challengeParameters!, transation: self.transation!, acsURL: self.acsURL, challengeStatusReceiver: self.challengeStatusReceiver!) == false {
         return
         }
         */
        //        if creqjson.challengeSelectInfoErr != nil {
        //            errorCode = "203"
        //            isValid = false
        //        }
        
        if creqjson.challengeSelectInfo == nil && creqjson.challengeSelectInfoErr == nil {
            isChallengeSelectInfoError = false
        } else if creqjson.challengeSelectInfoErr != nil {
            
            if creqjson.acsUiType == "02" || creqjson.acsUiType == "03" {
                isChallengeSelectInfoError = false
            } else{
                isChallengeSelectInfoError = true
            }
        } else if creqjson.challengeSelectInfo != nil {
            isChallengeSelectInfoError = false
        }
        
        
        if isChallengeSelectInfoError {
            errorCode = "203"
            isValid = false
        } else if ((jsonDic["messageType"] as? String) == nil) {
            errorCode = "101"
            isValid = false
        } else if creqjson.challengeCompletionInd == nil || creqjson.challengeCompletionInd == "" {
            errorCode = "201"
            isValid = false
        } else if (creqjson.challengeCompletionInd != "Y") && (creqjson.challengeCompletionInd != "N") {
            errorCode = "203"
            isValid = false
        } else if  creqjson.acsTransID == nil || creqjson.acsTransID == "" {
            creqjson.acsTransID = ""
            errorCode = "201"
            isValid = false
        } else if creqjson.acsTransID.count != 36 {
            errorCode = "301"
            isValid = false
        }  else if creqjson.acsTransID != challengeParameters?.getAcsTransactionID() {
            errorCode = "301"
            isValid = false
        } else if creqjson.challengeCompletionInd == "Y" {
            if creqjson.transStatus != nil && creqjson.transStatus != "" {
                
                let Completeevent = CompletionEvent((jsonDic["sdkTransID"] as! String), (jsonDic["transStatus"] as! String))
                challengeStatusReceiver!.completed(Completeevent)
                self.transation!.cUI?.dismiss(animated: true, completion: nil)
                return
            } else if creqjson.transStatus == nil || creqjson.transStatus == "" {
                errorCode = "201"
                isValid = false
            }
        } else if creqjson.sdkTransID == nil || creqjson.sdkTransID! == "" {
            creqjson.sdkTransID = ""
            errorCode = "201"
            isValid = false
        } else if creqjson.sdkTransID.count != 36 {
            errorCode = "301"
            isValid = false
        } else if creqjson.sdkTransID != deviceInfo.sharedDeviceInfo.sdkTransactionID {
            errorCode = "301"
            isValid = false
        } else  if creqjson.threeDSServerTransID == nil || creqjson.threeDSServerTransID == "" {
            creqjson.threeDSServerTransID = ""
            errorCode = "201"
            isValid = false
        } else if creqjson.threeDSServerTransID.count != 36 {
            errorCode = "301"
            isValid = false
        } else if creqjson.threeDSServerTransID != challengeParameters!.get3DSServerTransactionID() {
            creqjson.threeDSServerTransID = ""
            errorCode = "301"
            isValid = false
        } else if creqjson.messageType == nil || creqjson.messageType == "" {
            errorCode = "201"
            isValid = false
        } else if creqjson.messageType != "CRes" {
            errorCode = "101"
            isValid = false
        } else if ((jsonDic["messageType"] as? String) == nil) {
            let errorMessage = ErrorCReq.init(threeDSServerTransID: (challengeParameters?.get3DSServerTransactionID())!, acsTransID: (challengeParameters?.getAcsTransactionID())!, sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: "302", errorDescription: "errorDescription", errorDetail: "errorDetail" , message: messageType)
            self.transation!.progressHud?.show()
            challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "302", "Error", "Error")))
            APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
            isValid = true
            return
        } else if creqjson.challengeInfoText != nil &&  creqjson.challengeInfoText == "" {
            errorCode = "203"
            isValid = false
        } else  if creqjson.acsCounterAtoS  ==  nil || creqjson.acsCounterAtoS  ==  "" {
            errorCode = "201"
            isValid = false
        } else if Int(creqjson.acsCounterAtoS)  != SdkCounterStoA {
            errorCode = "302"
            messageType = creqjson.messageType
            isValid = false
            let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID, acsTransID: creqjson.acsTransID, sdkTransID: creqjson.sdkTransID, errorCode: errorCode, errorDescription: "errorDescription", errorDetail: "errorDetail" , message: messageType)
            APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "302")
            return
        } else if creqjson.messageVersion == nil || creqjson.messageVersion! == "" {
            errorCode = "201"
            isValid = false
        } else if !supportedMessageVersion.contains(creqjson.messageVersion!) {
            errorCode = "203"
            isValid = false
        } else if creqjson.acsUiType == nil || creqjson.acsUiType == "" {
            errorCode = "201"//301
            isValid = false
        } else if !acsuitypes.contains(creqjson.acsUiType!) {
            errorCode = "203"
            isValid = false
        } else if (creqjson.messageExtension != nil) {
            let arr = creqjson.messageExtension! as NSArray
            if (creqjson.messageExtension?.count ?? 0)!  > 10 {
                errorCode = "203"
                isValid = false
            }
            for i in 0 ..< arr.count {
                let data = try! JSONSerialization.data(withJSONObject: (arr.object(at: i)as AnyObject).value(forKey: "data") as Any, options: [])
                if (arr.object(at: i)as AnyObject).value(forKey: "criticalityIndicator")as! Bool {
                    if !messageExtensionIDs.contains((arr.object(at: i)as AnyObject).value(forKey: "id")as! String) {
                        errorCode = "202"
                        isValid = false
                        break
                    }
                } else  if ((arr.object(at: i)as AnyObject).value(forKey: "data") as! NSDictionary).count == 0 || data.count > 8059 {
                    errorCode = "203"
                    isValid = false
                } else if ((arr.object(at: i)as AnyObject).value(forKey: "id")as! String).count > 64 {
                    errorCode = "203"
                    isValid = false
                } else if ((arr.object(at: i)as AnyObject).value(forKey: "name")as! String).count > 64 {
                    errorCode = "203"
                    isValid = false
                }
            }
            if isValid == false {
                let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID, acsTransID: creqjson.acsTransID, sdkTransID: creqjson.sdkTransID, errorCode: errorCode, errorDescription: "errorDescription", errorDetail: "errorDetail" , message: messageType)
                self.transation!.progressHud?.show()
                challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, errorCode, "Error", "Error")))
                APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
                return
            }
        } else if creqjson.challengeInfoTextIndicator != nil && creqjson.challengeInfoTextIndicator == "" {
            errorCode = "203"
            isValid = false
        } else if (creqjson.resendInformationLabel != nil && creqjson.resendInformationLabel == "") {
            errorCode = "203"
            isValid = false
        } else if creqjson.acsUiType == "05" {
            if creqjson.acsHTML == nil || creqjson.acsHTML == "" {
                errorCode = "201"
                isValid = false
            }
        } else {
            if creqjson.challengeInfoHeader == nil || creqjson.challengeInfoHeader == "" || creqjson.challengeInfoText == nil || creqjson.challengeInfoText == "" {
                errorCode = "201"
                isValid = false
            } else {
                if creqjson.acsUiType == "01" {
                    if creqjson.challengeInfoLabel == nil || creqjson.challengeInfoLabel == "" || creqjson.submitAuthenticationLabel == nil || creqjson.submitAuthenticationLabel == "" {
                        errorCode = "201"
                        isValid = false
                    } else {
                        if (jsonDic["challengeSelectInfo"] is String) {
                            //print("113")
                            errorCode = "203"
                            isValid = false
                        }
                    }
                }
                if creqjson.acsUiType == "02" || creqjson.acsUiType == "03" {
                    if creqjson.challengeInfoLabel == nil || creqjson.challengeInfoLabel == "" || creqjson.challengeSelectInfo == nil || creqjson.submitAuthenticationLabel == nil || creqjson.submitAuthenticationLabel == "" {
                        errorCode = "201"
                        isValid = false
                    }
                }
                if creqjson.acsUiType == "04" {
                    if creqjson.oobContinueLabel == nil || creqjson.oobContinueLabel == "" {
                        errorCode = "201"
                        isValid = false
                    }
                }
            }
        }
        if isValid == false {
            let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID ?? (challengeParameters?.get3DSServerTransactionID())!, acsTransID: creqjson.acsTransID ?? (challengeParameters?.getAcsTransactionID())!, sdkTransID: creqjson.sdkTransID ?? deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: errorCode, errorDescription: "errorDescription", errorDetail: "errorDetail" , message: messageType)
            self.transation!.progressHud?.show()
            challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, errorCode, "Error", "Error")))
            APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
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
                challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "302", "errorDescription","errorDetail")))
                //let e = RuntimeErrorEvent.init("203", "Invalid Argument")
                //challengeStatusReceiver!.runtimeError(e)
                return
            }
            let Completeevent = CompletionEvent((jsonDic["sdkTransID"] as! String), (jsonDic["transStatus"] as! String))
            challengeStatusReceiver!.completed(Completeevent)
            self.transation!.cUI?.dismiss(animated: true, completion: nil)
        } else {
            self.transation?.cUI?.dismiss(animated: true, completion: nil)
            SdkCounterStoA = SdkCounterStoA + 1
            
            let frameBundle = Bundle(for: AReqEncrytion.self)
            let mainStoryBoard = UIStoryboard(name: "UIChallengeMain", bundle: frameBundle)
            
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
            transation!.cUI = navigationController
            UIApplication.shared.keyWindow?.rootViewController!.present(navigationController!, animated: true, completion: nil)
        }
    }
    /*{//working code
     let creqjson = CresData.init(fromDictionary: jsonDic)
     let supportedMessageVersion = ["2.1.0", "2.2.0"]
     let acsuitypes = ["01","02","03","04","05"]
     let messageExtensionIDs = ["EmvCoID1", "EmvCoID2"]
     var isValid = true
     var errorCode = ""
     var messageType = ""
     print(jsonDic)
     /*
     if responce().validation(jsonDic: jsonDic, challengeParameters: self.challengeParameters!, transation: self.transation!, acsURL: self.acsURL, challengeStatusReceiver: self.challengeStatusReceiver!) == false {
     return
     }
     */
     //if creqjson.challengeSelectInfoErr != nil {
     //errorCode = "203"
     //isValid = false
     //}
     
     if ((jsonDic["messageType"] as? String) == nil) {
     errorCode = "101"
     isValid = false
     //let errorMessage = ErrorCReq.init(threeDSServerTransID: jsonDic["threeDSServerTransID"] as! String, acsTransID: jsonDic["acsTransID"] as! String, sdkTransID: jsonDic["sdkTransID"] as! String, errorCode: "101")
     //self.transation!.progressHud?.show()
     //AbstractNetRequest().post(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil)
     //isValid = true
     } else if creqjson.challengeCompletionInd == nil || creqjson.challengeCompletionInd == "" {
     errorCode = "201"
     isValid = false
     } else if (creqjson.challengeCompletionInd != "Y") && (creqjson.challengeCompletionInd != "N") {
     errorCode = "203"
     isValid = false
     } else if creqjson.sdkTransID == nil || creqjson.sdkTransID == "" {
     creqjson.sdkTransID = ""
     errorCode = "201"
     isValid = false
     } else if creqjson.sdkTransID != deviceInfo.sharedDeviceInfo.sdkTransactionID {
     errorCode = "301"
     isValid = false
     } else if  creqjson.acsTransID == nil || creqjson.acsTransID == "" {
     creqjson.acsTransID = ""
     errorCode = "201"
     isValid = false
     } else if creqjson.acsTransID.count != 36 {
     errorCode = "301"
     isValid = false
     } else if  creqjson.threeDSServerTransID == nil || creqjson.threeDSServerTransID == "" {
     creqjson.threeDSServerTransID = ""
     errorCode = "201"
     isValid = false
     } else if creqjson.threeDSServerTransID.count != 36 {
     errorCode = "301"
     isValid = false
     //} else if creqjson.sdkTransID.count != 36 {
     //errorCode = "301"
     //isValid = false
     }  else if creqjson.acsTransID != challengeParameters?.getAcsTransactionID() {
     errorCode = "301"
     isValid = false
     } else if creqjson.threeDSServerTransID != challengeParameters!.get3DSServerTransactionID() {
     creqjson.threeDSServerTransID = ""
     errorCode = "301"
     isValid = false
     } else if creqjson.challengeCompletionInd == "Y" {
     if creqjson.transStatus != nil && creqjson.transStatus != "" {
     //<<<<<<< HEAD
     if (creqjson.challengeSelectInfoErr != nil) {
     errorCode = "203"
     isValid = false
     } else {
     let Completeevent = CompletionEvent((jsonDic["sdkTransID"] as! String), (jsonDic["transStatus"] as! String))
     challengeStatusReceiver!.completed(Completeevent)
     self.transation!.cUI?.dismiss(animated: true, completion: nil)
     return
     }
     //=======
     //if (creqjson.challengeSelectInfo == nil) {
     //errorCode = "203"
     //isValid = false
     //} else {
     //let Completeevent = CompletionEvent((jsonDic["sdkTransID"] as! String), (jsonDic["transStatus"] as! String))
     //challengeStatusReceiver!.completed(Completeevent)
     //self.transation!.cUI?.dismiss(animated: true, completion: nil)
     //return
     //}
     //>>>>>>> b32e266b068f17ee7fb49afa557ad05a5ab72f62
     //errorCode = "301"//"201"
     //isValid = false
     } else if creqjson.transStatus == nil || creqjson.transStatus == "" {
     errorCode = "201"
     isValid = false
     }
     } else if creqjson.messageType == nil || creqjson.messageType == "" {
     errorCode = "201"
     isValid = false
     } else if creqjson.messageType != "CRes" {
     errorCode = "101"
     isValid = false
     } else if ((jsonDic["messageType"] as? String) == nil) {
     let errorMessage = ErrorCReq.init(threeDSServerTransID: (challengeParameters?.get3DSServerTransactionID())!, acsTransID: (challengeParameters?.getAcsTransactionID())!, sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: "302", errorDescription: "errorDescription", errorDetail: "errorDetail" , message: messageType)
     self.transation!.progressHud?.show()
     challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "302", "Error", "Error")))
     APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
     isValid = true
     return
     } else if creqjson.challengeInfoText != nil &&  creqjson.challengeInfoText == "" {
     errorCode = "203"
     isValid = false
     } else  if creqjson.acsCounterAtoS  ==  nil || creqjson.acsCounterAtoS  ==  "" {
     errorCode = "201"
     isValid = false
     } else if Int(creqjson.acsCounterAtoS)  != SdkCounterStoA {
     errorCode = "302"
     messageType = creqjson.messageType
     isValid = false
     let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID, acsTransID: creqjson.acsTransID, sdkTransID: creqjson.sdkTransID, errorCode: errorCode, errorDescription: "errorDescription", errorDetail: "errorDetail" , message: messageType)
     transation!.cUI?.dismiss(animated: true, completion: nil)
     APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "302")
     return
     } else if creqjson.messageVersion == nil || creqjson.messageVersion! == "" {
     errorCode = "201"
     isValid = false
     } else if !supportedMessageVersion.contains(creqjson.messageVersion!) {
     errorCode = "203"
     isValid = false
     } else if creqjson.acsUiType == nil || creqjson.acsUiType == "" {
     errorCode = "201"//301
     isValid = false
     } else if !acsuitypes.contains(creqjson.acsUiType!) {
     errorCode = "203"
     isValid = false
     } else if (creqjson.messageExtension != nil) {
     let arr = creqjson.messageExtension! as NSArray
     if (creqjson.messageExtension?.count ?? 0)!  > 10 {
     errorCode = "203"
     isValid = false
     }
     for i in 0 ..< arr.count {
     let data = try! JSONSerialization.data(withJSONObject: (arr.object(at: i)as AnyObject).value(forKey: "data") as Any, options: [])
     if (arr.object(at: i)as AnyObject).value(forKey: "criticalityIndicator")as! Bool {
     if !messageExtensionIDs.contains((arr.object(at: i)as AnyObject).value(forKey: "id")as! String) {
     errorCode = "202"
     isValid = false
     break
     }
     } else  if ((arr.object(at: i)as AnyObject).value(forKey: "data") as! NSDictionary).count == 0 || data.count > 8059 {
     errorCode = "203"
     isValid = false
     } else if ((arr.object(at: i)as AnyObject).value(forKey: "id")as! String).count > 64 {
     errorCode = "203"
     isValid = false
     } else if ((arr.object(at: i)as AnyObject).value(forKey: "name")as! String).count > 64 {
     errorCode = "203"
     isValid = false
     }
     }
     if isValid == false {
     let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID, acsTransID: creqjson.acsTransID, sdkTransID: creqjson.sdkTransID, errorCode: errorCode, errorDescription: "errorDescription", errorDetail: "errorDetail" , message: messageType)
     self.transation!.progressHud?.show()
     challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, errorCode, "Error", "Error")))
     APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
     return
     }
     } else if creqjson.challengeInfoTextIndicator != nil && creqjson.challengeInfoTextIndicator == "" {
     errorCode = "203"
     isValid = false
     } else if (creqjson.resendInformationLabel != nil && creqjson.resendInformationLabel == "") {
     errorCode = "203"
     isValid = false
     } else if creqjson.acsUiType == "05" {
     if creqjson.acsHTML == nil || creqjson.acsHTML == "" {
     errorCode = "201"
     isValid = false
     }
     } else {
     if creqjson.challengeInfoHeader == nil || creqjson.challengeInfoHeader == "" || creqjson.challengeInfoText == nil || creqjson.challengeInfoText == "" {
     errorCode = "201"
     isValid = false
     } else {
     if creqjson.acsUiType == "01" {
     if creqjson.challengeInfoLabel == nil || creqjson.challengeInfoLabel == "" || creqjson.submitAuthenticationLabel == nil || creqjson.submitAuthenticationLabel == "" {
     errorCode = "201"
     isValid = false
     } else {
     if (jsonDic["challengeSelectInfo"] is String) {
     //print("113")
     errorCode = "203"
     isValid = false
     }
     }
     }
     if creqjson.acsUiType == "02" || creqjson.acsUiType == "03" {
     if creqjson.challengeInfoLabel == nil || creqjson.challengeInfoLabel == "" || creqjson.challengeSelectInfo == nil || creqjson.submitAuthenticationLabel == nil || creqjson.submitAuthenticationLabel == "" {
     errorCode = "201"
     isValid = false
     }
     }
     if creqjson.acsUiType == "04" {
     if creqjson.oobContinueLabel == nil || creqjson.oobContinueLabel == "" {
     errorCode = "201"
     isValid = false
     }
     }
     }
     }
     if isValid == false {
     let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID ?? (challengeParameters?.get3DSServerTransactionID())!, acsTransID: creqjson.acsTransID ?? (challengeParameters?.getAcsTransactionID())!, sdkTransID: creqjson.sdkTransID ?? deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: errorCode, errorDescription: "errorDescription", errorDetail: "errorDetail" , message: messageType)
     self.transation!.progressHud?.show()
     challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, errorCode, "Error", "Error")))
     APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
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
     challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "302", "errorDescription","errorDetail")))
     //let e = RuntimeErrorEvent.init("203", "Invalid Argument")
     //challengeStatusReceiver!.runtimeError(e)
     return
     }
     let Completeevent = CompletionEvent((jsonDic["sdkTransID"] as! String), (jsonDic["transStatus"] as! String))
     challengeStatusReceiver!.completed(Completeevent)
     self.transation!.cUI?.dismiss(animated: true, completion: nil)
     } else {
     self.transation?.cUI?.dismiss(animated: true, completion: nil)
     SdkCounterStoA = SdkCounterStoA + 1
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
     transation!.cUI = navigationController
     UIApplication.shared.keyWindow?.rootViewController!.present(navigationController!, animated: true, completion: nil)
     }
     }*/
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


class APICall {
    static let shared = APICall()
    var transation : Transaction!
    var challengeParameters : ults_ChallengeParameters!
    var challengeStatusReceiver : ults_ChallengeStatusReceiver!
    var acsURL  : String = ""
    var cUI :UIViewController?
    
    func postError(stringData: String, url: String, tag: String? = nil , transation : Transaction , challengeParameters: ults_ChallengeParameters, challengeStatusReceiver: ults_ChallengeStatusReceiver , ui: UIViewController? , withCode: String) {
        self.transation = transation
        self.challengeParameters = challengeParameters
        self.challengeStatusReceiver = challengeStatusReceiver
        self.cUI = ui
        if url == "" {
            acsURL = transation.acsURL
        } else {
            acsURL = url
        }
        var request = URLRequest(url: URL(string: acsURL)!)
        request.httpMethod = "POST"
        //let postHeaders : HTTPHeaders  = ["content-type" : "application/jose;charset=UTF-8", "method": "POST"]
        //request.setValue("POST", forHTTPHeaderField: "method")
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        //request.timeoutInterval = 11
        //let postString = stringData
        request.httpBody = stringData.data(using: .utf8)
        print(stringData)
        //Alamofire.upload(stringData.data(using: .utf8)!, to: url ,method : Alamofire.HTTPMethod.post, headers: postHeaders).response { (response) in
        //print(response.data?.count)
        //}
        Alamofire.request(request).response(completionHandler: { response in
            if response.error == nil {} else {}})
        if withCode != "" {
            challengeStatusReceiver.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation.id), withCode, "Counter", "Counter")))
        } else {
            transation.cUI?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func post(stringData: String, url: String, tag: String? = nil , transation : Transaction , challengeParameters: ults_ChallengeParameters, challengeStatusReceiver: ults_ChallengeStatusReceiver , ui: UIViewController?) {
        //let postHeaders : HTTPHeaders  = ["content-type" : "application/jose;charset=UTF-8", "method": "POST"]
        self.transation = transation
        self.challengeParameters = challengeParameters
        self.challengeStatusReceiver = challengeStatusReceiver
        self.cUI = ui
        if url == "" {
            acsURL = transation.acsURL
        } else {
            acsURL = url
        }
        var request = URLRequest(url: URL(string: acsURL)!)
        request.httpMethod = "POST"
        //let postHeaders : HTTPHeaders  = ["content-type" : "application/jose;charset=UTF-8", "method": "POST"]
        //request.setValue("POST", forHTTPHeaderField: "method")
        request.setValue("application/jose;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 11
        //let postString = stringData
        request.httpBody = stringData.data(using: .utf8)
        print(stringData)
        //Alamofire.upload(stringData.data(using: .utf8)!, to: url ,method : Alamofire.HTTPMethod.post, headers: postHeaders).response { (response) in
        //print(response.data?.count)
        //}
        Alamofire.request(request).response(completionHandler: { response in
            //self.cUI?.navigationController?.dismiss(animated: true, completion: nil)
            if response.timeline.totalDuration > 10 {
                let err = ErrorCReq.init(threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: "402", errorDescription: "Timeout", errorDetail: "Timeout", message: "")
                //challengeStatusReceiver.timedout()
                //challengeStatusReceiver.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation.id), "402", "Error", "Error")))
                APICall.shared.postError(stringData:err.toJson() , url: self.acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
                let e = RuntimeErrorEvent.init("402", "Timeout")
                challengeStatusReceiver.runtimeError(e)
            } else {
                if response.error == nil {
                    /*
                     if data == nil || data?.count == 0 {
                     print("No resonse this issue")
                     let errorMessage = ErrorMessage.init((self.challengeParameters?.getAcsTransactionID())!, "201", "Name of required element(s) that was omitted; if more than one element is detected, this is a comma delimited list.", "Protocol Error")
                     let protocolErrorevent = ProtocolErrorEvent.init((self.challengeParameters?.getAcsTransactionID())!, errorMessage)
                     challengeStatusReceiver?.protocolError(protocolErrorevent)
                     let e = RuntimeErrorEvent.init("203", "Invalid Argument")
                     challengeStatusReceiver!.runtimeError(e)
                     }
                     if response.timeline.requestDuration > 10 {
                     let errc = ErrorCReq.init(threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: "402", errorDescription: "errorDescription", errorDetail: "errorDetail")
                     //self.transation!.progressHud?.show()
                     APICall.shared.post(stringData:errc.toJson() , url: self.acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil)
                     let e = RuntimeErrorEvent.init("203", "Invalid Argument")
                     challengeStatusReceiver.runtimeError(e)
                     } else {
                     self.handleResponse(tag: tag, httpUrlResponse: response.response, error: response.error)
                     self.showResponse(data: response.data)
                     self.handleDefaultSucessIfAny(tag:tag, response: response)
                     }
                     }.validate(statusCode: 200 ..< 300)
                     */
                    if response.data == nil || response.data?.count == 0 {
                        print("No resonse this issue")
                        let errorMessage = ErrorMessage.init(self.challengeParameters.getAcsTransactionID(), "201", "Name of required element(s) that was omitted; if more than one element is detected, this is a comma delimited list.", "Protocol Error")
                        let protocolErrorevent = ProtocolErrorEvent.init((self.challengeParameters?.getAcsTransactionID())!, errorMessage)
                        self.challengeStatusReceiver.protocolError(protocolErrorevent)
                        let e = RuntimeErrorEvent.init("203", "Invalid Argument")
                        challengeStatusReceiver.runtimeError(e)
                    } else {
                        let responseBodyString = String(data: response.data!, encoding: String.Encoding.utf8)!
                        //Log.i(object: self, message: "\(String(describing: responseBodyString))")
                        //self.cUI?.navigationController?.dismiss(animated: true, completion: nil)
                        if responseBodyString != "" {
                            Cres.shared.decodeCres(respose: responseBodyString, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, acsURL: self.acsURL)
                            //} else {
                            //let errorMessage =  ErrorMessage.init((self.challengeParameters?.getAcsTransactionID())!, "201", "Tag Mismatch", "Protocol Error")
                            //let protocolErrorevent = ProtocolErrorEvent.init((self.challengeParameters?.getAcsTransactionID())!, errorMessage)
                            //challengeStatusReceiver?.protocolError(protocolErrorevent)
                            //let e = RuntimeErrorEvent.init("201", "Invalid Argument")
                            //challengeStatusReceiver!.runtimeError(e)
                            //}
                            try! transation.close()
                        }
                        //Log.i(object: self, message: "no response")
                    }
                    //if let valJSON = response.result.value {
                    //}
                } else {
                    let err = ErrorCReq.init(threeDSServerTransID: challengeParameters.get3DSServerTransactionID(), acsTransID: challengeParameters.getAcsTransactionID(), sdkTransID: deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: "402", errorDescription: "Timeout", errorDetail: "Timeout", message: "")
                    APICall.shared.postError(stringData:err.toJson() , url: self.acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: nil, withCode: "")
                    //let e = RuntimeErrorEvent.init("203", "Timeout")
                    //challengeStatusReceiver.runtimeError(e)
                    challengeStatusReceiver.timedout()
                    //print("\n\nAuth request failed with error:\n \(response.error)")
                }}
        })
    }
    
}

/*
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
 let errorMessage = ErrorCReq.init(threeDSServerTransID: creqjson.threeDSServerTransID ?? (challengeParameters.get3DSServerTransactionID()), acsTransID: creqjson.acsTransID ?? (challengeParameters.getAcsTransactionID()), sdkTransID: creqjson.sdkTransID ?? deviceInfo.sharedDeviceInfo.sdkTransactionID, errorCode: errorCode , errorDescription: errorDescription , errorDetail: errorDetail , message: "")
 transation.progressHud?.show()
 challengeStatusReceiver.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation.id), errorCode, "Error", "Error")))
 APICall.shared.postError(stringData:errorMessage.toJson() , url: acsURL, transation: transation, challengeParameters: challengeParameters, challengeStatusReceiver: challengeStatusReceiver, ui: nil, withCode: "")
 return isValid
 }
 return isValid
 }
 
 }
 */

