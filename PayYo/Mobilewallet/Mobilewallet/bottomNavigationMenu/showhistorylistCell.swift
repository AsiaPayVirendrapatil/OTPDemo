//
//  showhistorylistCell.swift
//  Mobilewallet
//
//  Created by Virendra patil on 02/12/19.
//  Copyright © 2019 Virendra patil. All rights reserved.
//

import UIKit

class showhistorylistCell: UITableViewCell {

    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var moneystatus: UILabel!
    @IBOutlet weak var datetextfield: UILabel!
    @IBOutlet weak var nametextfield: UILabel!
    @IBOutlet weak var cardstatustextfield: UILabel!
    @IBOutlet weak var amounttextfield: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
