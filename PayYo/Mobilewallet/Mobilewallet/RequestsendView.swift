//  RequestsendView.swift
//  Mobilewallet
//  Created by Virendra patil on 25/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit

class RequestsendView: UIViewController {

    @IBOutlet weak var amounttextfield: UITextField!
    @IBOutlet weak var comenttextfield: UITextField!
    @IBOutlet weak var requestmoneybtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.title == "Request To \(self.title!)" {
            requestmoneybtn.setTitle("Request Money", for: .normal)
        } else {
            requestmoneybtn.setTitle("Send Money", for: .normal)
        }
        requestmoneybtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)
        amounttextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
        comenttextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
    }

    @IBAction func requestbtnClick(_ sender: Any) {

     }
}
