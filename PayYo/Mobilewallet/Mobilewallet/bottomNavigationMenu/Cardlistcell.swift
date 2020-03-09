//
//  Cardlistcell.swift
//  OTPdemo
//
//  Created by Virendra patil on 02/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class Cardlistcell: UITableViewCell {

    @IBOutlet weak var banknametextfield: UILabel!
    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var sidebtn: UIButton!
    @IBOutlet weak var accnotextfield: UILabel!
    @IBOutlet weak var validnametextfield: UILabel!
    @IBOutlet weak var expirydatetextfield: UILabel!
    @IBOutlet weak var cardholdertextfield: UILabel!
    @IBOutlet weak var cardtypetextfield: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
