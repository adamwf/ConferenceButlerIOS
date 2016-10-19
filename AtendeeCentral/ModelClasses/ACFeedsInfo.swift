//
//  ACFeedsInfo.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 03/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import AVFoundation

class ACFeedsInfo: NSObject {

    var feedID : String = ""
    var feedTitle : String = ""
    var feedAdImg : NSURL?
    var feedVideoURL : String = ""
    var feedThumbnail : String = ""
    
    class func getFeedsInfo(dict : NSMutableDictionary) -> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict.valueForKey("feeds") as! NSArray
        
        for case let feedsArr as NSArray in tempArray {
            let dummyArray = NSMutableArray()
            
            let tempArray = dict.valueForKey("feeds") as! NSArray
            
            for case let feedsArr as NSArray in tempArray {
                
                let videoDict = feedsArr.firstObject as! NSDictionary
                if videoDict.allKeys.count > 0 {
                    let feedVideoInfo = ACFeedsInfo()
                    feedVideoInfo.feedVideoURL =  videoDict.objectForKeyNotNull("content", expected: NSDictionary()).objectForKeyNotNull("url", expected: "") as! String
                    feedVideoInfo.feedThumbnail =  videoDict.objectForKeyNotNull("content", expected: NSDictionary()).objectForKeyNotNull("url", expected: "") as! String
                    dummyArray.addObject(feedVideoInfo)
                }
                let postDict = feedsArr.objectAtIndex(1) as! NSDictionary
                if postDict.allKeys.count > 0 {
                    let feedPostInfo = ACFeedsInfo()
                    feedPostInfo.feedTitle = postDict.objectForKeyNotNull("content", expected: "") as! String
                    dummyArray.addObject(feedPostInfo)
                }
                let adDict = feedsArr.lastObject as! NSDictionary
                if adDict.allKeys.count > 0 {
                    let feedAdInfo = ACFeedsInfo()
                    feedAdInfo.feedAdImg = NSURL(string: adDict.objectForKeyNotNull("image", expected: NSDictionary()).objectForKeyNotNull("url", expected: "") as! String)
                    dummyArray.addObject(feedAdInfo)
                }
                
                
            }
            
            return dummyArray
        }
        
        return dummyArray
    }
}
