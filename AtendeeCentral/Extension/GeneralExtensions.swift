//
//  GeneralExtensions.swift
//  Template
//
//  Created by Raj Kumar Sharma on 04/04/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

import UIKit

// MARK:- Array Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

// MARK:- Dictionary Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Dictionary {
    mutating func unionInPlace(
        dictionary: Dictionary<Key, Value>) {
            for (key, value) in dictionary {
                self[key] = value
            }
    }
    
    mutating func unionInPlace<S: SequenceType where S.Generator.Element == (Key,Value)>(sequence: S) {
        for (key, value) in sequence {
            self[key] = value
        }
    }
    
    func validatedValue(key: Key, expected: AnyObject) -> AnyObject {
        
        // checking if in case object is nil

        if let object = self[key] as? AnyObject{
            
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber && expected is String {
                
                //logInfo("case we are getting number from server but we want a string from it")
                
                return "\(object)"
            }
                
                // checking if object is of desired class
            else if (object.isKindOfClass(expected.classForCoder) == false) {
                //logInfo("case // checking if object is of desired class....not")
                
                return expected
            }
                
                // checking if in case object if of string type and we are getting nil inside quotes
            else if object is String {
                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                    //logInfo("null string")
                    return ""
                }
            }
            
            return object
        }
        else {

            if expected is String || expected as! String == "" {
             return ""
            }
            
            return expected
        }
    }
   
}

// MARK:- NSDictionary Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension NSDictionary {
    
    func objectForKeyNotNull(key:AnyObject, expected:AnyObject?) -> AnyObject {
        
        // checking if in case object is nil
        if let object = self.objectForKey(key) {
            
            // added helper to check if in case we are getting number from server but we want a string from it
            if object is NSNumber && expected is String {
                
                //logInfo("case we are getting number from server but we want a string from it")
                
                return "\(object)"
            }
                
                // checking if object is of desired class
            else if (object.isKindOfClass((expected?.classForCoder)!) == false) {
                
                //logInfo("case // checking if object is of desired class....not")
                
                return expected!
            }
                
                // checking if in case object if of string type and we are getting nil inside quotes
            else if object is String {
                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                    
                    //logInfo("null string")
                    
                    return ""
                }
            }
            return object
            
        } else {
            
            if expected is String || expected as! String == "" {
                return ""
            }
            
            return expected!
        }
    }
    
    func objectForKeyNotNull(key:AnyObject) -> AnyObject {
        
        let object = self.objectForKey(key)
        
        if object is NSNull {
            return ""
        }
        
        if (object == nil) {
            return ""
        }
        
        if object is NSString {
            if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
                return ""
            }
        }
        return object!
    }
    
    func objectForKeyNotNullExpectedObj(key:AnyObject, expectedObj:AnyObject) -> AnyObject {
        
        let object = self.objectForKey(key)
        
        if object is NSNull {
            return expectedObj
        }
        
        if (object == nil) {
            return expectedObj
        }
        
        if ((object?.isKindOfClass(expectedObj.classForCoder)) == nil) {
            return expectedObj
        }
        
        return object!
    }
    
    func toNSData() -> NSData {
        return try! NSJSONSerialization.dataWithJSONObject(self, options: [])
    }
    
    func toJsonString() -> String {
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(self, options: NSJSONWritingOptions.PrettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        return jsonString
    }
}

// MARK:- UIView Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension UIView {
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return self.layer.cornerRadius
//        }
//        set {
//            
//            self.layer.cornerRadius = newValue
//            self.clipsToBounds = true
//        }
//    }
    
    func shadow(color:UIColor) {
        self.layer.shadowColor = color.CGColor;
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSizeMake(1.5, 1.5)
    }
    
    func setNormalRoundedShadow(color:UIColor) {
        self.layer.shadowColor = color.CGColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSizeMake(0.3, 0.3)
    }
    
    func setBorder(color:UIColor, borderWidth:CGFloat) {
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
    }
    
    func vibrate() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.02
        animation.repeatCount = 2
        animation.speed = 0.5
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(self.center.x - 2.0, self.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(self.center.x + 2.0, self.center.y))
        self.layer.addAnimation(animation, forKey: "position")
    }
    
    func shake() {
        self.transform = CGAffineTransformMakeTranslation(5, 5)
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func setTapperTriangleShape(color:UIColor) {
        // Build a triangular path
        let path = UIBezierPath()
        
        path.moveToPoint(CGPoint(x: 0,y: 0))
        path.addLineToPoint(CGPoint(x: 40,y: 40))
        path.addLineToPoint(CGPoint(x: 0,y: 100))
        path.addLineToPoint(CGPoint(x: 0,y: 0))
        
        // Create a CAShapeLayer with this triangular path
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.CGPath
        
        // Mask the view's layer with this shape
        self.layer.mask = mask
        
        self.backgroundColor = color
        
        // Transform the view for tapper shape
        self.transform = CGAffineTransformMakeRotation(CGFloat(270) * CGFloat(M_PI_2) / 180.0)
    }
}

