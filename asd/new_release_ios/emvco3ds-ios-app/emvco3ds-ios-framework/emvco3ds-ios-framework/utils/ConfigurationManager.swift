//  ConfigurationManager.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.


import UIKit

public class ConfigurationManager: NSObject {
    private static let typeOfConfiguration : String = Bundle.main.object(forInfoDictionaryKey: "Config")! as! String
    private static let path: String = Bundle.main.path(forResource: "configuration-\(typeOfConfiguration)", ofType: "plist")!
    private static let sampleConf: NSDictionary = NSDictionary(contentsOfFile: path)!
   
    public static let REFERENCE_APP_SERVER_IP = load(key: "rac_ip")
    public static let REFERENCE_APP_SERVER_PORT = load(key: "rac_port")
    public static let PROTOCOL = load(key: "protocol")
    public static let SDK_VENDOR_HEADER_KEY = load(key: "sdk_vendor_header_key")
    public static let SDK_VENDOR_KEY_VALUE = load(key: "sdk_vendor_key_value")
    public static let THREE_DS_SERVER_ENDPOINT = load(key: "three_ds_server_endpoint")
    public static let RAS_FETCH_TC_MESSAGE_ENDPOINT = load(key: "ras_fetch_tc_message_endpoint")
    public static let RAS_DELETE_ALL_TC_MESSAGES_ENDPOINT = load(key : "ras_delete_all_tc_messages_endpoint")
    public static let DEVICE_INFO = load(key: "device_info")
    public static let RAS_NOTIFY_TEST_MANAEGMENT_ENDPOINT = load(key: "ras_notify_test_management_endpoint")
    public static let REFERENCE_APP_SERVER_SCREENSHOT_ENDPOINT = load(key: "ras_screenshot_endpoint")
    public static let API_KEY = load(key: "api_key")
    public static let CARDHOLDER_ENDPOINT = load(key: "cardholder_endpoint")
    public static let ENVIRONMENT_NAME = load(key: "environmentName")
    
    private static func load(key : String) -> String {
        return sampleConf.object(forKey: key) as! String
    }
    
    
    public static let challengeUrl : String = Bundle.main.object(forInfoDictionaryKey: "challengeUrl")! as! String
}
