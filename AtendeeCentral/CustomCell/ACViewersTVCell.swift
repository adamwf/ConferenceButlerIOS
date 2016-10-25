//
//  ACViewersTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACViewersTVCell: UITableViewCell {

    @IBOutlet var viewersImgView: UIImageView!
    @IBOutlet weak var viewersUserName: UILabel!
    @IBOutlet var selectionButton: UIButton!
    @IBOutlet var messageButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        getRoundImage(viewersImgView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
