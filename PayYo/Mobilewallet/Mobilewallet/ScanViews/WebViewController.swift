//
//  WebViewController.swift
//  Mobilewallet
//
//  Created by Virendra patil on 17/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet var webview : UIWebView!
    
    var url = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlreq = URLRequest(url: url!)
        webview.loadRequest(urlreq)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