// MARK:- UISlider Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension UISlider {
    @IBInspectable var thumbImage: UIImage {
        get {
            return self.thumbImageForState(.Normal)!
        }
        set {
            self.setThumbImage(thumbImage, forState: .Normal)
        }
    }
}

// MARK:- NSURL Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension NSURL {
    
    func isValid() -> Bool {
        if UIApplication.sharedApplication().canOpenURL(self) == true {
            return true
        } else {
            return false
        }
    }
}

// MARK:- NSDate Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension NSDate {
    
    func timestamp() -> String {
        return "\(self.timeIntervalSince1970)"
    }
    
    func dateString() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        return dateFormatter.stringFromDate(self)
    }
    func dateStringFromDate(format:String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.stringFromDate(self)
    }
    
    func timeStringFromDate() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.stringFromDate(self)
    }
    
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

// MARK: - Timer Class

/// A simple timer class based on the `NSTimer` class.
/// Since this is `NSTimer` based, this also fires if the app in on the background.
final class Timer {
    
    // MARK: Private Stuff
    
    private let callback: Callback
    private var timer: NSTimer?
    
    private init(seconds: NSTimeInterval, repeats: Bool, _ callback: Callback) {
        precondition(seconds >= 0)
        self.callback = callback
        self.timer = NSTimer.scheduledTimerWithTimeInterval(
            NSTimeInterval(seconds),
            target: self, selector: #selector(self.timerDidFire),
            userInfo: nil, repeats: repeats)
    }
    
    deinit {
        dispose()
    }
    
    @objc private func timerDidFire() {
        assert(NSThread.isMainThread())
        assert(timer != nil)
        callback()
    }
    
    // MARK: Timer API
    
    typealias Callback = () -> Void
    
    /// Schedules timer and returns it.
    /// If `repeats` is true a periodic timer is created.
    class func scheduledTimerWithTimeInterval(interval: NSTimeInterval,
                                              repeats: Bool = false,
                                              callback: Callback) -> Timer {
        return Timer(seconds: interval, repeats: repeats, callback)
    }
    
    /// Cancels timer.
    func dispose() {
        timer?.invalidate()
        timer = nil
    }
}

// Usage

/*
 let date1 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
 let date2 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 8, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
 
 let years = date2.yearsFrom(date1)     // 0
 let months = date2.monthsFrom(date1)   // 9
 let weeks = date2.weeksFrom(date1)     // 39
 let days = date2.daysFrom(date1)       // 273
 let hours = date2.hoursFrom(date1)     // 6,553
 let minutes = date2.minutesFrom(date1) // 393,180
 let seconds = date2.secondsFrom(date1) // 23,590,800
 
 let timeOffset = date2.offsetFrom(date1) // "9M"
 
 let date3 = NSCalendar.currentCalendar().dateWithEra(1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
 let date4 = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
 
 let timeOffset2 = date4.offsetFrom(date3) // "1y"
 
 let timeOffset3 = NSDate().offsetFrom(date3) // "54m"
 */

// MARK:- UIViewController Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
private var progressHUDTimer: Timer?

extension UIViewController {
    
    // TODO: Review both methods below: `showProgressHUD` and `hideProgressHUD`.
    // There might be a better API design.
    
