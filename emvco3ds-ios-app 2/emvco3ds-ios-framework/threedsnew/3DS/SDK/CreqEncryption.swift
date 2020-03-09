//
//  CreqEncryption.swift
//  emvco3ds-ios-app
//
//  Created by Virendra patil on 14/05/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.
//

import UIKit
import CryptoSwift


class CreqEncryption: NSObject {
    var challengeNo = 0

    func getCreq128GCM(acstransId : String  ,get3DSServerTransactionID : String , sdkCounter : Int ,creqJson : String) -> String {
        let dhbyte = deviceInfo.sharedDeviceInfo.dh
        let cek_key = Array((dhbyte!.bytes[0..<16]))
        let protectedHeader = "{\"alg\":\"dir\",\"kid\":\"" + acstransId + "\",\"enc\":\"A128GCM\"}"
        let protectedHeader64 = protectedHeader.data(using: .utf8)?.base64URLEncodedString()
        var ivStr = "\(challengeNo)"
        while ivStr.count != 24 {
            ivStr = "0" + ivStr
        }
        challengeNo = sdkCounter
        var counter = "\(challengeNo)"
        while counter.count != 3 {
            counter = "0" + counter
        }
        let ivData = ivStr.hexadecimal
        let iv = ivData!.bytes
        let gcm = GCM(iv: iv, additionalAuthenticatedData: protectedHeader64!.bytes, mode: .detached)
        let aes = try! AES(key: cek_key, blockMode: gcm, padding: .noPadding)
        //print(creqJson)
        let cipherData = try! aes.encrypt(creqJson.bytes)
        let ciphertextBase64 = Data(bytes: cipherData).base64URLEncodedString()
        let authenticationTagBase64 = Data(bytes: gcm.authenticationTag!).base64URLEncodedString()
        var makeFinal = protectedHeader64! + ".."
        makeFinal = makeFinal + ivData!.base64URLEncodedString() + "."
        makeFinal = makeFinal + ciphertextBase64 + "." + authenticationTagBase64
        challengeNo = challengeNo + 1
        return makeFinal
    }
    
    
}


