//
//  ACQRCodeTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 04/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACQRCodeTVCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    
    @IBOutlet weak var qrCodeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
