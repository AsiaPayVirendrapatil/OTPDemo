//
//  MainNavigationController.swift
//  emvco3ds-ios-app
//
//  Created by Kinaan, William on 17/08/2017.
//  Copyright © 2017 Kinaan, William. All rights reserved.
//

import UIKit
//import emvco3ds_protocols_ios

class MainNavigationController: UINavigationController , UINavigationControllerDelegate, UIWebViewDelegate {
    
    @objc static var screenshotMessage : ScreenshotMessage?
    static var order : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbarHidden(false, animated: true)
        self.delegate = self
    }
    
    @objc static func shouldHandleChallengeData(topViewController: NSObject?) {
        if (topViewController != nil) {
            TestCaseRunner.instance.shouldHandleChallengeData(topViewController: topViewController as! UIViewController)
        }
    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        MainNavigationController.shouldHandleChallengeData(topViewController: UIApplication.topViewController())
    }
}



