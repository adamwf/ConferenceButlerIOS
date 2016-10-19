//
//  ACEventInfo.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 07/10/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACEventInfo: NSObject {

    var isAttending : Bool = false
    var eventID : String = ""
    var eventInvitationID : String = ""
    var eventName : String = ""
    var eventStartDate : String = ""
    var eventEndDate : String = ""
    var eventDetail : String = ""
    
    class func getEventList(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict.objectForKeyNotNullExpectedObj("event_list", expectedObj:NSArray()) as! NSArray
        
        tempArray.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let eventInfo = ACEventInfo()
            let tempDict = dict as! NSDictionary
            eventInfo.eventID = String(format: "%d", tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
            eventInfo.eventName = tempDict.objectForKeyNotNullExpectedObj("name", expectedObj:"") as! String
            eventInfo.eventStartDate = tempDict.objectForKeyNotNullExpectedObj("start_time", expectedObj:"") as! String
            eventInfo.eventEndDate = tempDict.objectForKeyNotNullExpectedObj("end_time", expectedObj:"") as! String
            eventInfo.isAttending = tempDict.objectForKeyNotNullExpectedObj("availability", expectedObj:0) as! Bool
            eventInfo.eventDetail = tempDict.objectForKeyNotNullExpectedObj("about", expectedObj:"") as! String
            
            dummyArray.addObject(eventInfo)
        }
        return dummyArray
    }
    
    
    class func getEventInvitationList(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict.objectForKeyNotNullExpectedObj("invitations", expectedObj:NSArray()) as! NSArray
        
        tempArray.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let eventInfo = ACEventInfo()
            let tempDict = dict as! NSDictionary
            eventInfo.eventID = String(format: "%d", (tempDict.objectForKeyNotNull("event", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
            eventInfo.eventName = (tempDict.objectForKeyNotNull("event", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNullExpectedObj("name", expectedObj:"") as! String
            eventInfo.eventStartDate = (tempDict.objectForKeyNotNull("event", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNullExpectedObj("start_time", expectedObj:"") as! String
            eventInfo.eventEndDate = (tempDict.objectForKeyNotNull("event", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNullExpectedObj("end_time", expectedObj:"") as! String
            eventInfo.isAttending = (tempDict.objectForKeyNotNull("event", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNullExpectedObj("availability", expectedObj:0) as! Bool
            eventInfo.eventInvitationID = String(format: "%d", tempDict.objectForKeyNotNullExpectedObj("id", expectedObj:0) as! NSInteger)
//            eventInfo.eventDetail = (tempDict.objectForKeyNotNull("", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNullExpectedObj("about", expectedObj:"") as! String
            dummyArray.addObject(eventInfo)
        }
        return dummyArray
    }

}
