//
//  ACGABDirectoryVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 13/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACGABDirectoryVC: UIViewController {
    
    var  gabUserArray = NSMutableArray()
    var pageNo : NSInteger = 1
    var selectedArray = NSMutableArray()
    
    @IBOutlet var selectAllButton: UIButton!
    @IBOutlet var gabDirectoryTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        gabUserArray.removeAllObjects()
         pageNo = 1
        callApiForGabDirectory(pageNo)
    }

    //MARK:- Memory management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark:- Helper Methods
    func customInit() {
        self.navigationItem.title = "GAB Directory"
        self.navigationItem.leftBarButtonItem =  ACAppUtilities.leftBarButton("backArrow",controller: self)
        self.navigationItem.rightBarButtonItems = ACAppUtilities.rightBarButtonArray(["nav_ic13",],controller: self) as? [UIBarButtonItem]
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightBarButtonsAction(barbutton : UIButton) {
        print(selectedArray)
        for case let item as ACFriendsInfo in selectedArray {
            if item.isSelectedUserFriend {
                let groupVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACGroupVCID") as! ACGroupVC
                groupVC.groupUsersArray = selectedArray
                               self.navigationController?.pushViewController(groupVC, animated: true)
                return
            }
        }
    }

    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gabUserArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACGABUserTVCellID", forIndexPath: indexPath) as! ACGABUserTVCell
        let friendsObj = gabUserArray [indexPath.row] as! ACFriendsInfo
        cell.nameLabel.text = friendsObj.userName
        cell.userImageView.image = UIImage(named: friendsObj.userImage)
        cell.userNameLabel.text = friendsObj.userName
        cell.userEmailIdLabel.text = friendsObj.userEmail
        cell.messageButton.selected = friendsObj.isSelectedUserFriend
        
        return cell
    }
    
    //MARK:- Tableview Delegate Methods
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        
//        let friendsObj = gabUserArray.objectAtIndex(indexPath.row) as! ACFriendsInfo
//        friendsObj.isSelectedUserFriend = !friendsObj.isSelectedUserFriend
//        selectedArray.removeAllObjects()
        
        let friendsObj = gabUserArray.objectAtIndex(indexPath.row) as! ACFriendsInfo
        selectAllButton.selected = false
        friendsObj.isSelectedUserFriend = !friendsObj.isSelectedUserFriend
        for case let item as ACFriendsInfo in gabUserArray {
                        if item.isSelectedUserFriend == true {
                            selectedArray.addObject(item)
                        }
                    }
        gabDirectoryTableView.reloadData()
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40.0) {
            pageNo += 1
            callApiForGabDirectory(pageNo)
        }
    }

    //MARK:- UIButton Action Methods
    @IBAction func selectAllButtonAction(sender: UIButton) {
        for case let friendsObj as ACFriendsInfo in gabUserArray {
            friendsObj.isSelectedUserFriend = true
        }
        selectAllButton.selected = true
        gabDirectoryTableView.reloadData()
    }
    
    //MARK:- Web API Methods
    func callApiForGabDirectory(pageNo:NSInteger) {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict["keyword"] = ""
            let params: [String : AnyObject] = [
                "user": dict ,
                "page" : pageNo,
                "sort" : "first_name"
                //                    "device_id" : "65r34r346r6rt43r76t6"
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "request_apis/contact_list", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.gabUserArray.addObjectsFromArray(ACFriendsInfo.getFriendList(res) as [AnyObject])
                        self.gabDirectoryTableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    

}
