//
//  ACAppUtilities.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
// MARK: - Short Terms
let kAppColorLight = UIColor.whiteColor()
let kAppColorDark = UIColor.blackColor()
let KAppBorderColor = RGBA(230, g: 230, b: 230, a: 1)
let KAppPlaceholderColor = RGBA(255, g: 255, b: 255, a: 1)
let KAppTintColor = RGBA(255, g: 220, b: 65, a: 1)
//let KAppLightFont = UIFont(name:"VarelaRound", size: NSUserDefaults.standardUserDefaults().valueForKey("size") as! CGFloat)!
//let KAppMediumFont = UIFont(name:"VarelaRound", size: NSUserDefaults.standardUserDefaults().valueForKey("size") as! CGFloat)!
let KAppRegularFont = UIFont(name:"VarelaRound", size: NSUserDefaults.standardUserDefaults().valueForKey("size") as! CGFloat)!
//let KAppSemiBoldFont = UIFont(name:"VarelaRound", size: NSUserDefaults.standardUserDefaults().valueForKey("size") as! CGFloat)!
let  kClientId : String = "1007506303482-r5atf958h2ps72bj1t33a1oflo76k63j.apps.googleusercontent.com"


let showLog = true

let kAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let Window_Width = UIScreen.mainScreen().bounds.size.width
let Window_Height = UIScreen.mainScreen().bounds.size.height

// custom log
func logInfo(message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
    if (showLog) {
        print("\(function): \(line): \(message)")
    }
}

// MARK: - Helper functions
func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func getRoundRect(obj : UIButton){
    obj.layer.cornerRadius = 5.0
    obj.layer.borderColor = UIColor.clearColor().CGColor
    obj.layer.borderWidth = 2.0
    obj.clipsToBounds = true
}

func getRoundImage(obj : UIImageView){
//    obj.layer.cornerRadius = 5.0
//    obj.layer.borderColor = KAppBorderColor.CGColor
//    obj.layer.borderWidth = 2.0
//    obj.clipsToBounds = true
    obj.layer.borderWidth = 1
    obj.layer.borderColor = KAppBorderColor.CGColor
    obj.layer.cornerRadius = obj.frame.height/2
    obj.clipsToBounds = true
}

func getRoundButton(obj : UIButton){
    obj.layer.borderWidth = 1
    obj.layer.borderColor = KAppBorderColor.CGColor
    obj.layer.cornerRadius = obj.frame.height/2
    obj.clipsToBounds = true
}

func getViewWithTag(tag:NSInteger, view:UIView) -> UIView {
    return view.viewWithTag(tag)!
}

class ACAppUtilities: NSObject {
    
    class func leftBarButton(imageName : NSString, controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setImage(UIImage(named: imageName as String), forState: UIControlState.Normal)
        button.addTarget(controller, action:#selector(leftBarButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
    }
    
    class func rightBarButton(buttonTitle : String, controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 40, 25)
        getRoundRect(button)
        button.layer.borderColor = UIColor.grayColor().CGColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = UIFont(name:"VarelaRound", size:12)
        button.setTitle(buttonTitle, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.addTarget(controller, action:#selector(rightBarButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return rightBarButtonItem
    }
    
    class func leftBarButtonArray(imageName : NSArray,controller : UIViewController) -> NSArray {
        let tempArray = imageName
        let barButtonArray = NSMutableArray()
        
        tempArray.enumerateObjectsUsingBlock { (image, index, stop) in
            let img = image as! NSString
            var selImg = NSString()
            selImg = (img as String) + "_s"
            let button:UIButton = UIButton.init(type: UIButtonType.Custom)
            button.frame = CGRectMake(0, 0, 30, 30)
            button.tag = index+200
            button.setImage(UIImage(named: img as String), forState: UIControlState.Normal)
            button.setImage(UIImage(named: selImg as String), forState: UIControlState.Highlighted)
            button.setImage(UIImage(named: selImg as String), forState: UIControlState.Selected)
            button.addTarget(controller, action: #selector(leftBarButtonsAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
            barButtonArray.addObject(leftBarButtonItem)
        }
        return barButtonArray
    }
    
    class func rightBarButtonArray(imageName : NSArray,controller : UIViewController) -> NSArray {
        let tempArray = imageName
        let rightBarButtonArray = NSMutableArray()
        
        tempArray.enumerateObjectsUsingBlock { (image, index, stop) in
            let img = image as! NSString
            var selImg = NSString()
            selImg = (img as String) + "_s"
            let rightButton:UIButton = UIButton.init(type: UIButtonType.Custom)
            rightButton.frame = CGRectMake(0, 0, 30, 30)
            rightButton.tag = index+100
            rightButton.setImage(UIImage(named: img as String), forState: UIControlState.Normal)
            rightButton.setImage(UIImage(named: selImg as String), forState: UIControlState.Highlighted)
            rightButton.setImage(UIImage(named: selImg as String), forState: UIControlState.Selected)
            rightButton.addTarget(controller, action: #selector(rightBarButtonsAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            let rightBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: rightButton)
            rightBarButtonArray.addObject(rightBarButtonItem)
        }
        return rightBarButtonArray
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(sender : UIButton) {
    }
    
    @objc func rightBarButtonAction(sender : UIButton) {
    }
    
    @objc func leftBarButtonsAction(button : UIButton) {
        
    }
    
    @objc func rightBarButtonsAction(button : UIButton) {
    }
}
