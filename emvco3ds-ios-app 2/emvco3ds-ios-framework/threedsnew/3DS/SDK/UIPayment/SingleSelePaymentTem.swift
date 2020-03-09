//  SingleSelePaymentTem.swift
//  emvco3ds-ios-app
//  Created by Virendra patil on 30/04/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.

import UIKit
import Alamofire


@objc public protocol SingleSelectorChallengeProtocol : GenericChallengeProtocol {
    func selectObject(_ index: Int)
}

@objc public protocol MultiSelectChallengeProtocol : GenericChallengeProtocol {
    func selectIndex(_ index: Int)
}

 @objc public protocol OutOfBandChallengeProtocol : GenericChallengeProtocol {

 }


class SingleSelePaymentTem: UIViewController,UITableViewDelegate,UITableViewDataSource ,SingleSelectorChallengeProtocol,MultiSelectChallengeProtocol,OutOfBandChallengeProtocol{
    
     var sdkChallengeProtocol : SDKChallengeProtocol?
    
    func clickVerifyButton() {
        Submit_btnClick(UIButton.init())
    }
    
    func getChallengeType() -> String {
        return (setCRes?.acsUiType)!
    }
    
    func clickCancelButton() {
        Cancelbtn()
    }
    
    func setChallengeProtocol(challegeprotocol: SDKChallengeProtocol) {
        sdkChallengeProtocol = challegeprotocol
    }
    
    func expandTextsBeforeScreenshot() {
        expand1btnclick(UIButton.init())
        expand2btnclick(UIButton.init())
    }
    
    func selectWhitelistChecked(checked: Bool) {
        print(checked)
    }
    
    func selectObject(_ index: Int) {
        selectedIndex = index
        tableview.reloadData()
    }

    func selectIndex(_ index: Int) {
        selectesvalue.append(index)
        tableview.reloadData()
     }
    
    func handleChallenge(){
        //CallRefreshUI()
        sdkChallengeProtocol?.handleChallenge()
    }

    
    @IBOutlet weak var multiviewstackview: UIStackView!
    @IBOutlet weak var enter_code_text: UILabel!
    var transation : Transaction? = nil
    var challengeParameters : ults_ChallengeParameters?
    var challengeStatusReceiver : ults_ChallengeStatusReceiver?
    var acsURL  : String = ""
    var passdata  : String = ""
    @IBOutlet weak var challengeindiimgview: UIImageView!
    @IBOutlet weak var headertxt: UILabel!
    @IBOutlet weak var card_network_img: UIImageView!
    @IBOutlet weak var your_bank_img: UIImageView!
    @IBOutlet weak var challengeinfo_text: UILabel!
    @IBOutlet weak var next_btn: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var tableviewhieghtconstant: NSLayoutConstraint!
    @IBOutlet weak var singtableview: UITableView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var Resend_btn: UIButton!
    @IBOutlet weak var warningimgwidth: NSLayoutConstraint!
    @IBOutlet weak var radiotableviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var expand1btn: UIButton!
    @IBOutlet weak var expand2btn: UIButton!
    @IBOutlet weak var expandtwolbl: UILabel!
    @IBOutlet weak var expandfirstlbl: UILabel!
    
