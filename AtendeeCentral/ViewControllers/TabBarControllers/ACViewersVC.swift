//
//  ACViewersVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACViewersVC: UIViewController {

    var  viewersArray = NSMutableArray()
    var  recentArray = NSMutableArray()
    var pageNo : NSInteger = 1
    var maxPageNo : NSInteger = 1
    
    @IBOutlet var viewersTableView: UITableView!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customMethod()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        viewersArray.removeAllObjects()
        pageNo = 1
        callApiForViewersList(pageNo)
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Method
    func customMethod() {
        self.navigationItem.title = "People Who Viewed Your Profile"
        self.navigationItem.leftBarButtonItem = self.leftBarButton("backArrow")
        viewersTableView.estimatedRowHeight = 100.0
        viewersTableView.rowHeight = UITableViewAutomaticDimension
      
    }
    
    func getFormattedDate(strDate : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.dateFromString(strDate)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.stringFromDate(date!)
    }
    
    func leftBarButton(imageName : NSString) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setImage(UIImage(named: imageName as String), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(leftBarButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
    }
   
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Tableview Datasource And Deleagte Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewersArray.count
          }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
//            let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 0))
////            let label = UILabel(frame: CGRectMake(10, 10, tableView.bounds.size.width, 30))
//            headerView.backgroundColor = UIColor.darkGrayColor()
////            label.text = "People who viewed your profile"
////            label.textColor = UIColor.whiteColor()
////            headerView.addSubview(label)
//            
            return nil
        } else {
            let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 40))
            let label = UILabel(frame: CGRectMake(10, 10, tableView.bounds.size.width, 30))
            headerView.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            label.text = "Last Scanned Codes/Recently Followed"
            label.textColor = UIColor.darkGrayColor()
            headerView.addSubview(label)
            
            return headerView
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 50
    }
    
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 77
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("ACViewersTVCellID", forIndexPath: indexPath) as! ACViewersTVCell
            getRoundImage(cell.viewersImgView)
            cell.messageButton.hidden = true
            let viewersObj = viewersArray.objectAtIndex(indexPath.row) as! ACUserInfo
            cell.viewersImgView.sd_setImageWithURL(NSURL(string:viewersObj.userImage), placeholderImage: UIImage(named: "user"))
            cell.viewersUserName.text = viewersObj.userName
            if viewersObj.isPending {
                cell.selectionButton.setTitle("Pending", forState: .Normal)
                cell.selectionButton.userInteractionEnabled = false
            } else {
                cell.selectionButton.selected =  viewersObj.isFriend
                cell.selectionButton.userInteractionEnabled = true
                cell.messageButton.hidden = !viewersObj.isFriend
            }
            
            cell.dateLabel.text = getFormattedDate(viewersObj.date)
            cell.selectionButton.tag = indexPath.row + 100
            cell.messageButton.tag = indexPath.row + 1000
            cell.selectionButton.addTarget(self, action: #selector(viewersSelectionButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.messageButton.addTarget(self, action: #selector(messageSelectionButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return cell

        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ACViewersCellID", forIndexPath: indexPath) as! ACViewersTVCell
            getRoundImage(cell.viewersImgView)
            let viewersObj = viewersArray.objectAtIndex(indexPath.row) as! ACUserInfo
            cell.messageButton.hidden = true
            cell.viewersImgView.sd_setImageWithURL(NSURL(string:viewersObj.userImage), placeholderImage: UIImage(named: "user"))
            cell.viewersUserName.text = viewersObj.userName
            cell.selectionButton.selected =  viewersObj.isFriend
            cell.selectionButton.tag = indexPath.row + 1000
            cell.selectionButton.addTarget(self, action: #selector(recentSelectionButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            cell.messageButton.addTarget(self, action: #selector(messageSelectionButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40.0 && pageNo < maxPageNo+1) {
            pageNo += 1
            callApiForViewersList(pageNo)
        }
    }
    
    //MARK:- UIButton Action Methods
    @objc func viewersSelectionButtonAction(sender: UIButton) {
         let viewersObj = viewersArray.objectAtIndex(sender.tag - 100) as! ACUserInfo
        viewersObj.isFriend = !viewersObj.isFriend
        if (viewersObj.isFriend) {
        callApiForFollowUser(viewersObj.userID)
        } else {
             callApiForDeclineRequest(viewersObj.userID)
        }
    }
    
    func messageSelectionButtonAction(sender: UIButton) {
        let chatVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACChatVCID") as! ACChatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func recentSelectionButtonAction(sender: UIButton) {
        print(sender.tag)
        let dict : NSDictionary = recentArray[sender.tag - 1000]  as! NSDictionary
        dict.setValue(!sender.selected, forKey: "isSelected")
        recentArray.replaceObjectAtIndex(sender.tag-1000, withObject: dict)
        viewersTableView.reloadData()
    }

    //MARK:- Web API Methods
    func callApiForViewersList(pageNo:NSInteger) {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            let params: [String : AnyObject] = [
                "user": dict ,
                "page" : pageNo,
                ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "event_apis/profile_view", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.viewersArray.addObjectsFromArray(ACUserInfo.getViewersList(res) as [AnyObject])
//                        self.maxPageNo = res.objectForKeyNotNull("total_pages", expected: 0) as! NSInteger
                        self.viewersTableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForFollowUser(strFriendID : String) {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            print(NSUserDefaults.standardUserDefaults().valueForKey("ACUserID"))
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACFriendId] = strFriendID
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "request_apis/send_request", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.viewersArray.removeAllObjects()
                        self.pageNo = 1
                        self.callApiForViewersList(self.pageNo)
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
                                self.viewersArray.removeAllObjects()
                                self.pageNo = 1
                                self.callApiForViewersList(self.pageNo)
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
