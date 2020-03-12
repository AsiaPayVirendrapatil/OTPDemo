//
//  ViewController.swift
//  OTPdemo
//
//  Created by Virendra patil on 27/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mobilenumbertextfiled: UITextField!
    
    let tabBarControlle = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favoritesVC = CardView()
        favoritesVC.title = "Favorites"
        favoritesVC.view.backgroundColor = UIColor.orange
        let downloadsVC = HomeView()
        downloadsVC.title = "Downloads"
        downloadsVC.view.backgroundColor = UIColor.blue
        //let historyVC = ViewController()
        //historyVC.title = "History"
        //historyVC.view.backgroundColor = UIColor.cyan
        
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        downloadsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        //historyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        
        let controllers = [favoritesVC, downloadsVC]
        tabBarControlle.viewControllers = controllers
        
        self.addChild(tabBarControlle)

        let button: UIButton = UIButton(frame: CGRect(x: view.bounds.width / 2-50, y: view.bounds.height / 2, width: 100, height: 50))
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(pushToNextVC), for: .touchUpInside)
        self.view.addSubview(button)
    }

    @objc func pushToNextVC() {
        
//        let newVC = UIViewController()
//        newVC.view.backgroundColor = UIColor.red
//        self.navigationController?.pushViewController(newVC, animated:
//            true)
    }
    
    @IBAction func SubmitbtnClick(_ sender: Any) {
        
        
    }
}

