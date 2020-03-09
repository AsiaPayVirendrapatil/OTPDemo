//
//  OtpView.swift
//  Mobilewallet
//  Created by Virendra patil on 19/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class OtpView: UIViewController {

    @IBOutlet weak var otpstackview: PinView!
    @IBOutlet weak var walletpin: PinView!
    @IBOutlet weak var reenterwalletpin: PinView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sendbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.addUIViewborder(color: .lightGray, cornerradius: 10, borderwidth: 2)
        sendbtn.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 2)
        
        setUIbutton(stack: otpstackview)
        setUIbutton(stack: walletpin)
        setUIbutton(stack: reenterwalletpin)
    }

   public func setUIbutton(stack :PinView){
        
        var config:PinConfig!     = PinConfig()
        config.otpLength          = .four
        config.dotColor           = .black
        config.lineColor          = #colorLiteral(red: 0.8265652657, green: 0.8502194881, blue: 0.9000532627, alpha: 1)
        config.spacing            = 20
        config.isSecureTextEntry  = false
        config.showPlaceHolder    = true
        
        stack.config = config
        stack.setUpView()
        stack.textFields[0].becomeFirstResponder()
    }
    
    @IBAction func sendotpbtnClick(_ sender: Any) {
        
        var otpCode:String = ""
        do {
            otpCode = try self.otpstackview.getOTP()
        } catch OTPError.inCompleteOTPEntry {
            print("Incomplete OTP Entry error")
        } catch let error {
            print(error.localizedDescription)
        }
        print(otpCode)
        
        var otpCode1:String = ""
        do {
            otpCode1 = try self.walletpin.getOTP()
        } catch OTPError.inCompleteOTPEntry {
            print("Incomplete OTP Entry error")
        } catch let error {
            print(error.localizedDescription)
        }
        print(otpCode1)
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showLoggedInUserScreens()

    }
}
