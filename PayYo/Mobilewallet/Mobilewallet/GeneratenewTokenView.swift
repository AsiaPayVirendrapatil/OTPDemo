//  GeneratenewTokenView.swift
//  Mobilewallet
//  Created by Virendra patil on 25/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.


import UIKit

class GeneratenewTokenView: UIViewController {
    @IBOutlet weak var amounttextfield: UITextField!
    @IBOutlet weak var generttokenbtn: UIButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        generttokenbtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)
        amounttextfield.addLine(position: .LINE_POSITION_BOTTOM, color: .black, width: 1)
    }
    
    @IBAction func GenerateTokenbtnClick(_ sender: Any) {

        let qrview = storyboard?.instantiateViewController(withIdentifier: "GenerateQRtokenView") as! GenerateQRtokenView
        self.navigationController?.pushViewController(qrview, animated: true)
    }
}
