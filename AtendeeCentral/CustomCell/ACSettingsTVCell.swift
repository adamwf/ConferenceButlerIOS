//
//  ACSettingsTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACSettingsTVCell: UITableViewCell {

    
    @IBOutlet weak var itemNameLabel: ACCustomLabel!
    
    @IBOutlet weak var rightArrowImgView: UIImageView!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var selectButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.statusSwitch.layer.cornerRadius = 16.0
//        self.statusSwitch.layer.borderWidth = 1.0
//        self.statusSwitch.layer.borderColor = UIColor.grayColor().CGColor
//        self.statusSwitch.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
