//
//  ShowhistoryView.swift
//  Mobilewallet
//
//  Created by Virendra patil on 02/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class ShowhistoryView: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var menubutton: UIBarButtonItem!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var filterbtn: UIButton!
    @IBOutlet weak var filtertextfiled: UILabel!
    var namearray : NSMutableArray = []
    
    var searchActive : Bool = false
    var data :[String] = []
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterbtn.addUIViewborder(color: .lightGray, cornerradius: 6, borderwidth: 2)
        searchbar.delegate = self
        data = ["Shriniwas","Nitin","Virendra","Rajesh","Vallabh","Ganesh","Kandroid",""]

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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchActive = true
    }
    
    private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    private func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    private func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered =  data.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableview.reloadData()
    }

    @IBAction func filterbtnClick(_ sender: Any) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(searchActive) {
            return filtered.count
        }
        return data.count
     }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifie = "showhistorylistCell"
        let cell = tableview.dequeueReusableCell(withIdentifier: identifie) as! showhistorylistCell
        cell.backview.addUIViewborder(color: .lightGray, cornerradius: 5, borderwidth: 2)

        if(searchActive){
            cell.nametextfield.text = filtered[indexPath.row]
        } else {
            let aa = data[indexPath.row]
            cell.nametextfield.text = aa
        }
        return cell
    }
    
}
