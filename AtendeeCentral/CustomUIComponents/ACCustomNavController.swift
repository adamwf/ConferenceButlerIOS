//
//  ACCustomNavController.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 03/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACCustomNavController: UINavigationController {
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit(CGFloat((NSUserDefaults.standardUserDefaults().valueForKey("size")?.doubleValue)!))
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont(name:"VarelaRound", size: 13)!]
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        NSNotificationCenter.defaultCenter().addObserverForName(
            "size",
            object: nil, queue: nil,
            usingBlock:{
                [weak self] note in
                self?.methodOFReceivedNotication(note)
            })
    }
    
    // MARK: Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Helper Methods
    func customInit(sizeValue : CGFloat) {
        UINavigationBar.appearance().barTintColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "navBg"), forBarMetrics: UIBarMetrics.Default)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name:"VarelaRound", size: 14)!]
    }
    
    // MARK: Notification Observer Method
    func methodOFReceivedNotication(note : NSNotification) {
        let userInfo : [String:String!] = note.userInfo as! [String:String!]
        let sizeVal: CGFloat = CGFloat((userInfo["size"]! as NSString).doubleValue)
        self.customInit(sizeVal)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver("size")
    }


}
