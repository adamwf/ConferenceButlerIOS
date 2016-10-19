//
//  ACInboxVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACInboxVC: UIViewController {
    
    var  messageListArray = NSMutableArray()
    //message list properties
    @IBOutlet var messageListTableView: UITableView!
    @IBOutlet var messageListTextField: UITextField!
    var pageNo : NSInteger = 1
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
        // Do any additional setup after loading the view.
    }
      
    override func viewWillAppear(animated: Bool) {
//        NSNotificationCenter.defaultCenter().postNotificationName("tabViewChangeNotification", object: nil,userInfo:["hiddenTrue" : "1"] )
        pageNo = 1
        messageListTextField.text = ""
        super.viewWillAppear(animated)
        self.messageListArray.removeAllObjects()
        callApiForMessageList(pageNo)
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Message List"
        messageListTableView.keyboardDismissMode = .Interactive
        messageListTableView.estimatedRowHeight = 100.0
        messageListTableView.rowHeight = UITableViewAutomaticDimension
        messageListTextField.attributedPlaceholder = NSAttributedString(string:"Search Messages",
                                                                        attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        self.navigationItem.rightBarButtonItems = ACAppUtilities.rightBarButtonArray(["nav_ic5"],controller: self) as? [UIBarButtonItem]
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightBarButtonsAction(barbutton : UIButton) {
        self.view .endEditing(true)
        if barbutton.tag == 100 {
            let addFriendVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACAddFriendVCID") as! ACAddFriendVC
            self.navigationController?.pushViewController(addFriendVC, animated: true)
        }
    }
    
    // Dismiss keyboard when scrolling
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        messageListTextField.resignFirstResponder()
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonsAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getFormattedDate(strDate : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.dateFromString(strDate)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.stringFromDate(date!)
    }
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACInboxTVCellID", forIndexPath: indexPath) as! ACInboxTVCell
        let messageInfo = messageListArray.objectAtIndex(indexPath.row) as! ACUserInfo
        print(cell.messageListDate.text)
        cell.messageListDate.text = self.getFormattedDate(messageInfo.date)
        cell.userNameLabel.text = messageInfo.userName
        
        cell.messageListImageView.sd_setImageWithURL(NSURL(string:messageInfo.userImage), placeholderImage: UIImage(named: "user"))
        cell.messageListLabelDescription.text = messageInfo.message
        return cell
    }
    
    //MARK:- Tableview Deleagte Methods
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40.0) {
            pageNo += 1
            callApiForMessageList(pageNo)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        let chatVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACChatVCID") as! ACChatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    // MARK: TextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    
    //MARK:- Web API Methods
    func callApiForMessageList(pageNo:NSInteger) {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            let params: [String : AnyObject] = [
                "user": dict ,
                "page" : pageNo,
                ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "event_apis/notification_list", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        
                        self.messageListArray.addObjectsFromArray(ACUserInfo.getMessageList(res) as [AnyObject])
                        self.messageListTableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }

}
