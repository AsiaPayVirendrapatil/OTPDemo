//  RegisterView.swift
//  Mobilewallet
//  Created by Virendra patil on 20/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit

class RegisterView: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var regiaterview: UIView!
    @IBOutlet weak var firstnametextfield: UITextField!
    @IBOutlet weak var lastnametextfield: UITextField!
    @IBOutlet weak var emailidtextfiled: UITextField!
    @IBOutlet weak var mobilenumbertextfiled: UITextField!
    @IBOutlet weak var sendotpbtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        regiaterview.addUIViewborder(color: .lightGray, cornerradius: 10, borderwidth: 2)
        firstnametextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
        lastnametextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
        emailidtextfiled.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
        mobilenumbertextfiled.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
        sendotpbtn.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 2)
        
    }

    @IBAction func sendotpclick(_ sender: Any) {
        
        if !isEmail_ID_Valid(testStr: emailidtextfiled.text!) {
            print("Please enter valid Email!!!")
        }
        let registerView = self.storyboard?.instantiateViewController(withIdentifier: "OtpView") as! OtpView
        self.navigationController?.pushViewController(registerView, animated: true)
    }
    
    @IBAction func loginbtnClick(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

    // MARK:- ----------> Textfield Delegates <----------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField.tag == 1 {
            let newLength = text.count + string.count - range.length
            return newLength <= 20
        } else if textField.tag == 2 {
            let newLength = text.count + string.count - range.length
            return newLength <= 20
        } else if textField.tag == 3 {
            let newLength = text.count + string.count - range.length
            return newLength <= 30
        } else if textField.tag == 4 {
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
        else {

            let newLength = text.count + string.count - range.length
            return newLength <= 12
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func isEmail_ID_Valid(testStr : String) -> Bool {
        
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
        /*
         //----------> Call Method like this <----------
         var isCheckNet = ModelClass.isEmail_ID_Valid()
         
         */
    }

    
}
