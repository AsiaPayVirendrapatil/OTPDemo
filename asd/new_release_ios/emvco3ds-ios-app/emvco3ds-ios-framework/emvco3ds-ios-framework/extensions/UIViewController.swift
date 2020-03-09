//  UIViewController.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import MaterialComponents.MaterialSnackbar

extension UIViewController {

    func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        return spinnerView
    }
    
    func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    func bg(_ block: @escaping ()->Void) {
        DispatchQueue.global(qos: .default).async(execute: block)
    }
    
    func ui(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    
    func displayMessage(textMessage: String) {
        DispatchQueue.main.async() {
            let message = MDCSnackbarMessage()
            message.text = textMessage
            MDCSnackbarManager.show(message)
        }
        Log.i(object: self, message: "Displaying toast to user: \(textMessage)")
    }
}
