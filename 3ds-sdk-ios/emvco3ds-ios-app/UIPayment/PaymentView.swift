//  PaymentView.swift
//  Created by Virendra patil on 26/03/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit
import emvco3ds_ios_framework



class PaymentView: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
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
    @IBOutlet weak var tableviewheightconstant: NSLayoutConstraint!
    @IBOutlet weak var challegindicatorimgview: UIImageView!
    @IBOutlet weak var cardnetwork_image: UIImageView!
    @IBOutlet weak var yourbank_image: UIImageView!
    @IBOutlet weak var info_texteditor: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var arrayForBool             : NSMutableArray = []
    var sectionArray             : NSMutableArray = []
    var sectionContentDict       : NSMutableArray = []
    var setCRes : CresData? = nil
    var counter = ""
    @IBOutlet weak var enter_code_text: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard (setCRes?.acsCounterAtoS) != nil else {
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver!.runtimeError(e)
            //challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "203", "T##errorDescription: String##String", "T##errorDetail: String##String")))
            return
        }
        submitbtn.layer.cornerRadius = 4
        resendcode_btn.layer.cornerRadius = 4
        if setCRes?.resendInformationLabel != nil {
            resendcode_btn.isHidden = false
        } else {
            resendcode_btn.isHidden = true
        }
        if setCRes?.challengeInfoTextIndicator != nil {
            if setCRes?.challengeInfoTextIndicator == "Y" {
                challegindicatorimgview.isHidden = false
            } else {
                challegindicatorimgview.isHidden = true
            }
        } else {
            challegindicatorimgview.isHidden = true
        }
        challeninfoheader.text = setCRes?.challengeInfoHeader
        challengeinfo_text.text = setCRes!.challengeInfoText
        enter_code_text.text = setCRes?.challengeInfoLabel
        resendcode_btn.setTitle(setCRes?.resendInformationLabel, for: .normal)
        submitbtn.setTitle(setCRes?.submitAuthenticationLabel, for: .normal)
        sectionArray = [setCRes?.whyInfoLabel as Any, setCRes?.expandInfoLabel as Any]
        arrayForBool = ["0","0"]
        sectionContentDict = [setCRes?.whyInfoText as Any ,setCRes?.expandInfoText as Any]
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
            //challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "203", "T##errorDescription: String##String", "T##errorDetail: String##String")))
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver!.runtimeError(e)
            return
        }
        counter = "\(Int((setCRes?.acsCounterAtoS)!)! + 1)"
        while counter.count != 3 {
            counter = "0" + counter
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Enter_code_textfield.text = "validdata"
        Enter_code_textfield.becomeFirstResponder()
        //Submit_btnClick(UIButton())
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if setCRes!.psImage != nil {
            let databankimg = try? Data(contentsOf: URL(string: setCRes!.psImage.medium)!)
            let bankimg: UIImage = UIImage.init(data: databankimg!)!
            card_network_image.image = bankimg
            card_network_image.contentMode = .scaleAspectFill
        }
        if setCRes!.issuerImage != nil {
            let data = try? Data(contentsOf: URL(string: setCRes!.issuerImage.medium)!)
            let yourImage: UIImage = UIImage.init(data: data!)!
            your_bank_image.image = yourImage
            your_bank_image.contentMode = .scaleAspectFill
        }
    }
    
    
    @objc func dismissKeyboard(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
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
        AbstractNetRequest().post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func Cancelbtn() {
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "01", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
        let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
        self.transation!.progressHud?.show()
        AbstractNetRequest().post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Submit_btnClick(_ sender: Any) {
        self.transation!.progressHud?.show()
        guard (setCRes?.threeDSServerTransID) != nil else {
            //challengeStatusReceiver?.protocolError(ProtocolErrorEvent.init(deviceInfo.sharedDeviceInfo.sdkTransactionID, ErrorMessage.init((transation?.id)!, "203", "T##errorDescription: String##String", "T##errorDetail: String##String")))
            let e = RuntimeErrorEvent.init("203", "Invalid Argument")
            challengeStatusReceiver!.runtimeError(e)
            return
        }
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: Enter_code_textfield.text!, challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
        let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
        AbstractNetRequest().post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
        //self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:----------> Datasource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if((arrayForBool .object(at: section ) as AnyObject).boolValue == true) {
            _ = self.sectionArray.object(at: section) as! String
            //let countArray = (sectionContentDict.value(forKey: tps)) as! NSArray
            return 1
        }
        return 0;
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if((arrayForBool .object(at: (indexPath as NSIndexPath).section) as AnyObject).boolValue == true) {
            return UITableView.automaticDimension
        }
        return 0;
    }
    
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 25))
        headerView.tag = section
        let backMainView = UIView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: 60)) as UIView
        headerView.addSubview(backMainView)
        let backView = UIView(frame: CGRect(x: 12, y: 12, width: Int(self.view.frame.size.width - 24), height: 48)) as UIView
        backView.backgroundColor = UIColor.white
        backMainView.addSubview(backView)
        let titlelbl = UILabel(frame: CGRect(x: 10, y: 16, width: tableView.frame.size.width-80, height: 25)) as UILabel
        titlelbl.text = self.sectionArray.object(at: section) as? String
        titlelbl.textColor = UIColor.black
        titlelbl.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        headerView.addSubview(titlelbl)
        let expandbtn = UIButton(frame: CGRect(x: tableView.frame.size.width  - 40, y: 16, width: 25, height: 25))
        expandbtn.setBackgroundImage(UIImage.init(named: "icons-down-arrow"), for: .normal)
        headerView.addSubview(expandbtn)
        let headerTapped = UITapGestureRecognizer (target: self, action:#selector(self.sectionHeaderTapped(_:)))
        headerView .addGestureRecognizer(headerTapped)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "ExCell"
        var cell: ExCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ExCell
        if cell == nil {
            tableView.register(UINib(nibName: "ExCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ExCell
        }
        let manyCells : Bool = (arrayForBool .object(at: (indexPath as NSIndexPath).section) as AnyObject).boolValue
        if (!manyCells) {
        } else {
            cell.descriptionlbl.text = (self.sectionContentDict.object(at: indexPath.section) as! String)
        }
        return cell
    }
    
    
    @objc func sectionHeaderTapped(_ recognizer: UITapGestureRecognizer) {
        let indexPath = NSIndexPath(row: 0, section: (recognizer.view?.tag)!)
        if (indexPath.row == 0) {
            if (arrayForBool .object(at: indexPath.section) as AnyObject).boolValue == true {
                arrayForBool .replaceObject(at: indexPath.section, with: false)
            } else {
                arrayForBool .replaceObject(at: indexPath.section, with: true)
            }
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesIn: range)
            tableview.reloadSections(sectionToReload as IndexSet, with:UITableView.RowAnimation.none)
            tableviewheightconstant.constant = tableview.contentSize.height
            scrollview.contentSize = CGSize(width: 375, height: 600 + tableview.contentSize.height)
        }
    }
}
