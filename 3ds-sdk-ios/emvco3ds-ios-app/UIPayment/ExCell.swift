//
//  ExCell.swift
//  ExapandedDemo
//
//  Created by Virendra Patil on 5/1/19.
//  Copyright © 2019 Virendra Patil. All rights reserved.
//

import UIKit

class ExCell: UITableViewCell {

    @IBOutlet weak var ExpandBtn: UIButton!
    @IBOutlet weak var descriptionlbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
