//  BankListView.swift
//  OTPdemo
//  Created by Virendra patil on 02/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.


import UIKit

class BankListView: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var banklist : NSMutableArray = []
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        banklist = ["HDFC Bank","HSBC Bank","Bank 1","Bank 2","Bank 3"]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return banklist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifie = "BanklistCell"
        let cell = tableview.dequeueReusableCell(withIdentifier: identifie) as! BanklistCell
        cell.banknametextfield.text = (banklist.object(at: indexPath.row) as! String)
        cell.backview.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)

        cell.linkbankbtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 1)
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func ClosebtnClick(_ sender: Any) {

    }

}
