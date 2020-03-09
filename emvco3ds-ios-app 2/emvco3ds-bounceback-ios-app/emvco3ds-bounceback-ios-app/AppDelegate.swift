//
//  AppDelegate.swift
//  emvco3ds-bounceback-ios-app
//
//  Copyright © 2019 ul. All rights reserved.

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    let BOUNCE_BACK_AFTER_SEC = 5.0
    let REF_APP_SCHEME = "com.ul-ts.emvco3ds-ios-app://"
    var window: UIWindow?
    var application: UIApplication? = nil
    
    func terminate(){
        exit(0)
    }

    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.application = application
        waitAndBounceBack()
        */return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        waitAndBounceBack()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func waitAndBounceBack(){
        print("Wait and bounce back")
        Timer.scheduledTimer(withTimeInterval: self.BOUNCE_BACK_AFTER_SEC, repeats: false) { (t) in
            print("time")            
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: (self.REF_APP_SCHEME))!, options: [:], completionHandler: nil)
            }
        }
    }
}
