
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
import CoreLocation
import AddressBookUI
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var currentAddress: String?
    var window: UIWindow?
    var navController: ACCustomNavController?
    var locationManager: CLLocationManager!
    var location = CLLocation()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print(NSUserDefaults.standardUserDefaults().valueForKey("size"))
        NSUserDefaults.standardUserDefaults().setValue("811e90a2cb4c2de225120e1c6192fc12f5662876", forKey: "device_token")
        let settings : UIUserNotificationSettings =  UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        self.setUpDefaults()
        self.initLocationManager()
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
        NSUserDefaults.standardUserDefaults().setValue("811e90a2cb4c2de225120e1c6192fc12f5662876", forKey: "device_token")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject])
    {
        let userDict = userInfo["aps"] as! Dictionary <String, AnyObject>
        AlertController.alert("", message: userDict["alert"] as! String)
//        let userDict = userInfo["aps"] as! Dictionary <String, AnyObject>
//        
//        if userInfo["notification_type"] as! String == "Community Center" {
//            
//            alert("", message:userDict["alert"] as! String, buttons: ["OK"], controller: kAppDelegate.navigat) { (alertAction, position) in
//                if position == 0 {
//                    if userInfo["status"] as! String == "Deactivated" {
//                        if NSUserDefaults.standardUserDefaults().valueForKey("OCCUserID") != nil  {
//                            let changeHomeCCVC = ChangeHCCVC(nibName: "ChangeHCCVC", bundle: nil)
//                            changeHomeCCVC.isFromNotification = true
//                            changeHomeCCVC.isFromLogin = false
//                            kAppDelegate.navigat.presentViewController(changeHomeCCVC, animated: true, completion: nil)
//                        }
//                    }
//                }
//            }
//        } else {
//            alert("Sorry!", message:"Your access has been revoked by admin.", buttons: ["OK"], controller: kAppDelegate.navigat) { (alertAction, position) in
//                if position == 0 {
//                    if NSUserDefaults.standardUserDefaults().valueForKey("OCCUserID") != nil  {
//                        delay(0.1, closure: {
//                            self.forceLogOut()
//                        })
//                        
//                    }
//                }
//            }
//        }
    }
    
    //MARK: Location Finder Methods
    func locationUpdate(location: CLLocation?) -> Void {
        if let location = location {
            logInfo("location   >>>   \(location)")
        }
    }
    
    func initLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK: CLLocation Manager Delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        location = locationArray.lastObject as! CLLocation
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            self.getAddressFromLocation {
                (address:String?) in
                logInfo("\(address)")
                self.currentAddress = address
            }
        })

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        //print("locations error = \(error.localizedDescription)")
    }
    
    func getAddressFromLocation(completion:(String?) -> Void) {
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                
                if let addressDic = pm.addressDictionary {
                    if let lines = addressDic["FormattedAddressLines"] as? [String] {
                        completion(lines.joinWithSeparator(", "))
                    } else {
                        // fallback
                        if #available(iOS 9.0, *) {
                            completion (CNPostalAddressFormatter.stringFromPostalAddress(self.postalAddressFromAddressDictionary(pm.addressDictionary!), style: .MailingAddress))
                        } else {
                            completion(ABCreateStringWithAddressDictionary(pm.addressDictionary!, false))
                        }
                    }
                } else {
                    completion ("\(self.location.coordinate.latitude), \(self.location.coordinate.longitude)")
                }
                
            } else {
                print("Problem with the data received from geocoder")
                return
            }
        })
    }
    
    @available(iOS 9.0, *)
    func postalAddressFromAddressDictionary(addressdictionary: Dictionary<NSObject,AnyObject>) -> CNMutablePostalAddress {
        
        let address = CNMutablePostalAddress()
        
        address.street = addressdictionary["Street"] as? String ?? ""
        address.state = addressdictionary["State"] as? String ?? ""
        address.city = addressdictionary["City"] as? String ?? ""
        address.country = addressdictionary["Country"] as? String ?? ""
        address.postalCode = addressdictionary["ZIP"] as? String ?? ""
        
        return address
    }
    


}

