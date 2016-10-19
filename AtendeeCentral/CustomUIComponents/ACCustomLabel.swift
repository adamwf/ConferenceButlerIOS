//
//  ACCustomLabel.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 03/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACCustomLabel: UILabel {

    // MARK: OverRide Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = KAppRegularFont
        NSNotificationCenter.defaultCenter().addObserverForName(
            "size",
            object: nil, queue: nil,
            usingBlock:{
                [weak self] note in
                self?.methodOFReceivedNotication(note)
            })
    }
    
    func methodOFReceivedNotication(note : NSNotification) {
        let userInfo : [String:String!] = note.userInfo as! [String:String!]
        let sizeVal: CGFloat = CGFloat((userInfo["size"]! as NSString).doubleValue)
        
        self.font = UIFont(name:"VarelaRound", size: sizeVal)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver("size")
    }

}
