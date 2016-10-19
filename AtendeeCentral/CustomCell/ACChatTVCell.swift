//
//  ACChatTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 08/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACChatTVCell: UITableViewCell {

    @IBOutlet weak var userPicImageView: UIImageView!
    
    @IBOutlet weak var chatDetailLabel: UILabel!
    
    @IBOutlet weak var chatDateLabel: UILabel!
    
    
    @IBOutlet weak var chatBgView: UIView!
    
    @IBOutlet weak var chatItemButton: UIButton!
    
    @IBOutlet weak var chatImageView: UIImageView!
    
    @IBOutlet weak var heightConstraintChatImgView: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraintChatLabel: NSLayoutConstraint!
    
    @IBOutlet weak var audioStatusProgressView: UIProgressView!
    
    @IBOutlet weak var audioTimerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customInit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func customInit() {
        chatBgView.layer.cornerRadius = 5.0
        chatBgView.clipsToBounds = true
        getRoundImage(userPicImageView)
    }

}
