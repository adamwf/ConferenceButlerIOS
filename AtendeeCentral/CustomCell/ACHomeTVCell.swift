//
//  ACHomeTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 03/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACHomeTVCell: UITableViewCell {

    @IBOutlet var feedImageView: UIImageView!
    @IBOutlet var feedPlayButton: UIButton!
    @IBOutlet weak var feedDescriptionLabel: UILabel!
    @IBOutlet weak var heightConstraintImageView: NSLayoutConstraint!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet weak var heightConstraintImgView: NSLayoutConstraint!
    
    @IBOutlet weak var staticPostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        getRoundImage(self.feedImageView)

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
   

}
