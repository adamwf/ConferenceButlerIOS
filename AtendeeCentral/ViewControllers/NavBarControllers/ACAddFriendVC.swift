//
//  ACAddFriendVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACAddFriendVC: UIViewController,customGroupDelegate {

//    let dict: NSMutableDictionary? = [
//        "userID" : "100",
//        "userName" : "Kris Stewart",
//        "userDetail" : "Fb Username",
//        "userEmail" : "abc@xyz.com",
//        "userImage" : "user1",
//        "userStatus" : 0
//        ]
//    
//    let dict1: NSMutableDictionary? = [
//        "userID" : "100",
//        "userName" : "Angela William",
//        "userDetail" : "Insta USername",
//        "userEmail" : "abc@xyz.com",
//        "userImage" : "user2",
//        "userStatus" : 0
//        ]
//    
//    let dict2: NSMutableDictionary? = [
//        "userID" : "100",
//        "userName" : "Angela William",
//        "userDetail" : "Insta USername",
//        "userEmail" : "abc@xyz.com",
//        "userImage" : "user2",
//        "userStatus" : 0
//    ]
    
     var pickerDataSource = ["Name", "Email", "Username"];
    var  userProfileArray = NSMutableArray()
    var selectedArray = NSMutableArray()
    var sortingKey : String = ""
    var pageNo : NSInteger = 1
    var grpImg = UIImage()
    var grpName = String()
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var sortButton: UIButton!
    @IBOutlet weak var bgBlurView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      pageNo = 1
        searchTextField.text = ""
        sortingKey = "first_name"
        sortButton.setTitle("Name", forState: .Normal)
        userProfileArray.removeAllObjects()
         callApiForContactList(pageNo)
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark:- Helper Methods
    func customInit() {
        self.navigationItem.title = "Add Friends"
        sortButton.layer.cornerRadius = 5
        sortButton.clipsToBounds = true
        let padView =  UIView(frame: CGRectMake(0, 0, 10, searchTextField.frame.size.height))
        searchTextField.leftView = padView;
        searchTextField.leftViewMode = UITextFieldViewMode.Always
//        searchTextField.attributedPlaceholder = NSAttributedString(string: searchTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor() ,NSFontAttributeName : UIFont(name:"VarelaRound", size:16)!])
        addTableView.estimatedRowHeight = 100
        addTableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.leftBarButtonItem =  ACAppUtilities.leftBarButton("backArrow",controller: self)
        self.navigationItem.rightBarButtonItem = ACAppUtilities.rightBarButton("Next", controller: self)
    }

    //MARK:- Custom Delegate Methods
    func sendDataBack(selectedArray : NSMutableArray,groupImage: UIImage, groupName: String) {
        grpImg = groupImage
        grpName = groupName
        delay(0.5) {
            for case let item as ACFriendsInfo in selectedArray {
                for case let userObj as ACFriendsInfo in self.userProfileArray {
                    if item.userID == userObj.userID {
                        userObj.isSelectedUserFriend = true
                    }
                }
            }
            self.addTableView.reloadData()
        }
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func rightBarButtonAction(barbutton : UIButton) {
        self.view .endEditing(true)
        for case let item as ACFriendsInfo in selectedArray {
            if item.isSelectedUserFriend {
                let groupVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACGroupVCID") as! ACGroupVC
                groupVC.groupUsersArray = selectedArray
                groupVC.delegate = self
                groupVC.groupName = grpName
                groupVC.groupImage = grpImg
                self.navigationController?.pushViewController(groupVC, animated: true)
                return
            }
        }
//        AlertController.alert("Please select atleast one participant.")
    }

    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfileArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACGABUserTVCellID", forIndexPath: indexPath) as! ACGABUserTVCell
        let friendsObj = userProfileArray.objectAtIndex(indexPath.row) as! ACFriendsInfo
        cell.nameLabel.text = friendsObj.userName
        cell.userImageView.sd_setImageWithURL(NSURL(string:friendsObj.userImage), placeholderImage: UIImage(named: "user"))
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
        let friendsObj = userProfileArray.objectAtIndex(indexPath.row) as! ACFriendsInfo
        friendsObj.isSelectedUserFriend = !friendsObj.isSelectedUserFriend
        selectedArray.removeAllObjects()
        for case let item as ACFriendsInfo in userProfileArray {
            if item.isSelectedUserFriend == true {
                selectedArray.addObject(item)
            }
        }
        addTableView.reloadData()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40.0) {
            pageNo += 1
            callApiForContactList(pageNo)
        }
    }
    
    //MARK:- UIButton Actions
    @IBAction func sortButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        bgBlurView.hidden = false
    }
    
    @IBAction func doneToolbarButtonAction(sender: UIBarButtonItem) {
        bgBlurView.hidden = true
        userProfileArray.removeAllObjects()
        searchTextField.text = ""
        if sortButton.titleLabel?.text == "Name" {
            sortingKey = "first_name"
        } else if sortButton.titleLabel?.text == "Email" {
            sortingKey = "email"
        } else {
            sortingKey = "user_name"
        }
        callApiForContactList(pageNo)
    }
    
    //MARK:- Cell Button Action Methods
    @objc func messageButtonAction(button : UIButton) {
        AlertController.alert("Work in progress")
    }

    // MARK: TextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    
    //MARK: UIPicker Delegate Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        sortButton.setTitle(pickerDataSource[row], forState: .Normal)
        sortButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    //MARK:- Web API Methods
    func callApiForContactList(pageNo:NSInteger) {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict["keyword"] = searchTextField.text
            let params: [String : AnyObject] = [
                "user": dict ,
                "page" : pageNo,
                "sort" : sortingKey
                //                    "device_id" : "65r34r346r6rt43r76t6"
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "request_apis/contact_list", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.userProfileArray.addObjectsFromArray(ACFriendsInfo.getFriendList(res) as [AnyObject])
                        self.addTableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }

}
