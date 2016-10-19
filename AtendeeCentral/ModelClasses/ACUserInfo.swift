//
//  ACUserInfo.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 03/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACUserInfo: NSObject {

    var userID : String = ""
    var userName : String = ""
    var socialUserName : String = ""
    var userEmail : String = ""
    var userFName : String = ""
    var userLName : String = ""
    var userPassword : String = ""
    var userCnfrmPassword : String = ""
    var userImage : String = ""
    var userOTP : String = ""
    var userStatus : Bool = false
    var userDetail : String = ""
    var userPhone : String = ""
    var userAddress : String = ""
    var userHobbies : String = ""
    var userInformation : String = ""
    var isEnableRegisteredUser : Bool = false
    var isEnableSearchEngines : Bool = false
    var isEnableFollowers : Bool = false
    var message : String = ""
    var time : String = ""
    var isGABUser : Bool = false
    var isFriend : Bool =  false
    
    var userCity : String = ""
    var userState : String = ""
    var userCountry : String = ""
    var relationStatus : String = ""
    var userChildren : String = ""
    
    var userMName : String = ""
    var userRole : String = ""
    var userInfoHandlers : String = ""
    var isUserOnline : Bool = false
    var infoHandels : String = ""
    var date : String = ""
    var otherInfo : String = ""
    var qrImage : String = ""
    var userDescription : String = ""
    var isName : Bool = false
    var isEmail : Bool = false
    var isPhone : Bool = false
    var isOtherInfo : Bool = false
    var isHobbies : Bool = false
    var isRelationStatus : Bool = false
    var isChildren : Bool = false
    var isImage : Bool = false
    var isFacebook : Bool = false
    var isGoogle : Bool = false
    var islinkedIn : Bool = false
    var isInstagram : Bool = false
    var isTwitter : Bool = false
    var isAddress : Bool = false
    var socialUserNameArray : NSMutableArray = []
    
    class func getUserInfo(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict .valueForKey("userArray")
        
        tempArray!.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let userInfo = ACUserInfo()
            let tempDict = dict as! Dictionary<String, AnyObject>
            userInfo.userID = tempDict["userID"] as! String! ?? ""
            userInfo.userName = tempDict["userName"] as! String! ?? ""
            userInfo.userImage = tempDict["userImage"] as! String! ?? ""
            userInfo.userEmail = tempDict["userEmail"] as! String! ?? ""
            userInfo.userStatus = tempDict["userStatus"] as? Bool ?? false
            userInfo.userDetail = tempDict["userDetail"] as! String! ?? ""
            dummyArray.addObject(userInfo)
        }
        return dummyArray
    }

    class func getChatInfo (dict : NSMutableDictionary)-> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict.valueForKey("chatArray")
        
        tempArray!.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let chatInfo = ACUserInfo()
            let tempDict = dict as! Dictionary<String, AnyObject>
            chatInfo.time = tempDict["time"] as! String! ?? ""
            chatInfo.userImage = tempDict["userImage"] as! String! ?? ""
            chatInfo.message = tempDict["message"] as! String! ?? ""
            dummyArray.addObject(chatInfo)
        }
        return dummyArray
}
    
    class func getUserLoginInfo(dict : AnyObject) -> ACUserInfo {
        
        let userInfo = ACUserInfo()
        
        let tempDict = dict as! NSDictionary
        
        userInfo.userID = tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:"") as! String
        userInfo.userName = (tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String)
        userInfo.userFName = (tempDict.objectForKeyNotNullExpectedObj("first_name", expectedObj:"") as! String)
        userInfo.userLName = (tempDict.objectForKeyNotNullExpectedObj("last_name", expectedObj:"") as! String)
        userInfo.userImage = tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String
        userInfo.userEmail = tempDict.objectForKeyNotNullExpectedObj("email", expectedObj:"") as! String
        userInfo.userRole = tempDict.objectForKeyNotNullExpectedObj("role", expectedObj:"") as! String
        
        return userInfo
    }

    class func getUserEditProfileInfo(dict : AnyObject) -> ACUserInfo {
        
        let userInfo = ACUserInfo()
        
        let tempDict = dict as! NSDictionary
        
        userInfo.userID = tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:"") as! String
        userInfo.userName = (tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String)
        userInfo.userFName = (tempDict.objectForKeyNotNullExpectedObj("first_name", expectedObj:"") as! String)
        userInfo.userLName = (tempDict.objectForKeyNotNullExpectedObj("last_name", expectedObj:"") as! String)
        userInfo.userImage = tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String
        userInfo.userEmail = tempDict.objectForKeyNotNullExpectedObj("email", expectedObj:"") as! String
        userInfo.userRole = tempDict.objectForKeyNotNullExpectedObj("role", expectedObj:"") as! String
