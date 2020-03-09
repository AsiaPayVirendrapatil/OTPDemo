//  ChatView.swift
//  Mobilewallet
//  Created by Virendra patil on 22/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.


import UIKit

class ChatView: UIViewController {

    @IBOutlet weak var rightside: UILabel!
    @IBOutlet weak var leftside: UILabel!
    @IBOutlet weak var bottomview: UIView!
    @IBOutlet weak var sendbtn: UIButton!
    @IBOutlet weak var reuestbtn: UIButton!
    static var viewname : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        rightside.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 2)
        leftside.addUIViewborder(color: .lightGray, cornerradius: 8, borderwidth: 2)
        bottomview.addUIViewborder(color: .lightGray, cornerradius: 1, borderwidth: 2)
        sendbtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)
        reuestbtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)
    }
    @IBAction func requestbtnClick(_ sender: Any) {
        let reuestsendview = storyboard?.instantiateViewController(withIdentifier: "RequestsendView") as! RequestsendView
        reuestsendview.title = "Request To \(self.title!)"
        self.navigationController?.pushViewController(reuestsendview, animated: true)
    }

    @IBAction func sendrequestbtnclick(_ sender: Any) {
        let reuestsendview = storyboard?.instantiateViewController(withIdentifier: "RequestsendView") as! RequestsendView
        reuestsendview.title = "Pay To \(self.title!)"
        self.navigationController?.pushViewController(reuestsendview, animated: true)
    }

}
