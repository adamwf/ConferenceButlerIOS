//
//  ACStickerinfo.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 27/10/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACStickerinfo: NSObject {
    var isSelectedStickerCollection : Bool = false
    var stickerID : String = ""
    var stickerName : String = ""
    var stickerImage : String = ""
    var collectionID : String = ""
    var stickerArr : NSArray = []
    class func getStickerCollection(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict.objectForKeyNotNullExpectedObj("collectionArray", expectedObj:NSArray()) as! NSArray
        
        tempArray.enumerateObjectsUsingBlock { (dict, index, stop) in
            let stickerObj = ACStickerinfo()
            let tempDict = dict as! NSDictionary
            
            stickerObj.collectionID = String(format: "%d", tempDict.objectForKeyNotNullExpectedObj("collectionId", expectedObj:0) as! NSInteger)
            stickerObj.isSelectedStickerCollection = tempDict.objectForKeyNotNullExpectedObj("isSelection", expectedObj:0) as! Bool
            stickerObj.stickerArr = tempDict.objectForKeyNotNullExpectedObj("stickerArray", expectedObj:NSArray()) as! NSArray
            dummyArray.addObject(stickerObj)
        }
        
        return dummyArray
    }
}
