//  AddCardListView.swift
//  OTPdemo
//  Created by Virendra patil on 02/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.


import UIKit

class AddCardListView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var addcardbtn: UIButton!
    @IBOutlet weak var menubutton: UIBarButtonItem!
    
    var banknamearr : NSMutableArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        banknamearr = ["HDFC Bank","ICICI Bank","KOTAK Bank"]
        
        if revealViewController() != nil {
            //revealViewController().rearViewRevealWidth = 62
            menubutton.target = revealViewController()
            menubutton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = "rightRevealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        tableview.isHidden = true
        addcardbtn.layer.cornerRadius = 20
        
    }

    @IBAction func AddcardbtnClick(_ sender: Any) {
        tableview.isHidden = false
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banknamearr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cardlistcell", for: indexPath) as! Cardlistcell
        cell.backview.layer.cornerRadius = 8
        cell.backview.layer.borderColor = UIColor.black.cgColor
        cell.backview.layer.borderWidth = 2
        cell.banknametextfield.text = (banknamearr.object(at: indexPath.row) as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            print("Deleted")
                banknamearr.removeObject(at: indexPath.row)
                tableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                self.tableview.reloadData()
        }
    }
}
