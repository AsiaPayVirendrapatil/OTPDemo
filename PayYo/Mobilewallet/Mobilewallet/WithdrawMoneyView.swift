//  WithdrawMoneyView.swift
//  Mobilewallet
//  Created by Virendra patil on 05/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit

class WithdrawMoneyView: UIViewController {

    @IBOutlet weak var amounttextfield: UITextField!
    @IBOutlet weak var withdrawmoneybtn: UIButton!
    @IBOutlet weak var backview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        withdrawmoneybtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)
        amounttextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .lightGray, width: 2)
        backview.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 2)
    }
    
    @IBAction func WithdrawbtnClick(_ sender: Any) {
        
    }
    
}
