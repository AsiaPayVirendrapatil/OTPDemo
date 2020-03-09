//  SlideMenuView.swift
//  Foos
//  Created by Virendra patil on 30/09/19.
//  Copyright © 2019 Bhushan  Borse. All rights reserved.


import UIKit

class SlideMenuView: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var userprofile_imgview: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var usermailid_lbl: UILabel!
    let menuarry : NSMutableArray = ["Home","Setting","Logout"]
    let imagename : NSMutableArray = ["home","settings","logout"]

    override func viewDidLoad() {
        super.viewDidLoad()

        userprofile_imgview.layer.cornerRadius = 40
        userprofile_imgview.layer.masksToBounds = true
        userprofile_imgview.addUIViewborder(color: .lightGray, cornerradius: 40, borderwidth: 2)
    }

    @IBAction func userprofilebtnClick(_ sender: Any) {
        
        let profileView = storyboard?.instantiateViewController(withIdentifier: "ProfileView") as! ProfileView
        let navigation = UINavigationController.init(rootViewController: profileView)
        self.navigationController?.pushViewController(navigation, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuarry.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableview.dequeueReusableCell(withIdentifier: "SlideMenuCell", for: indexPath) as! SlideMenuCell
       cell.menulbl.text = (menuarry.object(at: indexPath.row) as! String)
       cell.imgview.image = UIImage.init(named: imagename.object(at: indexPath.row) as! String)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if menuarry.object(at: indexPath.row) as! String == "Home" {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showLoggedInUserScreens()
        } else if menuarry.object(at: indexPath.row) as! String == "Logout" {
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.ShowLogOutScreen()
        } else if menuarry.object(at: indexPath.row) as! String == "Setting" {

        }
    }
    
}