//        userInfo.isEnableRegisteredUser =  (tempDict.objectForKeyNotNullExpectedObj("profile_view_to_requested_users", expectedObj:0) as! Bool)
//        userInfo.isEnableSearchEngines =  (tempDict.objectForKeyNotNullExpectedObj("profile_view_to_requested_users", expectedObj:0) as! Bool)

        return userInfo
    }

    class func getTrendingList(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict .valueForKey("trending_profiles")
        
        tempArray!.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let trendingList = ACUserInfo()
            let tempDict = dict as! NSDictionary
            trendingList.userID = String(format: "%d", tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
            trendingList.userName = tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String
            trendingList.userImage = (tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:NSDictionary()) as! NSDictionary).objectForKeyNotNull("url", expected: "") as! String
            
            dummyArray.addObject(trendingList)
        }
        return dummyArray
    }

    class func getRequestList(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict .valueForKey("pending_invitations")
        
        tempArray!.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let requestList = ACUserInfo()
            let tempDict = dict as! NSDictionary
            requestList.userName = tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String
            requestList.userImage =  tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String

            //            requestList.infoHandels = tempDict["image"] as! String! ?? ""
            //            requestList.description = tempDict["image"] as! String! ?? ""
            dummyArray.addObject(requestList)
        }
        return dummyArray
    }
    
    class func getMessageList(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict .valueForKey("reviews")
        
        tempArray!.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let messageList = ACUserInfo()
            let tempDict = dict as! NSDictionary
            messageList.userName = tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String
            messageList.userImage =  tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String
            messageList.message = tempDict.objectForKeyNotNull("message", expected: "") as! String
            messageList.date = tempDict.objectForKeyNotNull("updated_at", expected: "") as! String
            dummyArray.addObject(messageList)
        }
        return dummyArray
    }

    class func getContactInfo(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict.objectForKeyNotNullExpectedObj("contact_list", expectedObj:NSArray()) as! NSArray
        
        tempArray.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let contactInfo = ACUserInfo()
            let tempDict = dict as! NSDictionary
            contactInfo.userID = String(format: "%d", tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
            contactInfo.userName = tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String
            contactInfo.userImage = tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String
            contactInfo.userEmail = tempDict.objectForKeyNotNullExpectedObj("email", expectedObj:"") as! String
            contactInfo.userFName = tempDict.objectForKeyNotNullExpectedObj("first_name", expectedObj:"") as! String
            contactInfo.userLName = tempDict.objectForKeyNotNullExpectedObj("last_name", expectedObj:"") as! String
            contactInfo.userInfoHandlers = (tempDict.objectForKeyNotNullExpectedObj("social_Logins", expectedObj:NSArray()) as! NSArray).componentsJoinedByString(",")
            contactInfo.isUserOnline = tempDict.objectForKeyNotNullExpectedObj("availability", expectedObj:0) as! Bool
            dummyArray.addObject(contactInfo)
        }
        return dummyArray
    }

    class func getProfileInfo(dict : AnyObject) -> ACUserInfo {
        let userInfo = ACUserInfo()
        let tempDict = dict as! NSDictionary
        userInfo.userID = String(format: "%d",tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
        userInfo.userName = (tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String)
        userInfo.userFName = (tempDict.objectForKeyNotNullExpectedObj("first_name", expectedObj:"") as! String)
        userInfo.userLName = (tempDict.objectForKeyNotNullExpectedObj("last_name", expectedObj:"") as! String)
        userInfo.userImage = tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String
        userInfo.userEmail = tempDict.objectForKeyNotNullExpectedObj("email", expectedObj:"") as! String
        userInfo.userRole = tempDict.objectForKeyNotNullExpectedObj("role", expectedObj:"") as! String
        userInfo.userHobbies = tempDict.objectForKeyNotNullExpectedObj("hobbies", expectedObj:"") as! String
        userInfo.relationStatus = tempDict.objectForKeyNotNullExpectedObj("relation_status", expectedObj:"") as! String
        userInfo.userChildren = tempDict.objectForKeyNotNullExpectedObj("children", expectedObj:"") as! String
        userInfo.otherInfo = tempDict.objectForKeyNotNullExpectedObj("other_info", expectedObj:"") as! String
        userInfo.userPhone = tempDict.objectForKeyNotNullExpectedObj("phone", expectedObj:"") as! String
        userInfo.userAddress = tempDict.objectForKeyNotNullExpectedObj("address", expectedObj:"") as! String
        for case let item as NSDictionary in (tempDict.objectForKeyNotNullExpectedObj("social_login", expectedObj:NSArray()) as! NSArray) {
            let socialObj = ACUserInfo()
            socialObj.socialUserName = item.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String
            userInfo.socialUserNameArray.addObject(socialObj.socialUserName)
        }
        userInfo.userInfoHandlers = (userInfo.socialUserNameArray.mutableCopy() as! NSArray).componentsJoinedByString(",")
        userInfo.qrImage = tempDict.objectForKeyNotNull("social_code", expected: "") as! String
        return userInfo
    }
    
    class func getViewersList(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict .valueForKey("profile_viewer")
        tempArray!.enumerateObjectsUsingBlock { (dict, index, stop) in
            let viewersList = ACUserInfo()
            let tempDict = dict as! NSDictionary
            viewersList.userID = String(format: "%d",tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
            viewersList.userName = tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String
            viewersList.userImage = tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String
            viewersList.date = tempDict.objectForKeyNotNullExpectedObj("updated_at", expectedObj:"") as! String
            viewersList.isFriend = tempDict.objectForKeyNotNull("is_friend", expected: 0) as! Bool
            dummyArray.addObject(viewersList)
        }
        return dummyArray
    }

    class func getGABDirectoryInfo(dict : AnyObject) -> ACUserInfo {
        
        let userInfo = ACUserInfo()
        
        let tempDict = dict as! NSDictionary
        
        userInfo.userID = String(format: "%d",tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
        userInfo.isName = (tempDict.objectForKeyNotNullExpectedObj("name", expectedObj:0) as! Bool)
        userInfo.userImage = tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String
        userInfo.isEmail = tempDict.objectForKeyNotNullExpectedObj("email", expectedObj:0) as! Bool
        userInfo.isHobbies = tempDict.objectForKeyNotNullExpectedObj("hobbies", expectedObj:0) as! Bool
        userInfo.isChildren = tempDict.objectForKeyNotNullExpectedObj("children", expectedObj:0) as! Bool
        userInfo.isOtherInfo = tempDict.objectForKeyNotNullExpectedObj("other_info", expectedObj:0) as! Bool
        userInfo.isPhone = tempDict.objectForKeyNotNullExpectedObj("phone", expectedObj:0) as! Bool
        userInfo.isFacebook = tempDict.objectForKeyNotNullExpectedObj("facebook", expectedObj:0) as! Bool
        userInfo.isTwitter = tempDict.objectForKeyNotNullExpectedObj("twitter", expectedObj:0) as! Bool
        userInfo.islinkedIn = tempDict.objectForKeyNotNullExpectedObj("linked_in", expectedObj:0) as! Bool
        userInfo.isGoogle = tempDict.objectForKeyNotNullExpectedObj("google", expectedObj:0) as! Bool
        userInfo.isInstagram = tempDict.objectForKeyNotNullExpectedObj("instagram", expectedObj:0) as! Bool
        userInfo.isAddress = tempDict.objectForKeyNotNullExpectedObj("address", expectedObj:0) as! Bool
        
        //        userInfo.userInfoHandlers = (tempDict.objectForKeyNotNullExpectedObj("social_login", expectedObj:NSArray()) as! NSArray).componentsJoinedByString(",")
        
        
        return userInfo
    }
    


}

