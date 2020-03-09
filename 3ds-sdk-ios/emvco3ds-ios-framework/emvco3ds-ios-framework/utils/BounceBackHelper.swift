//
//  BounceBackHelper.swift
//  emvco3ds-ios-framework
//
//  Created by Van Drongelen, Mike on 25/02/2019.
//  Copyright © 2019 UL. All rights reserved.
//

import UIKit

public class BounceBackHelper: NSObject {

    @objc let BOUNCE_BACK_APP_SCHEME = "com.ul-ts.emvco3ds-bounceback-ios-app://"
    
    @objc public func initBounceBack(){
        let url = URL(string: BOUNCE_BACK_APP_SCHEME)
        
        if (UIApplication.shared.canOpenURL(url!)){
            print ("launch bounce back app")
            UIApplication.shared.open(url!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
        else{
            print ("no bounce back app found.")
            preconditionFailure("bounce back app is not installed")
        }
    }
}


    


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
