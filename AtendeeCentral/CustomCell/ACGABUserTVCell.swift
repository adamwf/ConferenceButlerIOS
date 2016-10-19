//
//  ACGABUserTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 09/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACGABUserTVCell: UITableViewCell {

    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailIdLabel: UILabel!
    @IBOutlet weak var userPhoneNoLabel: UILabel!
    @IBOutlet weak var userAddresslLabel: UILabel!
    @IBOutlet weak var userMessageButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        getRoundImage(userImageView)
       
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.messageButton.layer.cornerRadius = 2.0
        self.messageButton.clipsToBounds = true
       
        // Configure the view for the selected state
    }

}
