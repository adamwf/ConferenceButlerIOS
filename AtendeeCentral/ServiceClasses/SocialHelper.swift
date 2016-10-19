//
//  SocialHelper.swift
//  WorldFax
//
//  Created by Probir Chakraborty on 29/07/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import Foundation
import UIKit

class SocialHelper: NSObject {
    
    typealias LoginCompletionBlock = (Dictionary<String, AnyObject>?, NSError?) -> Void
    
    class var facebookManager: SocialHelper {
        struct Static {
            static let instance: SocialHelper = SocialHelper()
        }
        return Static.instance
    }
    
    //MARK:- Public functions
    
    func getFacebookInfoWithCompletionHandler(fromViewController:AnyObject, onCompletion: LoginCompletionBlock) -> Void {
        
        //        if (kAppDelegate.isReachable() == false) {
        //
        //            AlertViewController.alert("Connection Error!", message: "Internet connection appears to be offline. Please check your internet connection.")
        //
        //            return
        //        }
        
        self.getFBInfoWithCompletionHandler(fromViewController) { (dataDictionary:Dictionary<String, AnyObject>?, error: NSError?) -> Void in
            onCompletion(dataDictionary, error)
        }
    }
    
    func logoutFromFacebook() {
        FBSDKLoginManager().logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        FBSDKProfile.setCurrentProfile(nil)
    }
    
    //MARK:- Private functions
    
    private func getFBInfoWithCompletionHandler(fromViewController:AnyObject, onCompletion: LoginCompletionBlock) -> Void {
        
        let permissionDictionary = [
            "fields" : "id,name,first_name,last_name,gender,email,picture.type(large)",
            //"locale" : "en_US"
        ]
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            
            let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: permissionDictionary)
            pictureRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
                
                if error == nil {
                    onCompletion(result as? Dictionary<String, AnyObject>, nil)
                } else {
                    onCompletion(nil, error)
                }
            })
        } else {
            
            FBSDKLoginManager().logInWithReadPermissions(["email", "public_profile"], fromViewController: fromViewController as! UIViewController, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if error != nil {
                    FBSDKLoginManager().logOut()
                    
                    let errorDetails = [NSLocalizedDescriptionKey : "Processing Error. Please try again!"]
                    let customError = NSError(domain: "Error!", code: error.code, userInfo: errorDetails)
                    
                    onCompletion(nil, customError)
                    
                } else if result.isCancelled {
                    FBSDKLoginManager().logOut()
                    let errorDetails = [NSLocalizedDescriptionKey : "Request cancelled!"]
                    let customError = NSError(domain: "Request cancelled!", code: 404, userInfo: errorDetails)
                    
                    onCompletion(nil, customError)

                } else {
                    let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: permissionDictionary)
                    pictureRequest.startWithCompletionHandler({
                        (connection, result, error: NSError!) -> Void in
                        
                        if error == nil {
                            onCompletion(result as? Dictionary<String, AnyObject>, nil)
                        } else {
                            onCompletion(nil, error)
                        }
                    })
                }
            })
        }
    }
    
}