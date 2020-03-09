//  LoginView.swift
//  Mobilewallet
//  Created by Virendra patil on 19/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit

class LoginView: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var loginview: UIView!
    @IBOutlet weak var walletopinview: PinView!
    @IBOutlet weak var mobilenumbertext: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    
    var activityindicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginview.addUIViewborder(color: .lightGray, cornerradius: 10, borderwidth: 2)
        loginbtn.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 2)
        mobilenumbertext.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
        mobilenumbertext.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)

        self.title = "LoginView"
        var config:PinConfig!     = PinConfig()
        config.otpLength          = .four
        config.dotColor           = .black
        config.lineColor          = #colorLiteral(red: 0.9442684054, green: 0.5026286244, blue: 0.0006228119018, alpha: 1)
        config.spacing            = 20
        config.isSecureTextEntry  = false
        config.showPlaceHolder    = true

        walletopinview.config = config
        walletopinview.setUpView()
        walletopinview.textFields[0].becomeFirstResponder()
    }
    
    @IBAction func RegisterbtnClick(_ sender: Any) {
        
        let registerView = self.storyboard?.instantiateViewController(withIdentifier: "RegisterView") as! RegisterView
        self.navigationController?.pushViewController(registerView, animated: true)
    }

    @IBAction func LoginbtnClick(_ sender: Any) {
        
        //self.customActivityIndicatory(self.view)
        //modelclass().customActivityIndicatory(self.view, startAnimate: true)

        var otpCode:String = ""
        do {
            otpCode = try self.walletopinview.getOTP()
        } catch OTPError.inCompleteOTPEntry {
            print("Incomplete OTP Entry error")
            self.showAlertView(message: "Please Enter the OTP")

        } catch let error {
            print(error.localizedDescription)
        }
        print(otpCode)
        if otpCode != "" {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showLoggedInUserScreens()
        }
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }

        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        textField.text = cardNumberWithoutSpaces
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        return digitsOnlyString
    }
    
    // MARK:- ----------> Textfield Delegates <----------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField.tag == 1 {
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
        else  {
            
            let newLength = text.count + string.count - range.length
            return newLength <= 12
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    // MARK:- Show AlertView
    func showAlertView(message : String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
