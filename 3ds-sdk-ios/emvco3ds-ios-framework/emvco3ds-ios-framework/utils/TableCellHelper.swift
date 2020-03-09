//
//  TableCellHelper.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

public class TableCellHelper: NSObject {
    
    public class func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, selectedIndex: Int?, identifier: String, cellText:String) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = cellText
        if (selectedIndex != nil && indexPath.row == selectedIndex) {
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        cell.selectionStyle = .none;
        return cell
    }
    
    public class func selectRow (tableView: UITableView, selectedIndex: Int?, newSelectedIndex: Int) {
        if (selectedIndex != nil){
            tableView.cellForRow(at: IndexPath(row: selectedIndex!, section: 0))?.accessoryType = .none
        }
        tableView.cellForRow(at: IndexPath(row: newSelectedIndex, section: 0))?.accessoryType = .checkmark
    }
}
