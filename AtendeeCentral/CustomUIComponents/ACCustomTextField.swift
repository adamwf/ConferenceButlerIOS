//
//  ACCustomTextField.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACCustomTextField: UITextField {
    
    // MARK: OverRide Methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.keyboardType = UIKeyboardType.ASCIICapable
        self.font = KAppRegularFont
        self.autocorrectionType = UITextAutocorrectionType.No
        //        self.autocapitalizationType = UITextAutocapitalizationType.None
        let padView =  UIView(frame: CGRectMake(0, 0, 10, self.frame.size.height))
        self.leftView = padView;
        self.leftViewMode = UITextFieldViewMode.Always
        self.backgroundColor = UIColor.clearColor()
        self.tintColor = KAppTintColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName : KAppPlaceholderColor])
        self.textColor = UIColor.darkTextColor()
        NSNotificationCenter.defaultCenter().addObserverForName(
            "size",
            object: nil, queue: nil,
            usingBlock:{
                [weak self] note in
                self?.methodOFReceivedNotication(note)
            })
        
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, 10, 0)
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, 10, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectOffset(bounds, 10, 0)
    }
    
    override func drawPlaceholderInRect(rect: CGRect) {
        super.drawPlaceholderInRect(rect)
        //        self.keyboardType = UIKeyboardType.ASCIICapable
        self.autocorrectionType = UITextAutocorrectionType.No
        //        self.autocapitalizationType = UITextAutocapitalizationType.None
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName : KAppPlaceholderColor ,NSFontAttributeName : KAppRegularFont])
        self.font = KAppRegularFont
        self.textColor = UIColor.darkTextColor()
    }

    // MARK: Notification Observer Method 
    func methodOFReceivedNotication(note : NSNotification) {
        let userInfo : [String:String!] = note.userInfo as! [String:String!]
        let sizeVal: CGFloat = CGFloat((userInfo["size"]! as NSString).doubleValue)
        
        self.font = UIFont(name:"VarelaRound", size: sizeVal)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver("size")
    }
}
