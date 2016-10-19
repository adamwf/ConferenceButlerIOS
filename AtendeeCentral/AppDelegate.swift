
//
//  AppDelegate.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: ACCustomNavController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print(NSUserDefaults.standardUserDefaults().valueForKey("size"))
        self.setUpDefaults()
        Fabric.with([Twitter.self])
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    if (NSString(format:"%@",url) .hasPrefix("fb")) {
    return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    else {
    return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    }

    //Mark: Helper Methods
    func setUpDefaults(){
        if NSUserDefaults.standardUserDefaults().valueForKey("size") != nil {
            NSUserDefaults.standardUserDefaults().setValue(NSUserDefaults.standardUserDefaults().valueForKey("size"), forKey: "size")
        } else {
            NSUserDefaults.standardUserDefaults().setValue(16, forKey: "size")
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyBoard.instantiateViewControllerWithIdentifier("ACLoginVCID") as! ACLoginVC
        navController = ACCustomNavController(rootViewController: homeVC)
        //        navController.viewControllers = [homeVC]
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        let settings : UIUserNotificationSettings =  UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()

    }

    // MARK: - Network Reachability
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability.reachabilityForInternetConnection()
            let networkStatus: Int = reachability.currentReachabilityStatus.hashValue
            
            return (networkStatus != 0)
        }
        catch {
            // Handle error however you please
            return false
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        NSUserDefaults.standardUserDefaults().setValue(deviceTokenString, forKey: "device_token")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        NSUserDefaults.standardUserDefaults().setValue("it6r56dv5jjr654i", forKey: "device_token")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        let userDict = userInfo["aps"] as! Dictionary <String, AnyObject>
        
        //        if userInfo["Notification_type"] as! String == "offer_sent"
        //        {
        //
        //        } else {
        AlertController.alert("", message: (userDict["alert"] as? String)!, buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
            if position == 0 {
                // do nothing
            } else if position == 1 {
            }
        })
        //        }
    }

}

