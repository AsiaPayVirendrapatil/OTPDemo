//
//  WebhtmlView.swift
//  emvco3ds-ios-app
//
//  Created by Virendra patil on 15/05/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.
//

import UIKit

class WebhtmlView: UIViewController , UIWebViewDelegate{
    
    var getstr : String = ""
    
    var transation : Transaction? = nil
    var challengeParameters : ults_ChallengeParameters?
    var challengeStatusReceiver : ults_ChallengeStatusReceiver?
    var setCRes : CresData? = nil
    var counter = ""
    var acsURL = ""
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SECURE CHECKOUT"
        let textAttribu = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttribu
        
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        getstr = (request.url?.absoluteString.replacingOccurrences(of: "https://emv3ds/challenge?", with: ""))!
        Submit_btnClick()
        return false
    }
    
    
    func Submit_btnClick() {
        let cReq = CReq.init(sdkCounterStoA: counter, acsTransID: (setCRes?.acsTransID)! , sdkTransID: (setCRes?.sdkTransID)!, threeDSServerTransID: (setCRes?.threeDSServerTransID)!, challengCancel: "", challengDataEntry: "", challengHTMLDataEntry: getstr, messageExtension: "", oobContinue: false, challengWindowSize: "", messageType: "CReq", resendChallenge: "")
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
    
    
}

