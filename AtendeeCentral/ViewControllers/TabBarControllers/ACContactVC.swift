//
//  ACContactVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACContactVC: UIViewController {
    
    var  userProfileArray = NSMutableArray()
    var pickerDataSource = ["Name", "Email", "Username"];
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var sortButton: UIButton!
    
    @IBOutlet weak var gabTblView: UITableView!
    
    @IBOutlet weak var blurBgView: UIView!
    
    @IBOutlet weak var sortPickerView: UIPickerView!
    
    var sortingKey : String = ""
    var pageNo : NSInteger = 1
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.userProfileArray.removeAllObjects()
        pageNo = 1
        sortingKey = "first_name"
        searchTextField.text = ""
        sortButton.setTitle("Name", forState: .Normal)
        callApiForContactList(pageNo)
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark:- Helper Methods
    func customInit() {
        self.navigationItem.title = "Global Address Book"
        sortButton.layer.cornerRadius = 5
        sortButton.clipsToBounds = true
       
        let padView =  UIView(frame: CGRectMake(0, 0, 10, searchTextField.frame.size.height))
        searchTextField.leftView = padView;
        searchTextField.leftViewMode = UITextFieldViewMode.Always
        searchTextField.attributedPlaceholder = NSAttributedString(string: searchTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor() ,NSFontAttributeName : KAppRegularFont])
        gabTblView.estimatedRowHeight = 100
        gabTblView.rowHeight = UITableViewAutomaticDimension
        sortButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
    
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfileArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACGABUserTVCellID", forIndexPath: indexPath) as! ACGABUserTVCell
        let contactInfo = userProfileArray.objectAtIndex(indexPath.row) as! ACUserInfo
        cell.nameLabel.text = contactInfo.userFName
        cell.userImageView.sd_setImageWithURL(NSURL(string:contactInfo.userImage), placeholderImage: UIImage(named: "user"))
        cell.userNameLabel.text = contactInfo.userName
        cell.userEmailIdLabel.text = contactInfo.userEmail
        cell.messageButton.addTarget(self, action: #selector(messageButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)

//        cell.messageLabel.text = "Message"
        return cell
    }
    
    //MARK:- Tableview Delegate Methods
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
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
        blurBgView.hidden = false
    }
    
    //MARK:- Cell Button Action Methods
    @objc func messageButtonAction(button : UIButton) {
        let chatVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACChatVCID") as! ACChatVC
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
    @IBAction func toolBarDoneButtonAction(sender: UIBarButtonItem) {
        blurBgView.hidden = true
        userProfileArray.removeAllObjects()
//        searchTextField.text = ""
        if sortButton.titleLabel?.text == "Name" {
            sortingKey = "first_name"
        } else if sortButton.titleLabel?.text == "Email" {
            sortingKey = "email"
        } else {
            sortingKey = "user_name"
        }
        pageNo = 1
        callApiForContactList(pageNo)
    }
    
    // MARK: TextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view .endEditing(true)
        pageNo = 1
        userProfileArray.removeAllObjects()
        callApiForContactList(pageNo)
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
                        self.userProfileArray.addObjectsFromArray(ACUserInfo.getContactInfo(res) as [AnyObject])
                        self.gabTblView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }

}
