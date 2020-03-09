//  PaymentView.swift
//  Created by Virendra patil on 26/03/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit
import Alamofire
import NVActivityIndicatorView

@objc public protocol GenericChallengeProtocol {
    func clickVerifyButton()
    func getChallengeType() -> String
    func clickCancelButton()
    func setChallengeProtocol(challegeprotocol: SDKChallengeProtocol)
    func expandTextsBeforeScreenshot()
    func selectWhitelistChecked(checked: Bool)
    
 }

@objc public protocol TextChallengeProtocol : GenericChallengeProtocol {
    func typeTextChallengeValue(_ value: String)
}

//public
 class PaymentView: UIViewController,UITextFieldDelegate,TextChallengeProtocol {
    
    var sdkChallengeProtocol : SDKChallengeProtocol?
    var checkval = 0
    
    func selectWhitelistChecked(checked: Bool) {
         print(checked)
    }
    
    func typeTextChallengeValue(_ value: String) {
       Enter_code_textfield.text = value
    }

    func clickVerifyButton() {
        Submit_btnClick(UIButton.init())
    }
    
    func getChallengeType() -> String {
        return (setCRes?.acsUiType)!
    }

    func clickCancelButton() {
         Cancelbtn()
    }
    
    func setChallengeProtocol(challegeprotocol : SDKChallengeProtocol) {
        sdkChallengeProtocol = challegeprotocol
        
    }
 
    func handleChallenge(){
        sdkChallengeProtocol?.handleChallenge()
    }

    @IBOutlet weak var paymentstackview: UIStackView!
    var transation : Transaction? = nil
    var challengeParameters : ults_ChallengeParameters?
    var challengeStatusReceiver : ults_ChallengeStatusReceiver?
    var acsURL  : String = ""
    @IBOutlet weak var challeninfoheader: UILabel!
    @IBOutlet weak var your_bank_image: UIImageView!
    @IBOutlet weak var card_network_image: UIImageView!
    @IBOutlet weak var challengeinfo_text: UILabel!
    @IBOutlet weak var Enter_code_textfield: UITextField!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var resendcode_btn: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var challegindicatorimgview: UIImageView!
    @IBOutlet weak var cardnetwork_image: UIImageView!
    @IBOutlet weak var yourbank_image: UIImageView!
    @IBOutlet weak var expand1btn: UIButton!
    @IBOutlet weak var expand2btn: UIButton!
    @IBOutlet weak var expandtwolbl: UILabel!
    @IBOutlet weak var expandfirstlbl: UILabel!
    var setCRes : CresData? = nil
    var counter = ""
    @IBOutlet weak var enter_code_text: UILabel!

    let loview = LoadingView()
    
    func expandTextsBeforeScreenshot() {
        expand1btnclick(UIButton.init())
        expand2btnclick(UIButton.init())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard (setCRes?.acsCounterAtoS) != nil else {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver!.runtimeError(e)
            return
        }
        submitbtn.layer.cornerRadius = 6
        resendcode_btn.layer.cornerRadius = 6
        Enter_code_textfield.layer.cornerRadius = 6
        if setCRes?.resendInformationLabel != nil {
            resendcode_btn.isHidden = false
        } else {
            resendcode_btn.isHidden = true
        }
        let frameBundle = Bundle(for: PaymentView.self)
        challegindicatorimgview.image = UIImage(named: "Icon_warningindicator", in: frameBundle, compatibleWith: nil)
        
        if setCRes?.challengeInfoTextIndicator != nil {
            if setCRes?.challengeInfoTextIndicator == "Y" {

            } else {
                challegindicatorimgview.removeFromSuperview()
            }
        } else {
            challegindicatorimgview.removeFromSuperview()
        }
        challeninfoheader.text = setCRes?.challengeInfoHeader
        challengeinfo_text.text = setCRes!.challengeInfoText
        enter_code_text.text = setCRes?.challengeInfoLabel
        resendcode_btn.setTitle(setCRes?.resendInformationLabel, for: .normal)
        submitbtn.setTitle(setCRes?.submitAuthenticationLabel, for: .normal)
        
        if setCRes?.whyInfoLabel != nil {
            expand1btn.setTitle((setCRes?.whyInfoLabel as Any as! String), for: .normal)
        }
        if setCRes?.whyInfoLabel != nil {
            expand2btn.setTitle((setCRes?.expandInfoLabel as Any as! String), for: .normal)
        }
        
        if setCRes?.whyInfoText != nil {
            expandfirstlbl.text = (setCRes?.whyInfoText as Any as! String)
        }else{
            paymentstackview.isHidden = true
        }
        if setCRes?.expandInfoText != nil {
            expandtwolbl.text = (setCRes?.expandInfoText as Any as! String)
        }else {
              paymentstackview.isHidden = true
        }

        self.title = "SECURE CHECKOUT"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let rightcancelbtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancelbtn))
        self.navigationItem.rightBarButtonItem  = rightcancelbtn
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
        Enter_code_textfield.resignFirstResponder()
        let headerTapped = UITapGestureRecognizer (target: self, action:#selector(self.dismissKeyboard(_:)))
        view .addGestureRecognizer(headerTapped)
        Enter_code_textfield.returnKeyType = .default
        guard ((setCRes?.acsCounterAtoS) != "" ) else {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver!.runtimeError(e)
            return
        }
        counter = "\(Int((setCRes?.acsCounterAtoS)!)! + 1)"
        while counter.count != 3 {
            counter = "0" + counter
        }
        
        if setCRes!.psImage != nil {
            let remoteImageURL = URL(string: (self.setCRes?.psImage.extraHigh)!)!
            Alamofire.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    // Show the downloaded image:
                    if let data = response.data {
                        self.card_network_image.image = UIImage(data: data)
                        self.card_network_image.contentMode = .scaleAspectFit
                        self.checkval = self.checkval + 1
                        self.loadingimage()
                    }
                }
            }
        }
        
        if setCRes!.issuerImage != nil {
            let imageUL = URL(string: (self.setCRes?.issuerImage.extraHigh)!)!
            Alamofire.request(imageUL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    // Show the downloaded image:
                    if let data = response.data {
                        self.your_bank_image.image = UIImage(data: data)
                        self.your_bank_image.contentMode = .scaleAspectFit
                        self.checkval = self.checkval + 1
                        self.loadingimage()
                    }
                }
            }
        }

    }
    
    func loadingimage() {
        if checkval == 2 {
            sdkChallengeProtocol?.handleChallenge()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Enter_code_textfield.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func expand1btnclick(_ sender: Any) {
        if setCRes?.whyInfoText != nil {
            expandfirstlbl.text = (setCRes?.whyInfoText as Any as! String)
        }
    }
    
    @IBAction func expand2btnclick(_ sender: Any) {
        if setCRes?.expandInfoText != nil {
            expandtwolbl.text = (setCRes?.expandInfoText as Any as! String)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return true;
        }
        return false
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            Enter_code_textfield.resignFirstResponder()
        }
        return true
    }
    
    
    @IBAction func resend_btnClick(_ sender: Any) {
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "Y")
        let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
        self.transation!.progressHud?.show()
        APICall.shared.post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
    }
    
    
    @objc func Cancelbtn() {
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "01", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
        let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
        self.transation!.progressHud?.show()
        APICall.shared.post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Submit_btnClick(_ sender: Any) {
       
            loview.startLoad()
            guard (setCRes?.threeDSServerTransID) != nil else {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver!.runtimeError(e)
            return
        }
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: Enter_code_textfield.text!, challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
        let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
        APICall.shared.post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)

    }
}
