//
//  AppDelegate.swift
//  emvco3ds-ios-app

import UIKit
import emvco3ds_ios_framework

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // TODO: Here you setup the framework for the Ref App and refer to the ults_Factory implementation in your SDK.
        // For details see 'SampleSDK.swift' in the 'Samples' folder and the 'iOS 3DS Reference App Developers Guide'
        // For a quick setup of the Reference App: Add or refer to your SDK and include the lines shown below (Currently commented out).
        
        //Emvco3dsFramework.setup(appName: application.appName, factory: Factory())
        
        // TODO: Check the configurations in the 'configurations' folder and modify the configuration for the target
        // you would like to use and update the value for 'api_key'
        
        /* let navigationController = Emvco3dsFramework.navigationController
    
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        */return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
