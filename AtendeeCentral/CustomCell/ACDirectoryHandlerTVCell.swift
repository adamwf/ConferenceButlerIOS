//
//  ACDirectoryHandlerTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 09/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACDirectoryHandlerTVCell: UITableViewCell {

    @IBOutlet var socialMediaImgView: UIImageView!
    @IBOutlet weak var gabScreenUserName: UILabel!
    @IBOutlet weak var socialMediaName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
