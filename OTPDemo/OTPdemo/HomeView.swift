//
//  HomeView.swift
//  OTPdemo
//
//  Created by Virendra patil on 29/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class HomeView: UIViewController {

    @IBOutlet weak var menubutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        
        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 62
            menubutton.target = revealViewController()
            menubutton.action = "revealToggle:"
            revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = "rightRevealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

}
