//
//  MainView.swift
//  OTPdemo
//
//  Created by Virendra patil on 29/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class MainView: UIViewController {

    
    var firstTabNavigationController : UINavigationController!
    var secondTabNavigationControoller : UINavigationController!
    var thirdTabNavigationController : UINavigationController!
    var fourthTabNavigationControoller : UINavigationController!
    var fifthTabNavigationController : UINavigationController!
    let tabBarControlle = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()

        firstTabNavigationController = UINavigationController.init(rootViewController: HomeView())
        secondTabNavigationControoller = UINavigationController.init(rootViewController: CardView())
       // thirdTabNavigationController = UINavigationController.init(rootViewController: ThirdViewController())
       // fourthTabNavigationControoller = UINavigationController.init(rootViewController: FourthViewController())
       // fifthTabNavigationController = UINavigationController.init(rootViewController: FifthViewController())
        
        tabBarControlle.viewControllers = [firstTabNavigationController, secondTabNavigationControoller ]
        
        let item1 = UITabBarItem(title: "Home", image: UIImage(named: "ico-home"), tag: 0)
        let item2 = UITabBarItem(title: "Content", image:  UIImage(named: "ico-contest"), tag: 1)
        let item3 = UITabBarItem(title: "Post a Picture", image:  UIImage(named: "ico-photo"), tag: 2)
        let item4 = UITabBarItem(title: "Prizes", image:  UIImage(named: "ico-prizes"), tag: 3)
        let item5 = UITabBarItem(title: "Profile", image:  UIImage(named: "ico-profile"), tag: 4)
 
        firstTabNavigationController.tabBarItem = item1
        secondTabNavigationControoller.tabBarItem = item2
        UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 146/255.0, blue: 248/255.0, alpha: 1.0)
    }
    
    @IBAction func btnclick(_ sender: Any) {

         //let newVC =  UINavigationController()
        //newVC.view.backgroundColor = UIColor.red
        //self.navigationController?.pushViewController(tabBarController, animated:true)
        //self.navigationController?.pushViewController(tabBarControlle, animated:true)
        
//        let addcardlistview = storyboard?.instantiateViewController(withIdentifier: "AddCardListView") as! AddCardListView
//        self.navigationController?.pushViewController(addcardlistview, animated: true)
        
//        let addcardlistview = storyboard?.instantiateViewController(withIdentifier: "AddBankView") as! AddBankView
//        self.navigationController?.pushViewController(addcardlistview, animated: true)
    }
}
