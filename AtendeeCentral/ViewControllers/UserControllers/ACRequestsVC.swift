//
//  ACRequestsVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACRequestsVC: UIViewController {

    var  requestUserArray = NSMutableArray()
    @IBOutlet var requeststableView: UITableView!
    var pageNo : NSInteger = 1
    var Keyword = String()
    var maxPageNo : NSInteger = 1
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        requestUserArray.removeAllObjects()
        pageNo = 1
        callApiForPendingRequest(1)
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Methods
    func customInit() {
        self.navigationItem.title = "Requests"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        requeststableView.estimatedRowHeight = 100.0
        requeststableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return requestUserArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACRequestsTVCEllID", forIndexPath: indexPath) as! ACRequestsTVCEll
        let requestObj = requestUserArray.objectAtIndex(indexPath.row) as! ACUserInfo
        cell.userNameLabel.text = requestObj.userName
        cell.userProfileImageView.sd_setImageWithURL(NSURL(string:requestObj.userImage), placeholderImage: UIImage(named: "user"))
        cell.infoHandelsLabel.text = requestObj.infoHandels
        cell.descriptionLabel.text = requestObj.userDescription
        cell.acceptButton.tag = 100 + indexPath.row
        cell.declineButton.tag = 5000 + indexPath.row
         cell.acceptButton.addTarget(self, action: #selector(acceptButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.declineButton.addTarget(self, action: #selector(declineButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }

    //MARK:- Tableview Delegate Methods
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40.0 && pageNo < maxPageNo+1) {
            pageNo += 1
            callApiForPendingRequest(pageNo)
        }
    }
    

    //MARK:- Cell Button Action Methods
     @objc func acceptButtonAction(button : UIButton) {
        let alertController = UIAlertController(title: "Add a keyword", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.Keyword = firstTextField.text!
            let requestObj = self.requestUserArray.objectAtIndex(button.tag - 100) as! ACUserInfo
            self.callApiForAcceptRequest(requestObj.userID)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter keyword"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @objc func declineButtonAction(button : UIButton) {
        AlertController.alert("", message: "Are you sure you want to decline this user's request?", buttons: ["Yes","NO"], tapBlock: { (alertAction, position) -> Void in
            if position == 0 {
                let requestObj = self.requestUserArray.objectAtIndex(button.tag - 5000) as! ACUserInfo
                self.callApiForDeclineRequest(requestObj.userID)
            }
        })
       
    }
    
    //MARK:- Web API Methods
    func callApiForPendingRequest(pageNumber : NSInteger) {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            let params: [String : AnyObject] = [
                "user": dict ,
                "page" : pageNumber
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "request_apis/pending_request", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.requestUserArray.addObjectsFromArray( ACUserInfo.getRequestList(res) as [AnyObject])
                        self.maxPageNo = res.objectForKeyNotNull("total_pages", expected: 1) as! NSInteger
                        self.requeststableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }

    func callApiForAcceptRequest(friendID : String) {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            print(NSUserDefaults.standardUserDefaults().valueForKey("ACUserID"))
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACFriendId] = friendID
            dict[ACKeyword] = Keyword
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "request_apis/accept_request", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.requestUserArray.removeAllObjects()
                        self.pageNo = 1
                        self.callApiForPendingRequest(self.pageNo)
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForDeclineRequest(friendID : String) {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACFriendId] = friendID
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "request_apis/reject_request", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        AlertController.alert("", message:res.objectForKeyNotNull("responseMessage", expected: "") as! String, buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
                            if position == 0 {
                                self.requestUserArray.removeAllObjects()
                                self.pageNo = 1
                                self.callApiForPendingRequest(self.pageNo)
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
