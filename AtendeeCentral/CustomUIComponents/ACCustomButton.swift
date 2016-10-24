//
//  ACCustomButton.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACCustomButton: UIButton {

    // MARK: OverRide Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel?.font = UIFont(name:"VarelaRound", size:16)// KAppRegularFont
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
        self.exclusiveTouch = true
//        NSNotificationCenter.defaultCenter().addObserverForName(
//            "size",
//            object: nil, queue: nil,
//            usingBlock:{
//                [weak self] note in
//                self?.methodOFReceivedNotication(note)
//            })
    }
    
    // MARK: Notification Observer Method 
    func methodOFReceivedNotication(note : NSNotification) {
        let userInfo : [String:String!] = note.userInfo as! [String:String!]
        let sizeVal: CGFloat = CGFloat((userInfo["size"]! as NSString).doubleValue)
        
        self.titleLabel?.font = UIFont(name:"VarelaRound", size: sizeVal)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
