//
//  DeviceInfo.swift
//  interfaceFor3DS
//
//  Created by Vaibhav on 06/12/18.
//  Copyright © 2018 Vaibhav. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation
import AdSupport




class deviceInfo : NSObject, CLLocationManagerDelegate {
    static let sharedDeviceInfo = deviceInfo()
    let platform = UIDevice.current.systemName as String
    let deviceModel = UIDevice.current.model as String
    let deviceModelName = UIDevice.current.modelName as String
    let osName = UIDevice.current.systemName as String
    let osVersion = UIDevice.current.systemVersion as String
    let deviceName = UIDevice.current.localizedModel as String
    let locale = NSLocale.current.languageCode! + "-" + NSLocale.current.regionCode!
    let timeZone = NSTimeZone.local.identifier
    lazy var advertisingID = ""
    lazy var screenResolution = ""
    lazy var deviceUserInterfaceIdiom = ""
    lazy var deviceOrientation = ""
    lazy var deviceUUID = ""
    //var ipAddress : String = "132.0.345.0"
    var long = ""
    var lat = ""
    var locationManager : CLLocationManager!
    //var seenError : Bool = false
    //var locationFixAchieved : Bool = false
    var locationStatus = ""
    var sdkTransactionID :String = ""
    var dh :Data?
    var uuidForDS : String = ""
    var sdkEphemeralPublicKeySec, sdkEphemeralPrivateKeySec: SecKey?
    var sdkEphemeralPublicXNY : [String:String]?
    var sdkappId : String = ""
    
    //    let sdkprivetetx = "yuyNtAQ8QyVzHKqX6JJL_GG0z7BjdyYDvwQJI6dMKcY"
    //    let sdkprivetety = "5mJgnvZ-in0r9uoqYeTYSjicTKBq8xcrh5GcCcX-DzE"
    //    let sdkprivetetd = "c8rYOg8QYk8N2VhVDFSFfrzbvJEbqvZM8gF9NX9b-ro"
    
    
    func generateSDKEphemeral() {
        sdkTransactionID = UUID().uuidString.lowercased() //"fd38a34f-5ec1-455e-8026-34582c326f05"
        sdkappId = "99e65b97-fcfd-4012-a87c-db3411fb7d9d"
        //UUID().uuidString.lowercased()
        uuidForDS = UUID().uuidString.lowercased()
        //"f1a05bbf-38a6-49c7-a807-5f9c70a6a862"
        
        let keyattribute = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String : 256
            ] as CFDictionary
        SecKeyGeneratePair(keyattribute, &sdkEphemeralPublicKeySec, &sdkEphemeralPrivateKeySec)
        //let arr =  sdkEphemeralPublicKeySec.debugDescription.components(separatedBy: ",")
        //let xloc = arr[6].replacingOccurrences(of: " x: ", with: "")
        //let yloc = arr[5].replacingOccurrences(of: " y: ", with: "")
        sdkEphemeralPublicXNY = self.getXYfromECPublicKey(pub: sdkEphemeralPublicKeySec!)
        //let xval = dic["x"]
        //let yval = dic["y"]
        //sdkEphemeralPublicKey = ECPublicKey(crv: ECCurveType.P256, x: xval , y: yval)
        
