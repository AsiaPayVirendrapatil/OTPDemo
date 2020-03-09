//  ProfileView.swift
//  Mobilewallet
//  Created by Virendra patil on 26/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.


import UIKit

class ProfileView: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    var namedata  : NSMutableArray = []
    var imagename  : NSMutableArray = []
    @IBOutlet weak var menubutton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ProfileView"
        namedata = ["My QR Code","location" ,"Language","KYC Detail"]
        imagename = ["icons_qr-code","icons_address","icons_language","icons_digi-id"]

        if revealViewController() != nil {
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 190
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return namedata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "profileViewCell") as! profileViewCell
        cell.titlename?.text = (namedata.object(at: indexPath.row) as! String)
        cell.imageview.image = UIImage.init(named: imagename.object(at: indexPath.row) as! String)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
