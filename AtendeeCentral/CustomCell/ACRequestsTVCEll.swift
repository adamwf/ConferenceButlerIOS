//
//  ACRequestsTVCEll.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACRequestsTVCEll: UITableViewCell {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    @IBOutlet var declineButton: UIButton!
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var infoHandelsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        getRoundImage(self.userProfileImageView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
