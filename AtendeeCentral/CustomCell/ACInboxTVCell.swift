//
//  ACInboxTVCell.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 06/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACInboxTVCell: UITableViewCell {

    @IBOutlet var messageListImageView: UIImageView!
    @IBOutlet weak var messageListLabelDescription: UILabel!
    @IBOutlet weak var messageListDate: UILabel!

    @IBOutlet var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
