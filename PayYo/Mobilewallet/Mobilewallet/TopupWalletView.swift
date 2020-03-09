//
//  TopupWalletView.swift
//  Mobilewallet
//
//  Created by Virendra patil on 21/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class TopupWalletView: UIViewController {

    @IBOutlet weak var topupview: UIView!
    @IBOutlet weak var paysecurebtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topupview.addUIViewborder(color: .lightGray, cornerradius: 10, borderwidth: 2)
        paysecurebtn.addUIViewborder(color: .lightGray, cornerradius: 5, borderwidth: 2)
    }
    
    @IBAction func paysecurebtnclick(_ sender: Any) {
        
    }
    

}
