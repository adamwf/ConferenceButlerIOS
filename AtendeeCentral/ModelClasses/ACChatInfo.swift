//
//  ACChatInfo.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 09/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import AVFoundation

class ACChatInfo: NSObject {
    var userID : String = ""
    var userName : String = ""
    var userImage : String = ""
    var message : String = ""
    var time : String = ""
    var image : UIImage = UIImage()
    var videoThumbnail : UIImage = UIImage()
    var video : String = ""
    var audio : String = ""
    var isReceiver : Bool = false
    var isAudio : Bool = false
    var isImage : Bool = false
    var isVideo : Bool = false
    
    class func getChatInfo (dict : NSMutableDictionary)-> NSMutableArray {
        let dummyArray = NSMutableArray()
        
        let tempArray = dict.valueForKey("chatArray")
        
        tempArray!.enumerateObjectsUsingBlock { (dict, index, stop) in
            
            let chatInfo = ACChatInfo()
            let tempDict = dict as! Dictionary<String, AnyObject>
            chatInfo.time = tempDict["time"] as! String! ?? ""
            chatInfo.userImage = tempDict["userImage"] as! String! ?? ""
            chatInfo.message = tempDict["message"] as! String! ?? ""
            chatInfo.isReceiver =  tempDict["isReceiver"] as! Bool
            chatInfo.isAudio =  tempDict["isAudio"] as! Bool
            chatInfo.isImage =  tempDict["isImage"] as! Bool
            chatInfo.isVideo =  tempDict["isVideo"] as! Bool
            chatInfo.video = tempDict["video"] as! String! ?? ""
            chatInfo.audio = tempDict["audio"] as! String! ?? ""
            if chatInfo.isImage {
                chatInfo.image = UIImage(data: NSData(contentsOfFile:tempDict["image"] as! String! ?? "" )!)!
            } else if chatInfo.isVideo {
                ACChatInfo.thumbnailForVideoAtURL(chatInfo.video, completion: { (img :UIImage?) in
                    chatInfo.videoThumbnail = img!
                })
            } else if chatInfo.isAudio {
                chatInfo.videoThumbnail = UIImage (named: "placeAudio")!
            }
            dummyArray.addObject(chatInfo)
        }
        return dummyArray
    }

   class func thumbnailForVideoAtURL(urlStr : String,completion:(UIImage?) -> Void) {
        let url = NSURL(string: urlStr)
        
        let asset = AVAsset(URL: url!)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImageAtTime(time, actualTime: nil)
            completion(UIImage(CGImage: imageRef, scale: 1.0 , orientation: UIImageOrientation.Right))
        } catch {
            print("error")
            completion(UIImage (named: "play_button"))
        }
    }
}
