//
//  ACSignUpTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACSignUpTVCell: UITableViewCell {

    @IBOutlet weak var commonTextField: ACCustomTextField!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
