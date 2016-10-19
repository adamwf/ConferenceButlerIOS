//
//  ACVerifiedCodeAlert.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

@objc protocol customAlertDelegate{
    optional func removeAlert()
}

class ACVerifiedCodeAlert: UIView {
var delegate: customAlertDelegate?
    @IBOutlet var showAlertlabel: UILabel!
    @IBOutlet var bgView: UIView!
    @IBOutlet var alertLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.layer.cornerRadius = 3.0
        self.bgView.clipsToBounds = true
    }
    
    //MARK:- UIButton Action Methods
    @IBAction func okButtonAction(sender: UIButton) {
                 delegate?.removeAlert!()
        }
   }

