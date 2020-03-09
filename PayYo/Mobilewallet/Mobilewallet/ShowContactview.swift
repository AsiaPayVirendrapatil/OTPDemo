//
//  ShowContactview.swift
//  Mobilewallet
//
//  Created by Virendra patil on 22/11/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class ShowContactview:  UIViewController,UITableViewDataSource,UISearchBarDelegate,UITableViewDelegate {

    @IBOutlet weak var serchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    var dataArray : NSMutableArray = []
    var filteredArray : NSMutableArray = []
    var searchController: UISearchController!
    
    var searchActive : Bool = false
    var data :[String] = []
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        data = ["issac","Rajesh","Virendra Patil","Victor","Shriniwas","Jo Chan","Dhawal","Priyanka","Sanjay"]
        serchbar.delegate = self
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filtered.count
            }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifie = "SearchtableViewCell"
        let cell = tableview.dequeueReusableCell(withIdentifier: identifie) as! SearchtableViewCell
        if(searchActive){
            cell.searchtextcell.text = filtered[indexPath.row]
        } else {
            let aa = data[indexPath.row]
            cell.searchtextcell.text = aa
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if(searchActive){
            let getbank  = filtered[indexPath.row]
            let chatview = storyboard?.instantiateViewController(withIdentifier: "ChatView") as! ChatView
            chatview.title = getbank
            self.navigationController?.pushViewController(chatview, animated: true)
        } else {
             let aa = data[indexPath.row]
             let chatview = storyboard?.instantiateViewController(withIdentifier: "ChatView") as! ChatView
             chatview.title = aa
             self.navigationController?.pushViewController(chatview, animated: true)
        }
        tableview.reloadData()
    }
}

