//
//  UtilExtension.swift
//  emvco3ds-ios-app
//
//  Created by Vaibhav on 29/04/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.
//

import UIKit
import CryptoSwift


extension Data {
    private static let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }
    
    
    public func hexEncodedString() -> String {
        return String(self.reduce(into: "".unicodeScalars, { (result, value) in
            result.append(Data.hexAlphabet[Int(value/16)])
            result.append(Data.hexAlphabet[Int(value%16)])
        }))
    }
    
    
    var string: String? { return String(data: self, encoding: .utf8) }
    
    
    var hexString: String? {
        return withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            let charA = UInt8(UnicodeScalar("a").value)
            let char0 = UInt8(UnicodeScalar("0").value)
            func itoh(_ value: UInt8) -> UInt8 {
                return (value > 9) ? (charA + value - 10) : (char0 + value)
            }
            let hexLen = count * 2
            let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: hexLen)
            for i in 0 ..< count {
                ptr[i*2] = itoh((bytes[i] >> 4) & 0xF)
                ptr[i*2+1] = itoh(bytes[i] & 0xF)
            }
            return String(bytesNoCopy: ptr,
                          length: hexLen,
                          encoding: .utf8,
                          freeWhenDone: true)
        }
    }
    
    
    
    init?(fromHexEncodedString string: String) {
        // Convert 0 ... 9, a ... f, A ...F to their decimal value,
        // return nil for all other input characters
        func decodeNibble(u: UInt16) -> UInt8? {
            switch(u) {
            case 0x30 ... 0x39:
                return UInt8(u - 0x30)
            case 0x41 ... 0x46:
                return UInt8(u - 0x41 + 10)
            case 0x61 ... 0x66:
                return UInt8(u - 0x61 + 10)
            default:
                return nil
            }
        }
        self.init(capacity: string.utf16.count/2)
        var even = true
        var byte: UInt8 = 0
        for c in string.utf16 {
            guard let val = decodeNibble(u: c) else { return nil }
            if even {
                byte = val << 4
            } else {
                byte += val
                self.append(byte)
            }
            even = !even
        }
        guard even else { return nil }
    }
    //}
    //JOSESwift
    //extension Data {
    // Creates a new data buffer from a base64url encoded string.
    //
    // - Parameter base64URLString: The base64url encoded string to parse.
    // - Returns: `nil` if the input is not recognized as valid base64url.
    
    
    public init?(base64URLEncoded base64URLString: String) {
        var s = base64URLString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let mod = s.count % 4
        switch mod {
        case 0: break
        case 2: s.append("==")
        case 3: s.append("=")
        default: return nil
        }
        self.init(base64Encoded: s)
    }
    
    // Creates a new data buffer from base64url, UTF-8 encoded data.
    //
    // - Parameter base64URLData: The base64url, UTF-8 encoded data.
    // - Returns: `nil` if the input is not recognized as valid base64url.
    
    
    public init?(base64URLEncoded base64URLData: Data) {
        guard let s = String(data: base64URLData, encoding: .utf8) else {
            return nil
        }
        self.init(base64URLEncoded: s)
    }
    
    // Returns a base64url encoded string.
    //
    // - Returns: The base64url encoded string.
    
    
    public func base64URLEncodedString() -> String {
        let s = self.base64EncodedString()
        return s
            .replacingOccurrences(of: "=", with: "")
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
    
    // Returns base64url encoded data.
    //
    // - Returns: The base64url encoded data.
    
    
    public func base64URLEncodedData() -> Data {
        // UTF-8 can represent [all Unicode characters](https://en.wikipedia.org/wiki/UTF-8), so this
        // forced unwrap is safe. See also [this](https://stackoverflow.com/a/46152738/5233456) SO answer.
        return self.base64URLEncodedString().data(using: .utf8)!
    }
    
    // Returns the byte length of a data object as octet hexadecimal data.
    //
    // - Returns: The data byte length as octet hexadecimal data.
    
    
    func getByteLengthAsOctetHexData() -> Data {
        let dataLength = UInt64(self.count * 8)
        let dataLengthInHex = String(dataLength, radix: 16, uppercase: false)
        var dataLengthBytes = [UInt8](repeatElement(0x00, count: 8))
        var dataIndex = dataLengthBytes.count-1
        for i in stride(from: 0, to: dataLengthInHex.count, by: 2) {
            var offset = 2
            var hexStringChunk = ""
            if dataLengthInHex.count-i == 1 {
                offset = 1
            }
            let endIndex = dataLengthInHex.index(dataLengthInHex.endIndex, offsetBy: -i)
            let startIndex = dataLengthInHex.index(endIndex, offsetBy: -offset)
            let range = Range(uncheckedBounds: (lower: startIndex, upper: endIndex))
            hexStringChunk = String(dataLengthInHex[range])
            if let hexByte = UInt8(hexStringChunk, radix: 16) {
                dataLengthBytes[dataIndex] = hexByte
            }
            dataIndex -= 1
        }
        return Data(bytes: dataLengthBytes)
    }
    //}
    
    
    //extension Data {
    public init(_ data: Data) {
        self = data
    }
    
    
    public func data() -> Data {
        return self
    }
}


