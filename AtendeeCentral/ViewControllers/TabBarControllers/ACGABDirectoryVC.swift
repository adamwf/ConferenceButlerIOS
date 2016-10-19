//
//  ACGABDirectoryVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 13/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACGABDirectoryVC: UIViewController {

    let dict: NSMutableDictionary? = [
        "userID" : "100",
        "userName" : "Kris Stewart",
        "userDetail" : "Fb Username",
        "userEmail" : "abc@xyz.com",
        "userImage" : "user1",
        "userStatus" : 0
    ]
    
    let dict1: NSMutableDictionary? = [
        "userID" : "100",
        "userName" : "Angela William",
        "userDetail" : "Insta USername",
        "userEmail" : "abc@xyz.com",
        "userImage" : "user2",
        "userStatus" : 0
    ]
    
    let dict2: NSMutableDictionary? = [
        "userID" : "100",
        "userName" : "Angela William",
        "userDetail" : "Insta USername",
        "userEmail" : "abc@xyz.com",
        "userImage" : "user2",
        "userStatus" : 0
    ]

    
    var  gabUserArray = NSMutableArray()

    @IBOutlet var selectAllButton: UIButton!
    @IBOutlet var gabDirectoryTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        self.getDummyData()
    }

    func getDummyData() {
        
        let tempArray : NSMutableArray = [dict!,dict1!,dict2!]
        let response = NSMutableDictionary()
        response.setValue(tempArray, forKey: "userArray")
        
        gabUserArray = ACFriendsInfo.getFriendList(response)
        gabDirectoryTableView.reloadData()
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightBarButtonsAction(barbutton : UIButton) {
        let groupChatVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACGroupChatVCID") as! ACGroupChatVC
        self.navigationController?.pushViewController(groupChatVC, animated: true)
    }

    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gabUserArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACGABUserTVCellID", forIndexPath: indexPath) as! ACGABUserTVCell
        let friendsObj = gabUserArray [indexPath.row] as! ACFriendsInfo
//        let obj = gabUserArray.objectAtIndex(indexPath.row)

        cell.nameLabel.text = friendsObj.userName
        cell.userImageView.image = UIImage(named: friendsObj.userImage)
        cell.userNameLabel.text = friendsObj.userName
        cell.userEmailIdLabel.text = friendsObj.userEmail
        cell.messageButton.selected = friendsObj.userStatus

        return cell
    }
    
    //MARK:- Tableview Delegate Methods
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendsObj = gabUserArray.objectAtIndex(indexPath.row) as! ACFriendsInfo
        selectAllButton.selected = false
        friendsObj.userStatus = !friendsObj.userStatus
        gabDirectoryTableView.reloadData()
    }

    //MARK:- UIButton Action Methods
    @IBAction func selectAllButtonAction(sender: UIButton) {
        for case let friendsObj as ACFriendsInfo in gabUserArray {
            friendsObj.userStatus = true
        }
        selectAllButton.selected = true
        gabDirectoryTableView.reloadData()
    }
    
}