    /// Creates a new HUD, adds it to this view controller view and shows it.
    /// The counterpart to this method is `hideProgressHUD`.
    func showProgressHUD(animated animated: Bool = true, whiteColor: Bool = false) {
        hideProgressHUD(animated: false)
        /// Grace period is the time (in seconds) that the background operation
        /// may be run without showing the HUD. If the task finishes before the
        /// grace time runs out, the HUD will not be shown at all.
        ///
        /// This *was* supposed to be done by the `graceTime` property, but it
        /// doesn't seem to be working at all. So we rolled our own implementation.
        let graceTime = 0.100
        progressHUDTimer = Timer.scheduledTimerWithTimeInterval(graceTime) {
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: animated)
            hud.taskInProgress = true
            hud.graceTime = 0
            hud.square = true
            hud.minSize = CGSize(width: 50, height: 50)
            if whiteColor {
                hud.color = UIColor.whiteColor()
                hud.activityIndicatorColor = UIColor.grayColor()
            }
        }
    }
    
    /// Finds all the HUD subviews and hides them.
    func hideProgressHUD(animated animated: Bool = true) {
        progressHUDTimer?.dispose()
        progressHUDTimer = nil
        for hud in MBProgressHUD.allHUDsForView(self.view) as! [MBProgressHUD] {
            hud.taskInProgress = false
            hud.hide(true)
        }
    }

}

// MARK:- Int/Float/Double Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension Int {
    func format(f: String) -> String {
        return NSString(format: "%\(f)d", self) as String
    }
}

extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

extension Float {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

extension Character {
    func isEmoji() -> Bool {
        return Character(UnicodeScalar(0x1d000)) <= self && self <= Character(UnicodeScalar(0x1f77f))
            || Character(UnicodeScalar(0x2100)) <= self && self <= Character(UnicodeScalar(0x26ff))
    }
}

//extension String {
//    func stringByRemovingEmoji() -> String {
//        return String(filter(self, {c in !c.isEmoji()}))
//    }
//}

// MARK:- UIImageView Extensions >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

extension UIImageView {
    
    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Changing icon color according to theme <<<<<<<<<<<<<<<<<<<<<<<<*/
    func setColor(color:UIColor) {
        
        if let image = self.image {
            var s = image.size // CGSize
            s.height *= image.scale
            s.width *= image.scale
            
            UIGraphicsBeginImageContext(s)
            
            var contextRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: s)
            
            // Retrieve source image and begin image context
            let itemImageSize = s //CGSize
            
            let xVal = (contextRect.size.width - itemImageSize.width)/2
            let yVal = (contextRect.size.height - itemImageSize.height)
            
            //let itemImagePosition = CGPoint(x: ceilf(xFloatVal), y: ceilf(yVal)) //CGPoint
            
            let itemImagePosition = CGPoint(x: xVal, y: yVal) //CGPoint
            
            UIGraphicsBeginImageContext(contextRect.size)
            
            let c = UIGraphicsGetCurrentContext() //CGContextRef
            
            // Setup shadow
            // Setup transparency layer and clip to mask
            CGContextBeginTransparencyLayer(c, nil)
            CGContextScaleCTM(c, 1.0, -1.0)
            
            //CGContextRotateCTM(c, M_1_PI)
            
            CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), image.CGImage)
            
            // Fill and end the transparency layer
            let colorSpace = CGColorGetColorSpace(color.CGColor) //CGColorSpaceRef
            let model = CGColorSpaceGetModel(colorSpace) //CGColorSpaceModel
            
            let colors = CGColorGetComponents(color.CGColor)
            
            if (model == .Monochrome) {
                CGContextSetRGBFillColor(c, colors[0], colors[0], colors[0], colors[1])
            } else {
                CGContextSetRGBFillColor(c, colors[0], colors[1], colors[2], colors[3])
            }
            
            contextRect.size.height = -contextRect.size.height
            contextRect.size.height -= 15
            CGContextFillRect(c, contextRect)
            CGContextEndTransparencyLayer(c)
            
            let img = UIGraphicsGetImageFromCurrentImageContext() //UIImage
            
            let img2 = UIImage(CGImage: img.CGImage!, scale: image.scale, orientation: image.imageOrientation)
            
            UIGraphicsEndImageContext()
            
            self.image = img2
            
        } else {
            print("Unable to chage color of image. Image not found")
        }
    }
}