extension Array {
    
    
    func split() -> (left: [Element], right: [Element]) {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}


extension String {
    
    
    var data: Data  {
        return Data(utf8)
    }
    
    
    func generateSHA256(key: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key, key.count, self, self.count, &digest)
        let data = Data(bytes: digest)
        return data.map { String(format: "%02hhx", $0) }.joined()
    }
    
    
    func tail(index : Int) -> String {
        return String(self.suffix(from: self.index(self.startIndex, offsetBy: index)))
    }
    
    
    func toHexadecimal() -> String {
        let data = Data(self.utf8)
        return data.map{ String(format:"%02x", $0) }.joined()
    }
    
    
    var hexaBytes: [UInt8] {
        var position = startIndex
        //return (0..<count/2).flatMap { _ in    // for Swift 4.1 or later use compactMap instead of flatMap
        return (0..<count/2).compactMap { _ in    // for Swift 4.1 or later use compactMap instead of flatMap
            defer { position = index(position, offsetBy: 2) }
            return UInt8(self[position...index(after: position)], radix: 16)
        }
    }
    
    enum CryptoAlgorithm {
        case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
        var HMACAlgorithm: CCHmacAlgorithm {
            var result: Int = 0
            switch self {
            case .MD5:      result = kCCHmacAlgMD5
            case .SHA1:     result = kCCHmacAlgSHA1
            case .SHA224:   result = kCCHmacAlgSHA224
            case .SHA256:   result = kCCHmacAlgSHA256
            case .SHA384:   result = kCCHmacAlgSHA384
            case .SHA512:   result = kCCHmacAlgSHA512
            }
            return CCHmacAlgorithm(result)
        }
        var digestLength: Int {
            var result: Int32 = 0
            switch self {
            case .MD5:      result = CC_MD5_DIGEST_LENGTH
            case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
            case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
            case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
            case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
            case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
            }
            return Int(result)
        }
    }
    
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        let digest = stringFromResult(result: result, length: digestLen)
        result.deallocate(capacity: digestLen)
        return digest
    }
    
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash).lowercased()
    }
    
    
    var hexadecimal: Data? {
        var data = Data(capacity: characters.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        guard data.count > 0 else { return nil }
        return data
    }
    
    
    func Convertdecodebase64toDecode() -> String {
        let datan = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return String(data: datan!, encoding: .utf8)!
    }
    
    
    func getPublicKeyRSA() -> SecKey? {
        var publicKey = self
        publicKey = publicKey.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        let pubKeyRSAData = Data(base64Encoded: publicKey, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        let attributesRSA: [String:Any] = [
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecClass as String : kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
            ]
        var error1: Unmanaged<CFError>?
        return SecKeyCreateWithData(pubKeyRSAData! as CFData, attributesRSA as CFDictionary, &error1)
    }
    
    
    func getPublicKeyEC() -> SecKey {
        //var publicKey = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEtjDEWbWZiUmybDiLTI6BcFAq/nxNHEMrDaja8+jTtCVsLPYmeFHkcS8oJvOLiF6EWjiPZQQr4I8ZCevswLCfAw=="
        //self = self.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        var pubKeyECData = Data(base64Encoded: self.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/"))?.bytes
        while pubKeyECData?.count != 32 * 2 + 1 {
            pubKeyECData?.removeFirst()
        }
        let attributesEC: [String:Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrIsPermanent as String: false
        ]
        //[
        //kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
        //kSecClass as String : kSecClassKey,
        //kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom
        //]
        var error1: Unmanaged<CFError>?
        let key = SecKeyCreateWithData(Data.init(bytes: pubKeyECData!) as CFData, attributesEC as CFDictionary, &error1)
        return key!
        //print(deviceInfo.sharedDeviceInfo.getXYfromECPublicKey(pub: key!))
    }
}


extension StringProtocol {
    var hexa2Bytes: [UInt8] {
        let hexa = Array(self)
        return stride(from: 0, to: count, by: 2).compactMap { UInt8(String(hexa[$0...$0.advanced(by: 1)]), radix: 16) }
    }
}






class UtilForEncry {
    
    static let sharedUtil = UtilForEncry()
    
    
    //func stringToBase64(base64Str: String) -> String {
    //var base64 = base64Str
    //.replacingOccurrences(of: "-", with: "+")
    //.replacingOccurrences(of: "_", with: "/")
    //if base64.count % 4 != 0 {
    //base64.append(String(repeating: "=", count: 4 - base64.count % 4))
    //}
    //return base64
    //}
    
    
    func createDigest(input: Data) throws -> [UInt8] {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = CC_SHA256(Array(input), UInt32(input.count), &digest)
        return digest
    }
    
    
    func StringToJSon(GetStr : String) -> NSDictionary {
        var sendarray : NSDictionary = [:]
        let data = GetStr.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String :AnyObject] {
                sendarray = jsonArray as NSDictionary
            } else {
                //print("bad json")
            }
        } catch _ as NSError {
            //print(error)
        }
        return sendarray as NSDictionary
    }
    
    
    func randomData(ofLength length: Int) throws -> Data {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes)
        } else {
            return try! randomData(ofLength:length)
        }
    }
    
    
    func calculate(from input: Data, with key: Data) -> Data {
        var hmacOutData = Data(count: 32)
        hmacOutData.withUnsafeMutableBytes { hmacOutBytes in
            key.withUnsafeBytes { keyBytes in
                input.withUnsafeBytes { inputBytes in
                    CCHmac(CCAlgorithm(kCCHmacAlgSHA256), keyBytes, key.count, inputBytes, input.count, hmacOutBytes)
                }
            }
        }
        return hmacOutData
    }
    
    
    func shawith256(_ string: String) -> String? {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_SHA256(body, CC_LONG(d.count), &digest)
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    
    func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
        }
        return Data(bytes: hash)
    }
    
    
    func sha256(_ string: String) -> [UInt8] {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_SHA256(body, CC_LONG(d.count), &digest)
            }
        }
        return digest
    }
    
    
    func stringToBytesArray(_ string: String) -> [UInt8]? {
        let length = string.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    //func stringToBytesArray(_ string: String) -> [UInt8]? {
    //let length = string.count
    //if length & 1 != 0 {
    //return nil
    //}
    //var bytes = [UInt8]()
    //bytes.reserveCapacity(length/2)
    //var index = string.startIndex
    //for _ in 0..<length/2 {
    //let nextIndex = string.index(index, offsetBy: 2)
    //if let b = UInt8(string[index..<nextIndex], radix: 16) {
    //bytes.append(b)
    //} else {
    //return nil
    //}
    //index = nextIndex
    //}
    //return bytes
    //}
    
    
    func getHeader(pubkey : SecKey?) -> String {
        let dic = deviceInfo.sharedDeviceInfo.getXYfromECPublicKey(pub: pubkey!)
        //let arr =  pubkey.debugDescription.components(separatedBy: ",")
        //let xloc =  arr[6].replacingOccurrences(of: " x: ", with: "")
        //let yloc = arr[5].replacingOccurrences(of: " y: ", with: "")
        //let xval = Data(bytes: xloc.hexaBytes).base64URLEncodedString()
        //xloc.hexa2Bytes.toBase64()?.removePaddingAndWrapping() as! String
        //let yval = Data(bytes: yloc.hexaBytes).base64URLEncodedString()
        //yloc.hexa2Bytes.toBase64()?.removePaddingAndWrapping() as! String
        //xval = "C1PL42i6kmNkM61aupEAgLJ4gF1ZRzcV7lqo1TG0mL4"
        //yval = "cNToWLSdcFQKG--PGVEUQrIHP8w6TcRyj0pyFx4-ZMc"
        //return "{\"alg\":\"dir\",\"kid\":\"UUIDkeyidentifierforDS-EC\",\"epk\":{\"kty\":\"EC\",\"crv\":\"P-256\",\"x\":\"\(xval)\",\"y\":\"\(yval)\"},\"enc\":\"A128GCM\"}"
        return "{\"alg\":\"dir\",\"kid\":\"UUIDkeyidentifierforDS-EC\",\"epk\":{\"kty\":\"EC\",\"crv\":\"P-256\",\"x\":\"\(dic["x"]!)\",\"y\":\"\(dic["y"]!)\"},\"enc\":\"A128GCM\"}"
        //return "{\"alg\":\"dir\",\"kid\":\"UUIDkeyidentifierforDS-EC\",\"epk\":{\"kty\":\"EC\",\"crv\":\"P-256\",\"x\":\"C1PL42i6kmNkM61aupEAgLJ4gF1ZRzcV7lqo1TG0mL4\",\"y\":\"cNToWLSdcFQKG--PGVEUQrIHP8w6TcRyj0pyFx4-ZMc\"},\"enc\":\"A128GCM\"}"
    }
    
    
    
    //func toBase64(dataR : Data) -> String {
    //return dataR.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed).replacingOccurrences(of: "=", with: "")
    //}
    
    
    func sha256(securestr : String) -> String? {
        guard let data = securestr.data(using: String.Encoding.utf8) else {
            return nil
        }
        let hash = data.withUnsafeBytes { (bytes: UnsafePointer<Data>) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            CC_SHA256(bytes, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    
    func stringToBytes(_ string: String) -> [UInt8]? {
        let length = string.characters.count
        if length & 1 != 0 {
            return nil
        }
        var bytes = [UInt8]()
        bytes.reserveCapacity(length/2)
        var index = string.startIndex
        for _ in 0..<length/2 {
            let nextIndex = string.index(index, offsetBy: 2)
            if let b = UInt8(string[index..<nextIndex], radix: 16) {
                bytes.append(b)
            } else {
                return nil
            }
            index = nextIndex
        }
        return bytes
    }
    
    //func toBase64(dataR : Data) -> String {
    //return dataR.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)).replacingOccurrences(of: "=", with: "")
    //}
    //func stringToBytes(_ string: String) -> [UInt8]? {
    //let length = string.characters.count
    //if length & 1 != 0 {
    //return nil
    //}
    //var bytes = [UInt8]()
    //bytes.reserveCapacity(length/2)
    //var index = string.startIndex
    //for _ in 0..<length/2 {
    //let nextIndex = string.index(index, offsetBy: 2)
    //if let b = UInt8(string[index..<nextIndex], radix: 16) {
    //bytes.append(b)
    //} else {
    //return nil
    //}
    //index = nextIndex
    //}
    //return bytes
    //}
    
    
    func hmac256Calculate(from input: Data, with key: Data) -> Data {
        var hmacOutData = Data(count:String.CryptoAlgorithm.SHA256.digestLength)
        //algorithm.outputLength)
        hmacOutData.withUnsafeMutableBytes { hmacOutBytes in
            key.withUnsafeBytes { keyBytes in
                input.withUnsafeBytes { inputBytes in
                    CCHmac(CCAlgorithm(kCCHmacAlgSHA256), keyBytes, key.count, inputBytes, input.count, hmacOutBytes)
                }
            }
        }
        return hmacOutData
    }
    
    
    func sha(_ string: String) -> [UInt8] {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_SHA256(body, CC_LONG(d.count), &digest)
            }
        }
        return digest
        //return (0..<length).reduce("") {
        //$0 + String(format: "%02x", digest[$1])
        //}
    }
    
    
    func testCrypt(data:Data, keyData:Data, ivData:Data, operation:Int) -> Data {
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)
        let keyLength             = size_t(kCCKeySizeAES128)
        let options   = CCOptions(kCCOptionPKCS7Padding)
        //let options1   = CCOptions(ccNoPadding)
        var numBytesEncrypted :size_t = 0
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes, keyLength,
                                ivBytes,
                                dataBytes, data.count,
                                cryptBytes, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
        } else {
            //print("Error: \(cryptStatus)")
        }
        return cryptData;
    }
    
    
    func gcm() {
        //CCCryptorStatus CCCryptorGCM(
        //CCOperation     op, // kCCEncrypt, kCCDecrypt
        //CCAlgorithm     kCCAlgorithmAES,
        //const void      *key,    size_t  keyLength,
        //const void      *iv,     size_t  ivLen,
        //const void      *aData,  size_t  aDataLen, // does not work
        //const void      *dataIn, size_t  dataInLength,
        //void            *dataOut,
        //const void      *tag,    size_t *tagLength);
        //CCCryptorStatus CCCryptorGCM(
        //CCOperation     op,             /* kCCEncrypt, kCCDecrypt */
        //CCAlgorithm     alg,
        //const void      *key,           /* raw key material */
        //size_t          keyLength,
        //const void      *iv,
        //size_t          ivLen,
        //const void      *aData,
        //size_t          aDataLen,
        //const void      *dataIn,
        //size_t          dataInLength,
        //void            *dataOut,
        //const void      *tag,
        //size_t          *tagLength);
    }
    
    
    //func randomData(ofLength length: Int) throws -> Data {
    //var bytes = [UInt8](repeating: 0, count: length)
    //let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
    //if status == errSecSuccess {
    //return Data(bytes: bytes)
    //} else {
    //try! randomData(ofLength: length)
    //}
    //return Data()
    //}
    
    
    
    //func toBase64(dataR : Data) -> String {
    //return dataR.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed).replacingOccurrences(of: "=", with: "")
    //}
}

