//
//  ChallengeSeleInfoCell.swift
//  emvco3ds-ios-app
//
//  Created by Virendra patil on 30/04/19.
//  Copyright © 2019 UL Transaction Security. All rights reserved.
//

import UIKit

class ChallengeSeleInfoCell: UITableViewCell {
    @IBOutlet weak var selectedInfocell: UILabel!
    @IBOutlet weak var checkboxbtn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
