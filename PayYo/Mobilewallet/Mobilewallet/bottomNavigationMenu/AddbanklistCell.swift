//
//  AddbanklistCell.swift
//  OTPdemo
//
//  Created by Virendra patil on 02/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class AddbanklistCell: UITableViewCell {

    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var banknametextfield: UILabel!
    @IBOutlet weak var accountnotextfiled: UILabel!
    @IBOutlet weak var cardholdernametextfiled: UILabel!
    @IBOutlet weak var removebtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
