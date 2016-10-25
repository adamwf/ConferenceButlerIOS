//
//  ACEventsVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 06/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACEventsVC: UIViewController {

    @IBOutlet weak var eventTblView: UITableView!
    var eventArray = NSMutableArray()
    var pageNo : NSInteger = 1
    var maxPageNo : NSInteger = 1
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.eventArray.removeAllObjects()
        callApiForEventInvitationList(pageNo)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Events"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        eventTblView.estimatedRowHeight = 100.0
        eventTblView.rowHeight = UITableViewAutomaticDimension
       }
    
    func getFormattedDate(strDate : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.dateFromString(strDate)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.stringFromDate(date!)
    }

    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    
         //MARK:- Cell Button Action Methods
    @objc func acceptButtonAction(button : UIButton) {
//        AlertController.alert("Work in progress")
        let event = eventArray.objectAtIndex(button.tag - 1000) as! ACEventInfo
        callApiForAcceptRequest(event.eventInvitationID)
    }
    
    @objc func declineButtonAction(button : UIButton) {
//        AlertController.alert("Work in progress")
        AlertController.alert("", message: "Are you sure you want to decline this event's request?", buttons: ["Yes","NO"], tapBlock: { (alertAction, position) -> Void in
            if position == 0 {
                let event = self.eventArray.objectAtIndex(button.tag - 100) as! ACEventInfo
                self.callApiForDeclineRequest(event.eventInvitationID)
            }
        })

        
        
    }
    
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return eventArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACEventTVCellID", forIndexPath: indexPath) as! ACEventTVCell
        let event = eventArray.objectAtIndex(indexPath.row) as! ACEventInfo
        cell.titleLabel.text = event.eventName
        cell.dateLabel.text =  String(format: "%@ - %@",getFormattedDate(event.eventStartDate) ,getFormattedDate(event.eventEndDate))
        cell.detailLabel.text = event.eventDetail
        cell.acceptButton.tag = 1000 + indexPath.row
        cell.declineButton.tag = 100 + indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(acceptButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.declineButton.addTarget(self, action: #selector(declineButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    //MARK:- Tableview Delegate Methods
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40.0 && pageNo < maxPageNo+1) {
            pageNo += 1
            callApiForEventInvitationList(pageNo)
        }
    }

    //MARK:- Web API Methods
    func callApiForEventInvitationList(pageNo:NSInteger) {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            
            let params: [String : AnyObject] = [
                "user": dict ,
                "page" : pageNo
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "event_apis/invitation_list", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.eventArray.addObjectsFromArray(ACEventInfo.getEventInvitationList(res) as [AnyObject])
                        self.maxPageNo = res.objectForKeyNotNull("total_pages", expected: 0) as! NSInteger
                        self.eventTblView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForAcceptRequest(strEventID : String) {
        if kAppDelegate.hasConnectivity() {
            print(NSUserDefaults.standardUserDefaults().valueForKey("ACUserID"))
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACEventInvitationId] = strEventID
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "event_apis/accept_invitation", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        AlertController.alert("", message: res.objectForKeyNotNull("responseMessage", expected: "") as! String, buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
                            if position == 0 {
                                self.pageNo =  1
                                self.eventArray.removeAllObjects()
                                self.callApiForEventInvitationList(self.pageNo)
                            }
                        })
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForDeclineRequest(strEventID : String) {
        if kAppDelegate.hasConnectivity() {
            print(NSUserDefaults.standardUserDefaults().valueForKey("ACUserID"))
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACEventInvitationId] = strEventID
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
             ServiceHelper.sharedInstance.createPostRequest(params, apiName: "event_apis/decline_invitation", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        AlertController.alert("", message: res.objectForKeyNotNull("responseMessage", expected: "") as! String, buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
                            if position == 0 {
                                self.pageNo =  1
                                self.eventArray.removeAllObjects()
                                self.callApiForEventInvitationList(self.pageNo)
                            }
                        })
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }

}
