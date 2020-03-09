//  SingleSelePaymentTem.swift
//  emvco3ds-ios-app
//  Created by Virendra patil on 30/04/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.

import UIKit
import emvco3ds_ios_framework



class SingleSelePaymentTem: UIViewController,UITableViewDelegate,UITableViewDataSource {
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
    var chalseleInfoArray : [Any]?
    var arrayForBool             : NSMutableArray = []
    var sectionArray             : NSMutableArray = []
    var sectionContentDict       : NSMutableArray = []
    var selectedIndex = -1
    var selectesvalue : [Int] = []
    var setCRes : CresData? = nil
    var counter = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CallRefreshUI), name: UIApplication.willEnterForegroundNotification, object: nil)
        if setCRes?.resendInformationLabel != nil {
            Resend_btn.isHidden = false
        } else {
            Resend_btn.isHidden = true
        }
        if setCRes?.challengeInfoTextIndicator != nil {
            if setCRes?.challengeInfoTextIndicator == "Y" {
                challengeindiimgview.isHidden = false
            } else {
                challengeindiimgview.isHidden = true
            }
        } else {
            challengeindiimgview.isHidden = true
        }
        next_btn.setTitle(setCRes?.submitAuthenticationLabel, for: .normal)
        next_btn.layer.cornerRadius = 4
        challengeinfo_text.text = setCRes?.challengeInfoText
        headertxt.text = setCRes?.challengeInfoHeader
        enter_code_text.text = setCRes?.challengeInfoLabel
        Resend_btn.layer.cornerRadius = 4
        Resend_btn.setTitle(setCRes?.resendInformationLabel, for: .normal)
        sectionArray = [setCRes?.whyInfoLabel as Any , setCRes?.expandInfoLabel as Any]
        arrayForBool = ["0","0"]
        sectionContentDict = [setCRes?.whyInfoText as Any ,setCRes?.expandInfoText as Any]
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
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedIndex = 0
        Submit_btnClick(UIButton())
    }
    
    
    @objc private func CallRefreshUI() {
        //if setCRes?.acsUiType == "04" {
        if setCRes?.challengeAddInfo != nil {
            challengeinfo_text.text = setCRes!.challengeAddInfo
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if setCRes!.psImage != nil {
            let url = URL(string: setCRes!.psImage.medium)
            let data = try? Data(contentsOf: url!)
            let yourImage: UIImage = UIImage.init(data: data!)!
            card_network_img.image = yourImage
            card_network_img.contentMode = .scaleAspectFill
        }
        if setCRes!.issuerImage != nil {
            let urlbankimg = URL(string: setCRes!.issuerImage.medium)
            let databankimg = try? Data(contentsOf: urlbankimg!)
            let bankimg: UIImage = UIImage.init(data: databankimg!)!
            your_bank_img.image = bankimg
            your_bank_img.contentMode = .scaleAspectFill
        }
    }
    
    
    @objc func Cancelbtn() {
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "01", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
        let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
        self.transation!.progressHud?.show()
        AbstractNetRequest().post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func Submit_btnClick(_ sender: Any) {
        if setCRes?.acsUiType == "02" {
            if selectedIndex != -1 {
                let dic = setCRes!.challengeSelectInfo![selectedIndex] as! NSDictionary
                let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: "\(dic.allKeys[0]))", challengHTMLDataEntry: "", messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
                let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
                self.transation!.progressHud?.show()
                AbstractNetRequest().post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
                self.navigationController?.dismiss(animated: true, completion: nil)
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
            AbstractNetRequest().post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else if setCRes?.acsUiType == "04" {
            let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: "", messageExtension: "", oobContinue: true, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
            let makefinal = CreqEncryption().getCreq128GCM(acstransId: (setCRes?.acsTransID)!, get3DSServerTransactionID: (setCRes?.threeDSServerTransID)!, sdkCounter: Int(counter)!, creqJson: cReq.toJson())
            self.transation!.progressHud?.show()
            AbstractNetRequest().post(stringData:makefinal , url: acsURL, transation: self.transation!, challengeParameters: self.challengeParameters!, challengeStatusReceiver: self.challengeStatusReceiver!, ui: self)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:----------> Datasource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == singtableview {
            return self.sectionArray.count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == singtableview {
            return 50
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == singtableview {
            if((arrayForBool .object(at: (indexPath as NSIndexPath).section) as AnyObject).boolValue == true) {
                return UITableView.automaticDimension
            }
        } else {
            return 40
        }
        return 40
    }
    
    
    //MARK:---------------> DataSorce and Delegate Method.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == singtableview {
            if((arrayForBool .object(at: section ) as AnyObject).boolValue == true) {
                return 1
            } else {
                return 0
            }
        } else {
            if (setCRes?.acsUiType == "04") {
                return 0
            }
            return (setCRes!.challengeSelectInfo?.count ?? 0)!
        }
    }
    
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == singtableview {
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
        } else {
            let headerVieww = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 0))
            return headerVieww
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == singtableview {
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
        } else {
            let identifie = "ChallengeSeleInfoCell"
            let cellid = tableView.dequeueReusableCell(withIdentifier: identifie) as! ChallengeSeleInfoCell
            if setCRes?.acsUiType == "02" {
                cellid.checkboxbtn.setImage(UIImage.init(named:"Deselected_icon"), for: .normal)
            } else if setCRes?.acsUiType == "03" {
                cellid.checkboxbtn.setImage(UIImage.init(named:"unchecked-checkbox"), for: .normal)
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
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if setCRes?.acsUiType == "02"{
            selectedIndex = indexPath.row
            //let keyval = setCRes!.challengeSelectInfo![selectedIndex] as! NSDictionary
            //passdata.append("\(keyval.allKeys[0])")
            //print(passdata)
        } else {
            if (selectesvalue.contains(indexPath.row)) {
                var a = 0
                for i in selectesvalue {
                    a = a + 1
                    if i == indexPath.row {
                        selectesvalue.remove(at: a)
                    }
                }
            } else {
                selectesvalue.append(indexPath.row)
            }
            //let keyval = setCRes!.challengeSelectInfo![selectesvalue] as! NSDictionary
            //passdata.append("\(keyval.allKeys[0])")
            //print(passdata)
        }
        selectedIndex = indexPath.row
        let keyval = setCRes!.challengeSelectInfo![selectedIndex] as! NSDictionary
        passdata.append("\(keyval.allKeys[0])")
        //print(passdata)
    }
    
    //MARK:------------------> Section headerView Click <-----------------------------------
    @objc func sectionHeaderTapped(_ recognizer: UITapGestureRecognizer) {
        let indexPath = NSIndexPath(row: 0, section: (recognizer.view?.tag)!)
        if (indexPath.row == 0) {
            if (arrayForBool .object(at: indexPath.section) as AnyObject).boolValue == true {
                arrayForBool .replaceObject(at: indexPath.section, with: false)
            } else {
                arrayForBool .replaceObject(at: indexPath.section, with: true)
            }
            //----------> reload specific section animated <----------
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesIn: range)
            singtableview.reloadSections(sectionToReload as IndexSet, with:UITableView.RowAnimation.none)
            tableviewhieghtconstant.constant = singtableview.contentSize.height
            scrollview.contentSize = CGSize(width: 375, height: 667 + singtableview.contentSize.height)
        }
    }
}
