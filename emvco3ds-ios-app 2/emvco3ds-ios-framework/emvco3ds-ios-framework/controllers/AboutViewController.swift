//
//  AboutViewController.swift
//  emvco3ds-ios-app
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit
import WebKit

class AboutViewController: UIViewController {
    
    private let localFaqResourceFileName = "about"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAQ"
        let webView = self.createWebView()
        self.loadLocalFile(webView: webView)
    }
    
    private func createWebView()->WKWebView{
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let webView = WKWebView(frame: view.bounds, configuration: configuration)
        view.addSubview(webView)
        return webView
    }
    
    private func loadLocalFile(webView: WKWebView){
        let htmlFile = Emvco3dsFramework.bundle!.path(forResource: localFaqResourceFileName, ofType: "html")
        let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(html!, baseURL: nil)
    }
}