        //        sdkEphemeralPrivateKeySec = getSecKeyfromValuespriv(x:  sdkprivetetx, y: sdkprivetety, d: sdkprivetetd)
        //
        //        sdkEphemeralPublicKeySec = getSecKeyfromValues(x: sdkprivetetx, y: sdkprivetety)
        //
        //        sdkEphemeralPublicXNY = self.getXYfromECPublicKey(pub: sdkEphemeralPublicKeySec!)
    }
    
    
    
    //    func getSecKeyfromValuespriv(x: String , y: String , d : String) -> SecKey {
    //        let xBytes = Data(base64URLEncoded: x)!
    //        let yBytes = Data(base64URLEncoded: y)!
    //        let dBytes = Data(base64URLEncoded: d)!
    //        let keyData = NSMutableData.init(bytes: [0x04], length: [0x04].count)
    //        keyData.append(xBytes)
    //        keyData.append(yBytes)
    //        keyData.append(dBytes)
    //        let attributes: [String: Any] = [
    //            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
    //            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
    //            kSecAttrKeySizeInBits as String: 256,
    //            kSecAttrIsPermanent as String: false
    //        ]
    //        var error: Unmanaged<CFError>?
    //        let keyReference = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error)!
    //        return keyReference
    //    }
    
    func getSecKeyfromValues(x: String , y: String) -> SecKey {
        let xBytes = Data(base64URLEncoded: x)!
        let yBytes = Data(base64URLEncoded: y)!
        let keyData = NSMutableData.init(bytes: [0x04], length: [0x04].count)
        keyData.append(xBytes)
        keyData.append(yBytes)
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrIsPermanent as String: false
        ]
        var error: Unmanaged<CFError>?
        let keyReference = SecKeyCreateWithData(keyData as CFData, attributes as CFDictionary, &error)!
        return keyReference
    }
    
    
    func getXYfromECPublicKey(pub: SecKey) -> [String : String] {
        var error: Unmanaged<CFError>?
        guard let keyData = SecKeyCopyExternalRepresentation(pub, &error) else {
            return [:]
        }
        let data = keyData as Data
        var publicKeyBytes = [UInt8](data)
        publicKeyBytes.removeFirst()
        let pointSize = publicKeyBytes.count / 2
        let xBytes = publicKeyBytes[0..<pointSize]
        let yBytes = publicKeyBytes[pointSize..<pointSize*2]
        //let xData = Data(bytes: xBytes)
        //let yData = Data(bytes: yBytes)
        return ["x":Data(bytes: xBytes).base64URLEncodedString() , "y": Data(bytes: yBytes).base64URLEncodedString()]
    }
    
    
    override init() {
        super.init()
        getLocation()
        advertisingID = getdeviceIDFA()
        screenResolution = getScreenResolution()
        deviceUserInterfaceIdiom = getUserInterfaceIdiom()
        deviceOrientation = getDeviceOrientation()
        deviceUUID = (UIDevice.current.identifierForVendor?.uuidString.replacingOccurrences(of: "-", with: ""))!
        //getFontNamesForFamilyName()
    }
    
    
    func getFontNamesForFamilyName() -> [Any] {
        var familyArray1 = Array<Any>()
        UIFont.familyNames.forEach({
            familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            if fontNames.count == 0 {
                familyArray1.append(familyName)
            } else {
                familyArray1.append([familyName,fontNames])
            }
        })
        return familyArray1
    }
    
    
    func getdeviceIDFA() -> String {
        // Check if Advertising Tracking is Enabled
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            // Set the IDFA
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString.replacingOccurrences(of: "-", with: "")
        } else {
            return ""
        }
    }
    
    
    func getScreenResolution() -> String {
        var screenWidth: CGFloat {
            if UIDevice.current.orientation == UIDeviceOrientation.portrait {
                return UIScreen.main.bounds.size.width
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
        var screenHeight: CGFloat {
            if UIDevice.current.orientation == UIDeviceOrientation.portrait{
                return UIScreen.main.bounds.size.height
            } else {
                return UIScreen.main.bounds.size.width
            }
        }
        return "\(screenWidth.description) x \(screenHeight.description)"
    }
    
    
    func getDeviceOrientation() -> String {
        if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
            return "LandscapeLeft"
        } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
            return "LandscapeRight"
        } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            return "Portrait"
        } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
            return "PortraitUpsideDown"
        } else if UIDevice.current.orientation == UIDeviceOrientation.faceDown {
            return "FaceDown"
        } else if UIDevice.current.orientation == UIDeviceOrientation.faceUp {
            return "FaceUp"
        } else if UIDevice.current.orientation == UIDeviceOrientation.unknown {
            return "Unknown"
        } else {
            return "No"
        }
    }
    
    
    func getUserInterfaceIdiom() -> String {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return "iPad Style UI"
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            return "iPhone Style UI"
        } else if UIDevice.current.userInterfaceIdiom == .carPlay {
            return "Car Play Style UI"
        } else if UIDevice.current.userInterfaceIdiom == .tv {
            return "TV Style UI"
        } else if UIDevice.current.userInterfaceIdiom == .unspecified {
            return "Unspecified UI"
        }
        return ""
    }
    
    
    func getLocation() {
        self.locationManager =  CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            long = String(format:"%f", self.locationManager.location?.coordinate.longitude ?? "0")
            lat = String(format:"%f",self.locationManager.location?.coordinate.latitude ?? "0")
        } else {
            locationStatus = "disable"
        }
        //self.runName()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        if let location = locations.first {
            //print(location.coordinate)
            long = String(location.coordinate.longitude)
            lat = String(location.coordinate.latitude)
        }
    }
    
    
    func isDeviceJailbroken() -> Bool {
        #if arch(i386) || arch(x86_64)
        return false
        #else
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt")) ||
            fileManager.fileExists(atPath: "/private/var/lib/apt/") ||
            fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") {
            return true
        } else {
            return false
        }
        #endif
    }
    
    
    func getIFAddresses() -> [String] {
        var addresses = [String]()
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {
            return []
        }
        guard let firstAddr = ifaddr else {
            return []
        }
        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        addresses.append(address)
                    }
                }
            }
        }
        freeifaddrs(ifaddr)
        return addresses
    }
    
    
    func getDeviceData() -> String {
        var dd : [String : Any] = [
            "C001":platform,
            "C002":deviceModel,
            "C003":osName,
            "C004":osVersion,
            "C005":locale,
            "C006":timeZone,
            "C007":advertisingID,
            "C008":screenResolution,
            "C009":deviceName,
            "I001":deviceUUID,
            "I002":getUserInterfaceIdiom(),
            "I003":UIFont.familyNames,
            "I004":getFontNamesForFamilyName(),
            "I005":UIFont.systemFont(ofSize: 17.0).familyName,
            "I006":String(format:"%f",UIFont.labelFontSize),
            "I007":String(format:"%f",UIFont.buttonFontSize),
            "I008":String(format:"%f",UIFont.smallSystemFontSize),
            "I009":String(format:"%f",UIFont.systemFontSize),
            "I010": Locale.current.identifier,
            //NSLocale.system.identifier,
            "I011":NSLocale.availableLocaleIdentifiers,
            "I012":NSLocale.preferredLanguages,
            "I013":NSTimeZone.default.identifier]
        //DPNA
        var dpnaDic = [String : Any]()
        let ip = getIFAddresses()
        if ip.count == 0 {
            dpnaDic["C010"] = "RE01"
        } else {
            dd["C010"] = ip[0]
        }
        var mainDic = ["DV":"1.1",
                       "DD":dd
            ] as [String : Any]
        if CLLocationManager.locationServicesEnabled() {
            if Float(lat) == 0.0 && Float(long) == 0.0 {
                dpnaDic["C011"] = "RE03"
                dpnaDic["C012"] = "RE03"
            } else {
                dd["C011"] = lat
                dd["C012"] = long
            }
        } else {
            dpnaDic["C011"] = "RE03"
            dpnaDic["C012"] = "RE03"
        }
        var swDic = [String]()
        if isDeviceJailbroken() {
            swDic.append("SW01")
        }
        if isDebugged().amIBeingDebugged() {
            swDic.append("SW03")
        }
        #if (arch(i386) || arch(x86_64)) // return warning here
        swDic.append("SW02")
        #endif
        mainDic["DPNA"] = dpnaDic
        mainDic["SW"] = swDic
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: mainDic, options: JSONSerialization.WritingOptions.sortedKeys)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
            return jsonString!
        } catch {
            //print(error.localizedDescription)
        }
        //print(mainDic)
        return ""
    }
}


//Extension to get the device model name
extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "iPod1,1"    : return "iPod1"
        case "iPod2,1"    : return "iPod2"
        case "iPod3,1"    : return "iPod3"
        case "iPod4,1"    : return "iPod4"
        case "iPhone10,1" : return "iPhone8"
        case "iPhone10,2" : return "iPhone8plus"
        case "iPhone10,3" : return "iPhoneX"
        case "iPhone10,6" : return "iPhoneX"
        case "iPhone11,2" : return "iPhoneXS"
        case "iPhone11,4" : return "iPhoneXSmax"
        case "iPhone11,6" : return "iPhoneXSmax"
        case "iPhone11,8" : return "iPhoneXR"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        case "unrecognized"        :                    return "?unrecognized?"
        default:                                        return identifier
        }
    }
    
}

