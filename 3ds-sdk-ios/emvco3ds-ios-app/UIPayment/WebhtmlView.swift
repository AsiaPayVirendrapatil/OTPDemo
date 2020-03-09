//
//  WebhtmlView.swift
//  emvco3ds-ios-app
//
//  Created by Virendra patil on 15/05/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.
//

import UIKit
import emvco3ds_ios_framework



class WebhtmlView: UIViewController , UIWebViewDelegate {
    var transation : Transaction? = nil
    var challengeParameters : ults_ChallengeParameters?
    var challengeStatusReceiver : ults_ChallengeStatusReceiver?
    var setCRes : CresData? = nil
    var counter = ""
    var acsURL = ""
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(CallRefreshUI), name: UIApplication.willEnterForegroundNotification, object: nil)
        counter = "\(Int((setCRes?.acsCounterAtoS)!)! + 1)"
        while counter.count != 3 {
            counter = "0" + counter
        }
        guard let htmlText = setCRes?.acsHTML else {
            return
        }
        webView.loadHTMLString(String.init(data: Data.init(base64URLEncoded: htmlText)!, encoding: .utf8)!, baseURL: nil)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let rightcancelbtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(Cancelbtn))
        self.navigationItem.rightBarButtonItem  = rightcancelbtn
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(textAttributes, for: .normal)
        webView.delegate = self
        //["messageVersion": 2.1.0, "issuerImage": {
        //extraHigh = "https:3ds.selftestplatform.com/images/BankLogo_extraHigh.png";
        //high = "https:3ds.selftestplatform.com/images/BankLogo_high.png";
        //medium = "https:3ds.selftestplatform.com/images/BankLogo_medium.png";
        //}, "challengeCompletionInd": N, "psImage": {
        //extraHigh = "https:3ds.selftestplatform.com/images/ULCardScheme_extraHigh.png";
        //high = "https:3ds.selftestplatform.com/images/ULCardScheme_high.png";
        //medium = "https:3ds.selftestplatform.com/images/ULCardScheme_medium.png";
        //}, "acsTransID": 7a103dd5-d0b0-48ad-b94d-4f03c4fbd2d1, "acsUiType": 05, "acsHTML": PCFET0NUWVBFIGh0bWw-PGh0bWw-PGhlYWQ-PG1ldGEgY2hhcnNldD0iSVNPLTg4NTktMSI-PHRpdGxlPkFDUyBjaGFsbGVuZ2U8L3RpdGxlPjwvaGVhZD48Ym9keT48Zm9ybSBhY3Rpb249IkhUVFBTOi8vRU1WM0RTL2NoYWxsZW5nZSIgbWV0aG9kPSJnZXQiPjxpbnB1dCB0eXBlPSJ0ZXh0IiBuYW1lPSJwYXNzd29yZCIgaWQ9InRleHQiIC8-PGlucHV0IHR5cGU9InN1Ym1pdCIgdmFsdWU9InN1Ym1pdCIgaWQ9InN1Ym1pdCIvPjwvZm9ybT48L2JvZHk-PC9odG1sPg, "messageType": CRes, "acsCounterAtoS": 000, "sdkTransID": 4f5fc8a5-6d7c-4333-a96d-678517dcd0fc, "threeDSServerTransID": e7afcbde-704c-4d73-ac2c-27be46e1efc8]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Submit_btnClick(str: "password=invaliddata")
    }
    
    @objc private func CallRefreshUI() {
        if setCRes?.acsHTMLRefresh != nil {
            guard let htmlText = setCRes?.acsHTMLRefresh else {
                return
            }
            webView.loadHTMLString(String.init(data: Data.init(base64URLEncoded: htmlText)!, encoding: .utf8)!, baseURL: nil)
        }
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if request.url?.absoluteString == "about:blank" {
            return true
        }
        let getstr = request.url?.absoluteString.replacingOccurrences(of: "https://emv3ds/challenge?", with: "")
        Submit_btnClick(str: getstr!)
        return false
    }
    
    
    func Submit_btnClick(str : String) {
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: str, messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
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
    
    
}



