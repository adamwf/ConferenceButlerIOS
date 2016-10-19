//
//  ACGABUserProfileVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 09/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import AddressBook

class ACGABUserProfileVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var  userProfileArray = NSMutableArray()
    var socialLoginArray = NSMutableArray()
    
    var strQRCode : String = ""
    //header properties
    @IBOutlet var gabScreenHeaderView: UIView!
    @IBOutlet var gabScreenFooterView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var emailIdLabel: UILabel!
    @IBOutlet var phoneNoLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var viewSocialCodeButtonProperty: UIButton!
    @IBOutlet var gabScreenTableView: UITableView!
    
    var customAlertView = ACFollowAlert()
    var userInfo = ACUserInfo()
    var strUserID : String!
    var isFromQRCode : Bool!
       
    //MARK:- Viewe Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
        self.gabScreenTableView.tableFooterView = self.gabScreenFooterView;
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
         self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        self.navigationItem.rightBarButtonItems = ACAppUtilities.rightBarButtonArray(["nav_ic6"],controller: self) as? [UIBarButtonItem]
        gabScreenTableView.estimatedRowHeight = 100
        gabScreenTableView.rowHeight = UITableViewAutomaticDimension
        getRoundImage(userImageView)
        if isFromQRCode == true {
            self.callApiForProfile()
        } else {
            callApiForViewProfile(strUserID)
        }
    }

    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    func rightBarButtonsAction(button : UIButton) {
        print(button.tag)
        let mapVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACMapVCID") as! ACMapVC
        mapVC.addressStr = addressLabel.text!
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    //MARK:- Tableview Datasource And Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.socialUserNameArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let socialUserName = userInfo.socialUserNameArray.objectAtIndex(indexPath.row) as! String
        let cell = tableView.dequeueReusableCellWithIdentifier("ACDirectoryHandlerTVCellID", forIndexPath: indexPath) as! ACDirectoryHandlerTVCell

        switch indexPath.row {
        case 0:
            cell.socialMediaImgView.image = UIImage(named:"icon1")
            cell.socialMediaName.text = "LinkedIn"
             cell.gabScreenUserName.text = socialUserName
            break
        case 1:
            cell.socialMediaImgView.image = UIImage(named:"icon2")
            cell.socialMediaName.text = "Facebook"
            cell.gabScreenUserName.text = socialUserName
            break
        case 2:
            cell.socialMediaImgView.image = UIImage(named:"s16")
            cell.socialMediaName.text = "Google+"
            cell.gabScreenUserName.text = socialUserName
            break
        case 3:
            cell.socialMediaImgView.image = UIImage(named:"s11")
            cell.socialMediaName.text = "Instagram"
            cell.gabScreenUserName.text = socialUserName
            break
        default:
            cell.socialMediaImgView.image = UIImage(named:"s8")
            cell.socialMediaName.text = "Twitter"
            cell.gabScreenUserName.text = socialUserName
            break
        }
                return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    } 
    
    //MARK:- UIButton Action Methods
    @IBAction func mapButtonAction(sender: UIButton) {
    }
    
    @IBAction func followButtonAction(sender: UIButton) {
           callApiForFollowUser()
    }
    
    @IBAction func viewSocialCodeButtonAction(sender: UIButton) {
        self.addUserToAddressBook(self.userInfo)
    }
    
    @IBAction func gabImportButtonAction(sender: UIButton) {
        AlertController.alert("Work in Progress")
    }
    
    @IBAction func viewAttendeeButtonAction(sender: UIButton) {
        AlertController.alert("Work in Progress")
    }

    func addUserToAddressBook(contact: ACUserInfo){
        let stat = ABAddressBookGetAuthorizationStatus()
        switch stat {
        case .Denied, .Restricted:
            print("no access to addressbook")
        case .Authorized, .NotDetermined:
            var err : Unmanaged<CFError>? = nil
            let adbk : ABAddressBook? = ABAddressBookCreateWithOptions(nil, &err).takeRetainedValue()
            if adbk == nil {
                print(err)
                return
            }
            ABAddressBookRequestAccessWithCompletion(adbk) {
                (granted:Bool, err:CFError!) in
                if granted {
                    let newContact:ABRecordRef! = ABPersonCreate().takeRetainedValue()
                    var success:Bool = false
                    
                    //Updated to work in Xcode 6.1
                    var error: Unmanaged<CFErrorRef>? = nil
                    //Updated to error to &error so the code builds in Xcode 6.1
                    success = ABRecordSetValue(newContact, kABPersonFirstNameProperty, contact.userFName, &error)
                    print("Setting first name was successful? \(success)")
                    success = ABRecordSetValue(newContact, kABPersonLastNameProperty, self.userInfo.userLName, &error)
                    print("Setting last name was successful? \(success)")
                    success = ABRecordSetValue(newContact, kABPersonJobTitleProperty, "", &error)
                    print("Setting job title was successful? \(success)")
                    
                    if(contact.userPhone != "") {
                        let propertyType: NSNumber = kABMultiStringPropertyType
                        
                        let phoneNumbers: ABMutableMultiValueRef =  self.createMultiStringRef()
                        let phone = contact.userPhone.stringByReplacingOccurrencesOfString(" ", withString: "") as NSString
                        
                        ABMultiValueAddValueAndLabel(phoneNumbers, phone, kABPersonPhoneMainLabel, nil)
                        success = ABRecordSetValue(newContact, kABPersonPhoneProperty, phoneNumbers, &error)
                        print("Setting phone number was successful? \(success)")
                        
                    }
                    success = ABRecordSetValue(newContact, kABPersonNoteProperty, "added via wildcard - getwildcard.co", &error)
                    success = ABAddressBookAddRecord(adbk, newContact, &error)
                    print("Contact added successful? \(success)")
                    success = ABAddressBookSave(adbk, &error)
                    print("Saving addressbook successful? \(success)")
                    
                } else {
                    print(err)
                }
            }
        }
    }

    func createMultiStringRef() -> ABMutableMultiValueRef {
        let propertyType: NSNumber = kABMultiStringPropertyType
        return Unmanaged.fromOpaque(ABMultiValueCreateMutable(propertyType.unsignedIntValue).toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    }

    //MARK:- Web API Methods
    
    func callApiForFollowUser() {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            print(NSUserDefaults.standardUserDefaults().valueForKey("ACUserID"))
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACFriendId] = strUserID
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
                        AlertController.alert("", message: res.objectForKeyNotNull("responseMessage", expected: "") as! String, buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
                            if position == 0 {
                               
                            }
                        })

                    self.gabScreenTableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForProfile() {
        if kAppDelegate.hasConnectivity() {
            let params: [String : AnyObject] = [
                ACUserId: NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")! ,
                ACQRCode : strQRCode
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "event_apis/scan_qr", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.userInfo = ACUserInfo.getProfileInfo(res.objectForKeyNotNull("user", expected: NSDictionary())as! NSDictionary)
                        self.navigationItem.title = self.userInfo.userName
                        self.nameLabel.text = self.userInfo.userName
                        self.emailIdLabel.text = self.userInfo.userEmail
                        self.phoneNoLabel.text = self.userInfo.userPhone
                        self.addressLabel.text = self.userInfo.userAddress
                        self.userImageView.sd_setImageWithURL(NSURL(string: self.userInfo.userImage), placeholderImage: UIImage(named: "user"))
                        self.gabScreenTableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }

    func callApiForViewProfile(friendID : String) {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")!
            dict[ACFriendId] = friendID
            let params: [String : AnyObject] = [
                "user": dict ,
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "request_apis/profile_view", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.userProfileArray.addObject(ACUserInfo.getProfileInfo(res.objectForKeyNotNull("user", expected: NSDictionary())as! NSDictionary))
                        self.userInfo = ACUserInfo.getProfileInfo(res.objectForKeyNotNull("user", expected: NSDictionary())as! NSDictionary)
                        self.navigationItem.title = String(format:"GAB Screen <%@>",self.userInfo.userName)
                        self.nameLabel.text = self.userInfo.userName
                        self.emailIdLabel.text = self.userInfo.userEmail
                        self.phoneNoLabel.text = self.userInfo.userPhone
                        self.addressLabel.text = self.userInfo.userAddress
                        self.userImageView.sd_setImageWithURL(NSURL(string:self.userInfo.userImage), placeholderImage: UIImage(named: "user"))
                        
                        self.gabScreenTableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
}
