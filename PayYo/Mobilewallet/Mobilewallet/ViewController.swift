//
//  ViewController.swift
//  Mobilewallet
//
//  Created by Virendra patil on 19/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var successlable: UILabel!
    @IBOutlet weak var faceimg: UIImageView!
    let context = LAContext()
    var strAlertMessage = String()
    var error: NSError?

    override func viewDidLoad() {
        super.viewDidLoad()
    
  
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                switch context.biometryType {
                case .faceID:
                    self.strAlertMessage = "Set your face to authenticate"
                    self.faceimg.image = UIImage(named: "face")
                    break
                case .touchID:
                    self.strAlertMessage = "Set your finger to authenticate"
                    self.faceimg.image = UIImage(named: "touch")
                    break
                case .none:
                    print("none")
                    //description = "none"
                    break
                }
            }else {

                // Device cannot use biometric authentication
                if let err = error {
                    let strMessage = self.errorMessage(errorCode: err._code)
                    self.notifyUser("Error",
                                    err: strMessage)
                }
            }
        }else{
            if let err = error {
                let strMessage = self.errorMessage(errorCode: err._code)
                self.notifyUser("Error",
                                err: strMessage)
            }
        }
        
        // Device can use biometric authentication
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: self.strAlertMessage,
                reply: { [unowned self] (success, error) -> Void in
                    DispatchQueue.main.async {
                        if( success ) {
                            //Fingerprint recognized
                            self.goToNextVC()
                            
                        } else {
                            //If not recognized then
                            if let error = error {
                                let strMessage = self.errorMessage(errorCode: error._code)
                                self.notifyUser("Error",
                                                err: strMessage)
                            }
                        }
                    }
            })
        }
        // let loginview = self.storyboard?.instantiateViewController(withIdentifier: "LoginView") as! LoginView
        // self.navigationController?.pushViewController(loginview, animated: true)
    }

    func goToNextVC(){
        
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.ShowLogOutScreen()
   //let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
   //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:-
    // MARK: Get error message
    func errorMessage(errorCode:Int) -> String{
        
        var strMessage = ""
        
        switch errorCode {
        case LAError.authenticationFailed.rawValue:
            strMessage = "Authentication Failed"
            
        case LAError.userCancel.rawValue:
            strMessage = "User Cancel"
            
        case LAError.userFallback.rawValue:
            strMessage = "User Fallback"
            
        case LAError.systemCancel.rawValue:
            strMessage = "System Cancel"
            
        case LAError.passcodeNotSet.rawValue:
            strMessage = "Passcode Not Set"
        case LAError.biometryNotAvailable.rawValue:
            strMessage = "TouchI DNot Available"
            
        case LAError.biometryNotEnrolled.rawValue:
            strMessage = "TouchID Not Enrolled"
            
        case LAError.biometryLockout.rawValue:
            strMessage = "TouchID Lockout"
            
        case LAError.appCancel.rawValue:
            strMessage = "App Cancel"
            
        case LAError.invalidContext.rawValue:
            strMessage = "Invalid Context"
            
        default:
            strMessage = "Some error found"
            
        }
        
        return strMessage
        
    }
    
    // MARK:-
    // MARK: Present Alert
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
                                      message: err,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true,
                     completion: nil)
    }
    
    @IBAction func LoginbtnClick(_ sender: Any) {
          //self.goToNextVC()
    }
}

