//
//  AddBankView.swift
//  OTPdemo
//  Created by Virendra patil on 02/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.


import UIKit

class AddBankView: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var menubutton: UIBarButtonItem!
    var banknamelistarr : NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        banknamelistarr = ["HDFC Bank"]
        tableview.isHidden = true
        
        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 62
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = "rightRevealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banknamelistarr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "AddbanklistCell", for: indexPath) as! AddbanklistCell
        cell.banknametextfield.text = (banknamelistarr.object(at: indexPath.row) as! String)
        cell.backview.layer.cornerRadius = 8
        cell.backview.layer.borderColor = UIColor.black.cgColor
        cell.backview.layer.borderWidth = 2

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            print("Deleted")
            banknamelistarr.removeObject(at: indexPath.row)
            tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.tableview.reloadData()
        }
    }
    
    @IBAction func addbankbtnClick(_ sender: Any) {
        let banklistview = storyboard?.instantiateViewController(withIdentifier: "BankListView") as! BankListView
        self.navigationController?.pushViewController(banklistview, animated: true)
        tableview.isHidden = false
    }

}
