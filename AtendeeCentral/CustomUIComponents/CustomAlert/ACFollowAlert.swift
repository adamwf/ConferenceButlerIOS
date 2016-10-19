//
//  ACFollowAlert.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACFollowAlert: UIView {

    @IBOutlet var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 3.0
        self.bgView.clipsToBounds = true
    }

    //MARK:- UIButton Action Methods
    @IBAction func acceptButtonAction(sender: UIButton) {
    }

    @IBAction func declineButtonAction(sender: UIButton) {
    }
}
