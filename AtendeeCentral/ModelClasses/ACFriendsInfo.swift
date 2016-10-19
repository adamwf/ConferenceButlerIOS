//
//  ACFriendsInfo.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 13/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACFriendsInfo: NSObject {
    
    var isSelectedUserFriend : Bool = false
    var userID : String = ""
    var userName : String = ""
    var userEmail : String = ""
    var userImage : String = ""
    var userStatus : Bool = false
    var userDetail : String = ""
    var groupImage : String = ""
    
    class func getFriendList(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict.objectForKeyNotNullExpectedObj("contact_list", expectedObj:NSArray()) as! NSArray
        
        tempArray.enumerateObjectsUsingBlock { (dict, index, stop) in
            let friendObj = ACFriendsInfo()
            let tempDict = dict as! NSDictionary
            
            friendObj.userID = String(format: "%d", tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
            friendObj.userName = tempDict.objectForKeyNotNullExpectedObj("user_name", expectedObj:"") as! String
            friendObj.userImage = tempDict.objectForKeyNotNullExpectedObj("image", expectedObj:"") as! String
            friendObj.userEmail = tempDict.objectForKeyNotNullExpectedObj("email", expectedObj:"") as! String
            friendObj.isSelectedUserFriend = false
            dummyArray.addObject(friendObj)
        }
        
        return dummyArray
    }
}
