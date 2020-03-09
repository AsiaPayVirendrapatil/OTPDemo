//  AddMoneyView.swift
//  Mobilewallet
//  Created by Virendra patil on 20/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit

class AddMoneyView: UIViewController {

    @IBOutlet weak var amounttextfiled: UITextField!
    @IBOutlet weak var AddmoneyView: UIView!
    @IBOutlet weak var addmoneybtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amounttextfiled.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor.black, width: 1)
        AddmoneyView.addUIViewborder(color: .lightGray, cornerradius: 10, borderwidth: 2)
        addmoneybtn.addUIViewborder(color: .lightGray, cornerradius: 5, borderwidth: 2)

    }
    
    @IBAction func addmoneybtnClikc(_ sender: Any) {
        
        let topupview = storyboard?.instantiateViewController(withIdentifier: "TopupWalletView") as! TopupWalletView
        self.navigationController?.pushViewController(topupview, animated: true)
    }
}


