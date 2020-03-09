//  AppDelegate.swift
//  Demo2
//  Created by Virendra patil on 06/03/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit
import Asiapay_alipay_sdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,AsiaPayDelegate{
    
    
    func paymentCallBack(paymentResult: [String : Any]) {
        
           print(paymentResult)
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        Asiapay_AliPay_SDK.shared.Pay(pay: PayInfo.init(merchantId: "88145875", currencyCode: .HKD, amount: "0.01", orderRef: "560200353merRef", operatorID: "101", remark: "pay", isUAT: true, paygate: .PAYDOLLAR, secureMethod: .SHA_1))
        
        
        //Asiapay_alipay_sdk.shared.Pay(pay: PayInfo.init(merchantId: "88145875", currencyCode: .HKD, amount: "0.01", orderRef: "560200353merRef", operterId: "101", remark: "pay", isUAT: true, paygate: .PAYDOLLAR, secureMethod: .SHA_1) )

        //Asiapay_alipay_sdk.shared.Pay(pay: PayInfo)
        //Asiapay_alipay_sdk.shared.isUAT = true
        //let pay = PayInfo.init(merchantId:"88145875", currencyCode: .HKD, amount: "0.01", orderRef: "560200353merRef", operterId: "101", remark: "", isUAT: true, paygate: .PAYDOLLAR, secureMethod: .SHA_1)
        //(merchantId: "88145875", currCode: "344", amount: "0.01", orderRef: "560200353merRef", lang: "E", payType: "N", pMethod: "ALIPAYHKAPP", opertaorId: "101", remark: "")
        
//        Asiapay_alipay_sdk.shared.isUAT = true
//        Asiapay_alipay_sdk.shared.Pay(merchantId: "88145875", currCode: "344", amount: "0.01", orderRef: "560200353merRef", lang: "E", payType: "N", pMethod: "ALIPAYHKAPP", opertaorId: "101", remark: "test")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

