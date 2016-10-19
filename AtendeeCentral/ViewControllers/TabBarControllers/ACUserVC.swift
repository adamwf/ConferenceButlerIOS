//
//  ACUserVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACUserVC: UIViewController {
    
    @IBOutlet weak var bookingTblView: UITableView!
    let dummyDictOne: NSMutableDictionary? = [
        "partyName" : "Uber",
        "infoHandle" : "b1"
    ]
    
    let dummyDictTwo: NSMutableDictionary? = [
        "partyName" : "Hotel Tonight",
        "infoHandle" : "b2"
    ]

    let dummyDictThree: NSMutableDictionary? = [
        "partyName" : "OpenTable",
        "infoHandle" : "b3"
    ]

    var homeArray = NSMutableArray()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    // MARK: - Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Booking"
        homeArray = [dummyDictOne!,dummyDictTwo!,dummyDictThree!]
  self.navigationItem.rightBarButtonItems = ACAppUtilities.rightBarButtonArray(["nav_ic8","nav_ic9",""],controller: self) as? [UIBarButtonItem]
        self.navigationItem.leftBarButtonItems = ACAppUtilities.leftBarButtonArray(["nav_ic7"],controller: self) as? [UIBarButtonItem]
//        addEventToCalendar(title: "Dummy Event", description: "Remember or die!", startDate: NSDate(), endDate: NSDate())
    }
    
    func leftBarButtonsAction(button : UIButton) {
        self.view .endEditing(true)
        NSNotificationCenter.defaultCenter().postNotificationName("setHomeTab", object: nil,userInfo:["tabValue" : "5002"] )
    }
    
    func rightBarButtonsAction(barbutton : UIButton) {
        self.view .endEditing(true)
        if barbutton.tag == 100 {
            
            let calenderVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACCustomCalendarVCID") as! ACCustomCalendarVC
            self.navigationController?.pushViewController(calenderVC, animated: true)
            
//            UIApplication.sharedApplication().openURL(NSURL (string:"calshow://")!)
        } else  {
            let travelChatVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACTravelChatVCID") as! ACTravelChatVC
            self.navigationController?.pushViewController(travelChatVC, animated: true)
        }
    }
    
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return homeArray.count
    }
    
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACHomeTVCellID", forIndexPath: indexPath) as! ACHomeTVCell
        let dict = homeArray.objectAtIndex(indexPath.row)
        cell.descriptionLabel.text = dict["partyName"] as? String
        getRoundImage(cell.feedImageView)
        cell.feedImageView.image = UIImage(named: (dict["infoHandle"] as? String)!)
        
        return cell
    }
    
    //MARK:- Tableview Deleagte Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
//    func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
//                let eventStore = EKEventStore()
//        
//                eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
//                    if (granted) && (error == nil) {
//                        let event = EKEvent(eventStore: eventStore)
//                        event.title = title
//                        event.startDate = startDate
//                        event.endDate = endDate
//                        event.notes = description
//                        event.calendar = eventStore.defaultCalendarForNewEvents
//                        do {
//                            try eventStore.saveEvent(event, span: .ThisEvent)
//                        } catch let e as NSError {
//                            completion?(success: false, error: e)
//                            return
//                        }
//                        completion?(success: true, error: nil)
//                    } else {
//                        completion?(success: false, error: error)
//                    }
//                })
//    }
    
}
