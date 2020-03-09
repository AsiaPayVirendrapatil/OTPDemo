//  BanklistCell.swift
//  OTPdemo
//  Created by Virendra patil on 02/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.


import UIKit

class BanklistCell: UITableViewCell {

    @IBOutlet weak var linkbankbtn: UIButton!
    @IBOutlet weak var banknametextfield: UILabel!
    @IBOutlet weak var backview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
