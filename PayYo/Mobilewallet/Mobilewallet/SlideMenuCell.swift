//
//  SlideMenuCell.swift
//  Foos
//
//  Created by Virendra patil on 30/09/19.
//  Copyright © 2019 Bhushan  Borse. All rights reserved.
//

import UIKit

class SlideMenuCell: UITableViewCell {
    
    
    @IBOutlet weak var menulbl: UILabel!
    @IBOutlet weak var imgview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