    var chalseleInfoArray : [Any]?
    var selectedIndex = -1
    var selectesvalue : [Int] = []
    var setCRes : CresData? = nil
    var counter = ""
    var checkval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CallRefreshUI), name:
            UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CallRefresh), name:
            UIApplication.didBecomeActiveNotification, object: nil)

        if setCRes?.resendInformationLabel != nil {
        } else {
            Resend_btn.removeFromSuperview()
        }

        let frameBundle = Bundle(for: SingleSelePaymentTem.self)
        challengeindiimgview.image = UIImage(named: "Icon_warningindicator", in: frameBundle, compatibleWith: nil)
        
        if setCRes?.challengeInfoTextIndicator != nil {
            if setCRes?.challengeInfoTextIndicator == "Y" {

            } else {
                challengeindiimgview.removeFromSuperview()
            }
        } else {
            challengeindiimgview.removeFromSuperview()
        }
        next_btn.setTitle(setCRes?.submitAuthenticationLabel, for: .normal)
        next_btn.layer.cornerRadius = 6
        challengeinfo_text.text = setCRes?.challengeInfoText
        headertxt.text = setCRes?.challengeInfoHeader
        enter_code_text.text = setCRes?.challengeInfoLabel
        Resend_btn.layer.cornerRadius = 6
        Resend_btn.setTitle(setCRes?.resendInformationLabel, for: .normal)
        
        if setCRes?.whyInfoLabel != nil {
            expand1btn.setTitle((setCRes?.whyInfoLabel as Any as! String), for: .normal)
        }
        if setCRes?.whyInfoLabel != nil {
            expand2btn.setTitle((setCRes?.expandInfoLabel as Any as! String), for: .normal)
        }
        
        if setCRes?.whyInfoText != nil {
            expandfirstlbl.text = (setCRes?.whyInfoText as Any as! String)
        }
        
        if setCRes?.expandInfoText != nil {
            expandtwolbl.text = (setCRes?.expandInfoText as Any as! String)
        } else {
            multiviewstackview.isHidden = true
        }

        if setCRes?.acsUiType == "02"{
            tableview.isHidden = false
            if setCRes!.challengeSelectInfo?.count != 0 {
                chalseleInfoArray = setCRes!.challengeSelectInfo
            }
            next_btn.setTitle(setCRes?.submitAuthenticationLabel, for: .normal)
        } else if setCRes?.acsUiType == "03"{
            tableview.isHidden = false
            if setCRes!.challengeSelectInfo?.count != 0 {
                chalseleInfoArray = setCRes!.challengeSelectInfo
            }
            next_btn.setTitle(setCRes?.submitAuthenticationLabel, for: .normal)
        } else if setCRes?.acsUiType == "04" {
            tableview.isHidden = true
            next_btn.setTitle(setCRes?.oobContinueLabel, for: .normal)
        }
        self.title = "SECURE CHECKOUT"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let rightcancelbtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancelbtn))
        self.navigationItem.rightBarButtonItem  = rightcancelbtn
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
        counter = "\(Int((setCRes?.acsCounterAtoS)!)! + 1)"
        while counter.count != 3 {
            counter = "0" + counter
        }
        if setCRes!.challengeSelectInfo?.count != nil {
        } else {
            tableview.removeFromSuperview()
        }
        LoadUI()
    }

    func loadingimage() {
        if checkval == 2 {
           sdkChallengeProtocol?.handleChallenge()
        }
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
    
    func LoadUI() {
        
        if setCRes!.psImage != nil {
            let remoteImageURL = URL(string: (self.setCRes?.psImage.extraHigh)!)!
            Alamofire.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    print(response.result)
                    // Show the downloaded image:
                    if let data = response.data {
                        self.card_network_img.image = UIImage(data: data)
                        self.card_network_img.contentMode = .scaleAspectFit
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
                        self.your_bank_img.image = UIImage(data: data)
                        self.your_bank_img.contentMode = .scaleAspectFit
                        self.checkval = self.checkval + 1
                        self.loadingimage()
                    }
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func CallRefreshUI() {
        if setCRes?.challengeAddInfo != nil {
            challengeinfo_text.text = setCRes!.challengeAddInfo
            warningimgwidth.constant = 0
        }
    }
    
    @objc private func CallRefresh() {
        sdkChallengeProtocol?.handleChallenge()
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @objc func Cancelbtn() {
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "01", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
        let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
        self.transation!.progressHud?.show()
        APICall.shared.post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Submit_btnClick(_ sender: Any) {
        if setCRes?.acsUiType == "02" {
            if selectedIndex != -1 {
                let dic = setCRes!.challengeSelectInfo![selectedIndex] as! NSDictionary
                let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: "\(dic.allKeys[0]))", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
                let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
                self.transation!.progressHud?.show()
                APICall.shared.post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
            }
        } else if setCRes?.acsUiType == "03" {
            var keyval = ""
            for i in selectesvalue {
                let a = setCRes!.challengeSelectInfo![i] as! NSDictionary
                if keyval == "" {
                    keyval = "\(a.allKeys[0] as! String)"
                } else {
                    keyval = keyval + "," + "\(a.allKeys[0] as! String)"
                }
            }
            let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: "\(keyval)", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
            let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
            self.transation!.progressHud?.show()
            APICall.shared.post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
             //self.navigationController?.dismiss(animated: true, completion: nil)
            
        } else if setCRes?.acsUiType == "04" {
            let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: true, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
            let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
            self.transation!.progressHud?.show()
            APICall.shared.post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    //MARK:---------------> DataSorce and Delegate Method.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if (setCRes?.acsUiType == "04") {
                return 0
            }
            return (setCRes!.challengeSelectInfo?.count ?? 0)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let identifie = "ChallengeSeleInfoCell"
            let cellid = tableView.dequeueReusableCell(withIdentifier: identifie) as! ChallengeSeleInfoCell
            if setCRes?.acsUiType == "02" {
                if selectedIndex == indexPath.row {
                    let frameBundle = Bundle(for: SingleSelePaymentTem.self)
                    cellid.checkboxbtn.image = UIImage(named: "led-green-black1", in: frameBundle, compatibleWith: nil)
                } else {
                    let frameBundle = Bundle(for: SingleSelePaymentTem.self)
                    cellid.checkboxbtn.image = UIImage(named: "led-gray-black1", in: frameBundle, compatibleWith: nil)
                }
            }
            if setCRes?.acsUiType == "03" {
                if selectesvalue.contains(indexPath.row) {
                    let frameBundle = Bundle(for: SingleSelePaymentTem.self)
                    cellid.checkboxbtn.image = UIImage(named: "selected_checkbox", in: frameBundle, compatibleWith: nil)
                } else {
                    let frameBundle = Bundle(for: SingleSelePaymentTem.self)
                    cellid.checkboxbtn.image = UIImage(named: "unchecked-checkbox", in: frameBundle, compatibleWith: nil)
                }
            }
            if chalseleInfoArray?.count != 0 {
                cellid.selectedInfocell.text = ""
                let dic = setCRes!.challengeSelectInfo![indexPath.row] as! NSDictionary
                var keyval = dic.allKeys as! [String]
                cellid.selectedInfocell.text = "\(dic[keyval[0]] ?? "")"
            } else {
                cellid.selectedInfocell.text = ""
            }
            return cellid
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if setCRes?.acsUiType == "02"{
            selectedIndex = indexPath.row
        } else {
            let copySelectedValue = selectesvalue
            if (copySelectedValue.contains(indexPath.row)) {
                var indexForValue = 0
                for i in copySelectedValue {
                    if i == indexPath.row {
                        selectesvalue.remove(at: indexForValue)
                        break
                    }
                    indexForValue = indexForValue + 1
                }
            } else {
                selectesvalue.append(indexPath.row)
            }
        }
        selectedIndex = indexPath.row
        let keyval = setCRes!.challengeSelectInfo![selectedIndex] as! NSDictionary
        passdata.append("\(keyval.allKeys[0])")
        tableView.reloadData()
    }

}
