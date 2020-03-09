//  TabView.swift
//  OTPdemo
//  Created by Virendra patil on 04/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

import UIKit

class TabView: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        //Create Tab one
//        let tabOne = MainView()
//        let tabOneBarItem = UITabBarItem(title: "Tab 1", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
//        tabOne.tabBarItem = tabOneBarItem
        
//        //Create Tab two
//        let tabTwo = CardView()
//        let tabTwoBarItem2 = UITabBarItem(title: "Tab 2", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
//        tabTwo.tabBarItem = tabTwoBarItem2
//        self.viewControllers = [tabOne, tabTwo]
        
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //print("Selected \(viewController.title!)")
        
    }


}
