//
//  DBHandler.swift
//  WorldFax
//
//  Created by Probir Chakraborty on 29/09/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import CoreData

// constants >>> Start
let dChannelClass = "Channels"
let dChannelSectionsClass = "ChannelSections"
let dFeedsClass = "Feeds"
let dUserClass = "User"
let dVoicesClass = "Voices"

let staticUserID = "1"
let dateFormat = "YYYY-MM-dd HH:mm:ss"

let delayTime = 0.3

// constants >>> End
class DBHandler: NSObject {
    
    class var sharedDBInstance: DBHandler {
        struct Static {
            static let instance: DBHandler = DBHandler()
        }
        return Static.instance
    }
    
//    func currentUser() -> User {
//        return getUserWithID(staticUserID)!
//    }
//    
//    func getUserWithID(strID:String) -> User? {
//        
//        let predicate = NSPredicate(format: "user_id = %@", strID)
//        
//        let user = searchOrGetNewObjectForEntity(dUserClass, predicate: predicate) as! User
//        user.user_id = strID
//        user.user_name = "test"
//        user.password = "test"
//        save()
//        return user
//    }
//    
//    func getChannelWithID(strID:String) -> Channels? {
//        let predicate = NSPredicate(format: "channel_id = %@", strID)
//        let channel = searchObjectForEntity(dChannelClass, predicate: predicate) as? Channels
//        return channel
//    }
//    
//    func getChannelSectionWithID(strID:String) -> ChannelSections? {
//        let predicate = NSPredicate(format: "section_id = %@", strID)
//        let channelSection = searchObjectForEntity(dChannelSectionsClass, predicate: predicate) as? ChannelSections
//        return channelSection
//    }
//    
//    func doesChannelExist(id: String) -> Bool {
//        let fetchRequest = NSFetchRequest(entityName: dChannelClass)
//        let predicate = NSPredicate(format: "id == %@", id)
//        fetchRequest.predicate = predicate
//        fetchRequest.fetchLimit = 1
//        
//        let count = managedObjectContext.countForFetchRequest(fetchRequest, error: nil)
//        return (count > 0) ? true : false
//    }
//    
//    func getChannels(completionBlock: (Array<Channels>) -> Void, updateCompletionBlock:((Array<Channels>?, NSError?) -> Void)?) {
//        
//        // return data getting from DB
//        
//        //        self.getChannelsFromDB({ (channels:Array<Channels>) in
//        //            completionBlock(channels)
//        //        })
//        
//        // delete old data
//        self.deleteChannels()
//        
//        self.getChannelsFromDB({ (channels:Array<Channels>) in
//            completionBlock([])
//        })
//        
//        // update DB by api call
//        
//        apiCallToGetNewsSources { (result:AnyObject?, error:NSError?) in
//            if (error != nil) {
//                //log("error >>> \(error)")
//                updateCompletionBlock!(nil, error)
//            } else {
//                if let result = result {
//                    
//                    log("result >>> \(result)")
//                    
//                    //                    // delete old data
//                    //                    self.deleteChannels()
//                    
//                    delay(delayTime, closure: {
//                        // update DB
//                        let channelList = result[pAll] as! Array<AnyObject>
//                        self.updateChannels(channelList)
//                        
//                        // return updated data getting from DB
//                        self.getChannelsFromDB({ (channels:Array<Channels>) in
//                            updateCompletionBlock!(channels, nil)
//                        })
//                    })
//                }
//            }
//        }
//    }
//    
//    func getChannelSections(channel:Channels, completionBlock: (Array<ChannelSections>) -> Void, updateCompletionBlock:((Array<ChannelSections>?, NSError?) -> Void)?) {
//        
//        // return data getting from DB
//        
//        
//        
//        //        self.getChannelSectionsFromDB(channel) { (channelSections:Array<ChannelSections>) in
//        //            completionBlock(channelSections)
//        //        }
//        
//        self.deleteChannelSectionsForChannelID(channel)
//        
//        self.getChannelSectionsFromDB(channel) { (channelSections:Array<ChannelSections>) in
//            completionBlock([])
//        }
//        
//        // update DB by api call
//        
//        apiCallToGetChannelSections(channel) { (result:AnyObject?, error:NSError?) in
//            if (error != nil) {
//                //log("error >>> \(error)")
//                updateCompletionBlock!(nil, error)
//            } else {
//                if let result = result {
//                    
//                    log("result >>> \(result)")
//                    
//                    //delete old data
//                    //                    self.deleteChannelSectionsForChannelID(channel)
//                    
//                    delay(delayTime, closure: { () -> () in
//                        // update DB
//                        let channelSectionList = result as! Array<AnyObject>
//                        self.updateChannelSections(channel, channelSections: channelSectionList)
//                        
//                        log("update channel count   \(channelSectionList.count)")
//                        
//                        // return updated data getting from DB
//                        self.getChannelSectionsFromDB(channel) { (channelSections:Array<ChannelSections>) in
//                            updateCompletionBlock!(channelSections, nil)
//                        }
//                    })
//                    
//                }
//            }
//        }
//    }
//    
//    func getChannelSectionFeeds(channelSection:ChannelSections, completionBlock: (Array<Feeds>) -> Void, updateCompletionBlock:((Array<Feeds>?, NSError?) -> Void)?) {
//        
//        // return data getting from DB
//        
//        //        self.getChannelSectionFeedsFromDB(channelSection) { (feeds:Array<Feeds>) in
//        //            completionBlock(feeds)
//        //        }
//        
//        self.deleteChannelSectionFeedsForChannelSectionID(channelSection)
//        
//        self.getChannelSectionFeedsFromDB(channelSection) { (feeds:Array<Feeds>) in
//            completionBlock([])
//        }
//        
//        // update DB by api call
//        
//        apiCallToGetChannelSectionFeeds(channelSection) { (result:AnyObject?, error:NSError?) in
//            if (error != nil) {
//                //log("error >>> \(error)")
//                updateCompletionBlock!(nil, error)
//            } else {
//                if let result = result {
//                    
//                    log("result >>> \(result)")
//                    
//                    // delete old data
//                    //self.deleteChannelSectionFeedsForChannelSectionID(channelSection)
//                    
//                    // update DB
//                    delay(delayTime, closure: { () -> () in
//                        
//                        let feedList = result as! Array<AnyObject>
//                        
//                        log("update feed count   \(feedList.count)")
//                        
//                        
//                        self.updateChannelSectionFeeds(channelSection, feeds: feedList)
//                        
//                        // return updated data getting from DB
//                        self.getChannelSectionFeedsFromDB(channelSection) { (feeds:Array<Feeds>) in
//                            updateCompletionBlock!(feeds, nil)
//                        }
//                    })
//                }
//            }
//        }
//    }
//    
//    func loadVoices(completionBlock: (Array<Voices>) -> Void, updateCompletionBlock:((Array<Voices>?, NSError?) -> Void)?) {
//        
//        // return data getting from DB
//        
//        self.getVoiceListFromDB { (voices:Array<Voices>) in
//            completionBlock(voices)
//        }
//        
//        // update DB by api call
//        
//        apiCallToGetVoiceList { (result:AnyObject?, error:NSError?) in
//            if (error != nil) {
//                //log("error >>> \(error)")
//                updateCompletionBlock!(nil, error)
//            } else {
//                if let result = result {
//                    
//                    log("result >>> \(result)")
//                    // update DB
//                    let voiceList = result[pAll] as! Array<AnyObject>
//                    self.updateVoices(voiceList)
//                    
//                    // return updated data getting from DB
//                    self.getVoiceListFromDB { (voices:Array<Voices>) in
//                        updateCompletionBlock!(voices,nil)
//                    }
//                }
//            }
//        }
//    }
//    
//    private func updateChannels(channels: Array<AnyObject>) {
//        
//        for obj in channels {
//            
//            let channel = obj as! Dictionary<String, AnyObject>
//            
//            let channelID =  "\(keyValue("", key: pChannel_id, dict: channel))"
//            
//            let predicate = NSPredicate(format: "channel_id = %@", channelID)
//            
//            let channelObjectModal = searchOrGetNewObjectForEntity(dChannelClass, predicate: predicate) as! Channels
//            
//            channelObjectModal.channel_id =  channelID
//            channelObjectModal.channel_logo = "\(keyValue("", key: pChannel_logo, dict: channel))"
//            channelObjectModal.channel_name = "\(keyValue("", key: pChannel_name, dict: channel))"
//            
//            let createdOnDate = "\(keyValue("", key: pCreated_on, dict: channel))"
//            
//            if let date = createdOnDate.dateFromString(dateFormat) {
//                channelObjectModal.created_on = date.timeIntervalSince1970
//            }
//            
//            let deletionStatus = "\(keyValue("", key: pIs_del, dict: channel))"
//            let status = "\(keyValue("", key: pStatus, dict: channel))"
//            
//            channelObjectModal.is_del = deletionStatus == "1" ? true : false
//            channelObjectModal.status = status == "1" ? true : false
//        }
//        
//        save()
//    }
//    
//    private func updateChannelSections(channel:Channels, channelSections: Array<AnyObject>) {
//        
//        for obj in channelSections {
//            
//            let channelSection = obj as! Dictionary<String, AnyObject>
//            
//            let sectionID =  "\(keyValue("", key: pSection_id, dict: channelSection))"
//            
//            let predicate = NSPredicate(format: "section_id = %@", sectionID)
//            
//            let channelObjectModal = searchOrGetNewObjectForEntity(dChannelSectionsClass, predicate: predicate) as! ChannelSections
//            
//            channelObjectModal.section_id =  sectionID
//            channelObjectModal.channel_id = "\(keyValue("", key: pChannel_id, dict: channelSection))"
//            channelObjectModal.section_logo = "\(keyValue("", key: pSection_logo, dict: channelSection))"
//            channelObjectModal.section_name = "\(keyValue("", key: pSection_name, dict: channelSection))"
//            channelObjectModal.section_url = "\(keyValue("", key: pSection_url, dict: channelSection))"
//            
//            let createdOnDate = "\(keyValue("", key: pCreated_on, dict: channelSection))"
//            
//            if let date = createdOnDate.dateFromString(dateFormat) {
//                channelObjectModal.created_on = date.timeIntervalSince1970
//            }
//            
//            addChannelSectionToChannelRelation(channel, channelSection: channelObjectModal)
//        }
//        
//        save()
//    }
//    
//    private func updateChannelSectionFeeds(channelSection:ChannelSections, feeds: Array<AnyObject>) {
//        
//        for obj in feeds {
//            
//            let feed = obj as! Dictionary<String, AnyObject>
//            
//            let feedID =  "\(keyValue("", key: pFeed_id, dict: feed))"
//            
//            let predicate = NSPredicate(format: "feed_id = %@", feedID)
//            
//            log("feedID>>>>>>   \(feedID)")
//            
//            let feedObjectModal = searchOrGetNewObjectForEntity(dFeedsClass, predicate: predicate) as! Feeds
//            
//            feedObjectModal.feed_id =  feedID
//            feedObjectModal.audio_id = "\(keyValue("", key: pAudio_id, dict: feed))"
//            feedObjectModal.section_id = "\(keyValue("", key: pSection_id, dict: feed))"
//            
//            feedObjectModal.audio_name = "\(keyValue("", key: pAudio_name, dict: feed))"
//            feedObjectModal.conversion_number = "\(keyValue("", key: pConversion_number, dict: feed))"
//            
//            feedObjectModal.feed_author = "\(keyValue("", key: pFeed_author, dict: feed))"
//            feedObjectModal.feed_description = "\(keyValue("", key: pFeed_description, dict: feed))"
//            feedObjectModal.feed_image = "\(keyValue("", key: pFeed_image, dict: feed))"
//            //feedObjectModal.feed_intro = "\(keyValue("", key: pFeed_intro, dict: feed))"
//            feedObjectModal.feed_link = "\(keyValue("", key: pFeed_link, dict: feed))"
//            feedObjectModal.feed_title = "\(keyValue("", key: pFeed_title, dict: feed))"
//            feedObjectModal.voice_id = "\(keyValue("", key: pVoice_id, dict: feed))"
//            feedObjectModal.is_audio_converted = Int64("\(keyValue("", key: pIs_audio_converted, dict: feed))")!
//            
//            let postedDate = "\(keyValue("", key: pFeed_post_date, dict: feed))"
//            
//            if let date = postedDate.dateFromString(dateFormat) {
//                feedObjectModal.feed_post_date = date.timeIntervalSince1970
//            }
//            
//            addSectionFeedToChannelSectionRelation(channelSection, feed: feedObjectModal)
//        }
//        
//        save()
//    }
//    
//    private func deleteChannels() {
//        
//        
//        let request = NSFetchRequest();
//        request.entity = NSEntityDescription.entityForName(dChannelClass, inManagedObjectContext: managedObjectContext)
//        
//        do {
//            var objects = try managedObjectContext.executeFetchRequest(request)
//            log("Channel count   \(objects.count)")
//            objects.removeAll()
//            
//            for result: AnyObject in objects  {
//                
//                if let channel = result as? Channels {
//                    managedObjectContext.deleteObject(channel)
//                    log("Channel:   \(channel.channel_id)")
//                }
//            }
//            
//        } catch let error as NSError {
//            // failure
//            log("Error searchInDataBase: \(error.localizedDescription)")
//        }
//    }
//    
//    private func deleteChannelSectionFeedsForChannelSectionID(channelSection:ChannelSections) {
//        
//        let predicate = NSPredicate(format: "section_id = %@", channelSection.section_id!)
//        
//        let request = NSFetchRequest();
//        request.entity = NSEntityDescription.entityForName(dFeedsClass, inManagedObjectContext: managedObjectContext)
//        request.predicate = predicate
//        
//        do {
//            var objects = try managedObjectContext.executeFetchRequest(request)
//            log("deleteFeed count   \(objects.count)")
//            objects.removeAll()
//            
//            for result: AnyObject in objects  {
//                if let feed = result as? Feeds {
//                    managedObjectContext.deleteObject(feed)
//                    log("deleteChannelSectionFeedsForChannelSectionID:   \(channelSection.section_id!)")
//                }
//            }
//            
//        } catch let error as NSError {
//            // failure
//            log("Error searchInDataBase: \(error.localizedDescription)")
//        }
//        
//    }
//    
//    private func deleteChannelSectionsForChannelID(channel:Channels) {
//        
//        let predicate = NSPredicate(format: "channel_id = %@", channel.channel_id!)
//        
//        let request = NSFetchRequest();
//        request.entity = NSEntityDescription.entityForName(dChannelSectionsClass, inManagedObjectContext: managedObjectContext)
//        request.predicate = predicate
//        
//        do {
//            var objects = try managedObjectContext.executeFetchRequest(request)
//            log("deleteChannelSections count   \(objects.count)")
//            objects.removeAll()
//            
//            for result: AnyObject in objects  {
//                
//                if let feed = result as? ChannelSections {
//                    managedObjectContext.deleteObject(feed)
//                    log("deleteChannelSectionsForChannelID:   \(channel.channel_id)")
//                }
//            }
//            
//        } catch let error as NSError {
//            // failure
//            log("Error searchInDataBase: \(error.localizedDescription)")
//        }
//    }
//    
//    private func updateVoices(voices: Array<AnyObject>) {
//        
//        for obj in voices {
//            
//            let voice = obj as! Dictionary<String, AnyObject>
//            
//            let voiceID =  "\(keyValue("", key: pVoice_id, dict: voice))"
//            
//            let predicate = NSPredicate(format: "voice_id = %@", voiceID)
//            
//            let voiceObjectModal = searchOrGetNewObjectForEntity(dVoicesClass, predicate: predicate) as! Voices
//            
//            voiceObjectModal.voice_id =  voiceID
//            voiceObjectModal.display_name = "\(keyValue("", key: pDisplay_name, dict: voice))"
//            voiceObjectModal.voice_name = "\(keyValue("", key: pVoice_name, dict: voice))"
//            
//            let createdOnDate = "\(keyValue("", key: pCreated_on, dict: voice))"
//            
//            if let date = createdOnDate.dateFromString(dateFormat) {
//                voiceObjectModal.created_on = date.timeIntervalSince1970
//            }
//            
//            let deletionStatus = "\(keyValue("", key: pIs_del, dict: voice))"
//            let status = "\(keyValue("", key: pStatus, dict: voice))"
//            
//            voiceObjectModal.is_del = deletionStatus == "1" ? true : false
//            voiceObjectModal.status = status == "1" ? true : false
//        }
//        
//        save()
//    }
//    
//    
//    private func addChannelSectionToChannelRelation(channel:Channels, channelSection:ChannelSections) {
//        
//        let set = NSMutableSet(set:(channel.channelsToChannelSections)!)
//        
//        let predicate = NSPredicate(format: "section_id == %@", channelSection.section_id!)
//        
//        let filteredSet = set.filteredSetUsingPredicate(predicate)
//        
//        if let existingChannelSection = filteredSet.first {
//            set.removeObject(existingChannelSection)
//        }
//        set.addObject(channelSection)
//        
//        channel.channelsToChannelSections? = set.mutableCopy() as! NSSet
//        
//        // no need to save. It will be saved as as full list save
//    }
//    
//    private func addSectionFeedToChannelSectionRelation(channelSection:ChannelSections, feed:Feeds) {
//        
//        let set = NSMutableSet(set:(channelSection.channelSectionsToFeeds)!)
//        
//        let predicate = NSPredicate(format: "feed_id == %@", feed.feed_id!)
//        
//        let filteredSet = set.filteredSetUsingPredicate(predicate)
//        
//        if let existingChannelSectionFeed = filteredSet.first {
//            set.removeObject(existingChannelSectionFeed)
//        }
//        set.addObject(feed)
//        
//        channelSection.channelSectionsToFeeds? = set.mutableCopy() as! NSSet
//        
//        // no need to save. It will be saved as as full list save
//    }
//    
//    private func getChannelsFromDB(completionBlock: (Array<Channels>) -> Void) {
//        
//        let entityDescription = NSEntityDescription.entityForName(dChannelClass, inManagedObjectContext: managedObjectContext)
//        
//        let request = NSFetchRequest()
//        request.entity = entityDescription
//        request.returnsObjectsAsFaults = false
//        request.sortDescriptors = sortDescriptor(pCreated_on, keyName: pChannel_name)
//        
//        do {
//            let channels = try managedObjectContext.executeFetchRequest(request) as! [Channels]
//            
//            //log("DBHandler: getChannelsFromDB    \(objects)")
//            
//            return completionBlock(channels)
//            
//        } catch let error as NSError {
//            // failure
//            log("Channel List Fetch failed: \(error.localizedDescription)")
//        }
//        
//        return completionBlock([])
//    }
//    
//    private func getChannelSectionsFromDB(channel:Channels, completionBlock: (Array<ChannelSections>) -> Void) {
//        
//        let sortDescriptors = sortDescriptor(pCreated_on, keyName: pSection_name)
//        
//        let channelSections = channel.channelsToChannelSections?.sortedArrayUsingDescriptors(sortDescriptors) as? Array<ChannelSections>
//        
//        return completionBlock(channelSections!)
//    }
//    
//    private func getChannelSectionFeedsFromDB(channelSection:ChannelSections, completionBlock: (Array<Feeds>) -> Void) {
//        
//        let sortDescriptors = sortDescriptor(pFeed_post_date, keyName: pFeed_title)
//        
//        let feeds = channelSection.channelSectionsToFeeds?.sortedArrayUsingDescriptors(sortDescriptors) as? Array<Feeds>
//        
//        return completionBlock(feeds!)
//    }
//    
//    func getVoiceListFromDB(completionBlock: (Array<Voices>) -> Void) {
//        
//        let entityDescription = NSEntityDescription.entityForName(dVoicesClass, inManagedObjectContext: managedObjectContext)
//        
//        let request = NSFetchRequest()
//        request.entity = entityDescription
//        request.returnsObjectsAsFaults = false
//        
//        do {
//            let voiceList = try managedObjectContext.executeFetchRequest(request) as! [Voices]
//            
//            return completionBlock(voiceList)
//            
//        } catch let error as NSError {
//            // failure
//            log("voiceList Fetch failed: \(error.localizedDescription)")
//        }
//        
//        return completionBlock([])
//        
//    }
//    
//    func addChannelsToUserChannelList(channels:Array<Channels>) {
//        let user = DBHandler.sharedDBInstance.currentUser()
//        
//        let set = NSMutableSet(set:(user.selectedChannels)!)
//        
//        for channel in channels {
//            let predicate = NSPredicate(format: "channel_id == %@", channel.channel_id!)
//            
//            let filteredSet = set.filteredSetUsingPredicate(predicate)
//            
//            if let existingChannel = filteredSet.first {
//                set.removeObject(existingChannel)
//            }
//            set.addObject(channel)
//        }
//        
//        user.selectedChannels? = set.mutableCopy() as! NSSet
//        save()
//    }
//    
//    func updateChannelsToUserChannelList(channels:Array<Channels>) {
//        let user = DBHandler.sharedDBInstance.currentUser()
//        
//        let set = NSMutableSet(set:(user.selectedChannels)!)
//        
//        for channel in channels {
//            let predicate = NSPredicate(format: "channel_id == %@", channel.channel_id!)
//            
//            let filteredSet = set.filteredSetUsingPredicate(predicate)
//            
//            if let existingChannel = filteredSet.first {
//                set.removeObject(existingChannel)
//            }
//            
//            if channel.userSelectionStatus {
//                set.addObject(channel)
//            }
//        }
//        
//        user.selectedChannels? = set.mutableCopy() as! NSSet
//        save()
//    }
//    
//    func removeChannelFromUserChannelList(channel:Channels) {
//        let user = DBHandler.sharedDBInstance.currentUser()
//        
//        let predicate = NSPredicate(format: "channel_id == %@", channel.channel_id!)
//        
//        let set = NSMutableSet(set:(user.selectedChannels)!)
//        let filteredSet = set.filteredSetUsingPredicate(predicate)
//        
//        if let existingChannel = filteredSet.first {
//            set.removeObject(existingChannel)
//            user.selectedChannels? = set
//            save()
//        } else {
//            log("Object not found: removeChannelFromUserPlayList")
//        }
//    }
//    
//    func addFeedToUserPlayList(feed:Feeds) {
//        let user = DBHandler.sharedDBInstance.currentUser()
//        
//        let set = NSMutableSet(set:(user.selectedFeeds)!)
//        
//        let predicate = NSPredicate(format: "feed_id == %@", feed.feed_id!)
//        
//        let filteredSet = set.filteredSetUsingPredicate(predicate)
//        
//        if let existingFeed = filteredSet.first {
//            set.removeObject(existingFeed)
//        }
//        set.addObject(feed)
//        
//        user.selectedFeeds? = set.mutableCopy() as! NSSet
//        save()
//    }
//    
//    func removeFeedFromUserPlayList(feed:Feeds) {
//        let user = DBHandler.sharedDBInstance.currentUser()
//        
//        let predicate = NSPredicate(format: "feed_id == %@", feed.feed_id!)
//        
//        let set = NSMutableSet(set:(user.selectedFeeds)!)
//        let filteredSet = set.filteredSetUsingPredicate(predicate)
//        
//        if let existingFeed = filteredSet.first {
//            set.removeObject(existingFeed)
//            user.selectedFeeds? = set
//            save()
//        } else {
//            log("Object not found: removeFeedFromUserPlayList")
//        }
//    }
//    
//    func getUserPlayList() -> Array<Feeds> {
//        let sortDescriptors = sortDescriptor(pFeed_post_date, keyName: pFeed_title)
//        
//        let feeds = DBHandler.sharedDBInstance.currentUser().selectedFeeds?.sortedArrayUsingDescriptors(sortDescriptors) as? Array<Feeds>
//        
//        return feeds!
//    }
//    
//    private func searchOrGetNewObjectForEntity(entityName: String, predicate: NSPredicate) ->AnyObject {
//        
//        var obj: AnyObject!
//        let searchedObject = self.searchInDataBase(entityName, predicate: predicate)
//        if (searchedObject!.count>0) {
//            obj = searchedObject!.firstObject
//        } else {
//            obj = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: managedObjectContext)
//        }
//        return obj
//    }
//    
//    private func searchObjectForEntity(entityName: String, predicate: NSPredicate) ->AnyObject? {
//        
//        let searchedObject = self.searchInDataBase(entityName, predicate: predicate)
//        if (searchedObject!.count>0) {
//            let obj = searchedObject!.firstObject
//            return obj
//        }
//        return nil
//    }
//    
//    private func searchInDataBase(entityName: String, predicate: NSPredicate?) -> NSArray? {
//        
//        let request = NSFetchRequest();
//        request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)
//        
//        if (predicate != nil) {
//            request.predicate = predicate
//        }
//        do {
//            let objects = try managedObjectContext.executeFetchRequest(request)
//            
//            return objects
//            
//        } catch let error as NSError {
//            // failure
//            log("Error searchInDataBase: \(error.localizedDescription)")
//        }
//        return nil
//    }
//    
//    private func sortDescriptor(keyDate:String, keyName:String) -> Array<NSSortDescriptor> {
//        // sort by date
//        let sortDescriptorDate = NSSortDescriptor(key: keyDate, ascending: false)
//        let sortDescriptorName = NSSortDescriptor(key: keyName, ascending: true)
//        
//        var array = [NSSortDescriptor]()
//        array.append(sortDescriptorDate)
//        array.append(sortDescriptorName)
//        
//        return array
//    }
//    
//    func save() {
//        
//        //kAppDelegate.saveContext()
//        
//        let context = managedObjectContext
//        
//        context.performBlockAndWait {
//            
//            if context.hasChanges {
//                do {
//                    try context.save()
//                } catch {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    let nserror = error as NSError
//                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
//                    //abort()
//                }
//            }
//        }
//    }
//    
//    func objectWithID(objectID: NSManagedObjectID) -> NSManagedObject {
//        return managedObjectContext.objectWithID(objectID)
//    }
//    
//    func deleteObject(object: NSManagedObject) {
//        let moc = managedObjectContext
//        moc.performBlockAndWait {
//            moc.deleteObject(object)
//        }
//        
//        save()
//    }
//    
//    let managedObjectContext: NSManagedObjectContext = {
//        //            let moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
//        //            moc.undoManager = nil
//        //            moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        //
//        //            return moc
//        return kAppDelegate.managedObjectContext
//    }()
//    
//    // MARK: - Web APIs Section >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//    
//    private func apiCallToGetNewsSources(completionBlock: (AnyObject?, NSError?) -> Void) ->Void {
//        
//        mixpanel.track(
//            "allChannels api call made.",
//            properties: [:]
//        )
//        
//        ServiceHelper.sharedInstance.callAPIWithParameters(NSMutableDictionary(), method: .GET, apiName: kAPINameAllChannels, hudType: .Default) { (result:AnyObject?, error:NSError?) in
//            
//            completionBlock(result,error)
//        }
//    }
//    
//    private func apiCallToGetChannelSections(channel:Channels, completionBlock: (AnyObject?, NSError?) -> Void) ->Void {
//        
//        mixpanel.track(
//            "sectionList api call made.",
//            properties: ["channelid": channel.channel_id!]
//        )
//        
//        ServiceHelper.sharedInstance.callAPIWithParameters(NSMutableDictionary(object: channel.channel_id!, forKey: pChannelId), method: .GET, apiName: kAPINameSectionList, hudType: .Default) { (result:AnyObject?, error:NSError?) in
//            completionBlock(result,error)
//        }
//    }
//    
//    private func apiCallToGetChannelSectionFeeds(channelSection:ChannelSections, completionBlock: (AnyObject?, NSError?) -> Void) ->Void {
//        
//        mixpanel.track(
//            "feedsList api call made.",
//            properties: ["sectionid": channelSection.section_id!]
//        )
//        
//        ServiceHelper.sharedInstance.callAPIWithParameters(NSMutableDictionary(object: channelSection.section_id!, forKey: pSectionId), method: .GET, apiName: kAPINameFeedsList, hudType: .Default) { (result:AnyObject?, error:NSError?) in
//            completionBlock(result,error)
//        }
//    }
//    
//    private func apiCallToGetVoiceList(completionBlock: (AnyObject?, NSError?) -> Void) ->Void {
//        
//        mixpanel.track(
//            "voiceList api call made.",
//            properties: [:]
//        )
//        
//        ServiceHelper.sharedInstance.callAPIWithParameters([:], method: .GET, apiName: kAPINameVoiceList, hudType: .Default) { (result:AnyObject?, error:NSError?) in
//            completionBlock(result,error)
//        }
//    }
//    
//    // MARK: - Data handling >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//    
//    private func keyValue(expectedObj:AnyObject, key:String, dict:Dictionary<String, AnyObject>) -> AnyObject {
//        
//        if let object = dict[key] {
//            //log("Object found.")
//            if (object is NSNumber) && (expectedObj is String) {
//                return "\(object)"
//            } else if object is String {
//                if ((object as! String == "null") || (object as! String == "<null>") || (object as! String == "(null)")) {
//                    return expectedObj
//                }
//            }
//            return object
//        } else {
//            //log("Object not found. Return expected")
//            return expectedObj
//        }
//    }
}
