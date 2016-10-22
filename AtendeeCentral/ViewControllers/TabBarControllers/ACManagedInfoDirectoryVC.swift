//
//  ACManagedInfoDirectoryVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACManagedInfoDirectoryVC: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var profileImgView: UIImageView!
    var isFromDirectory = Bool()
    var  manageInfoDictArray = NSMutableArray()
    var  manageInfoDirectoryArray = NSMutableArray()
    
    @IBOutlet var manageInfoDirectoryTableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var showInDirectoryButton: UIButton!
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
        callApiForGetPrivacyStatus()
        getRoundImage(profileImgView)
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Mehtods
    func customInit() {
        manageInfoDirectoryTableView.estimatedRowHeight = 100.0
        manageInfoDirectoryTableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = isFromDirectory ? "Manage Info Directory" : "Manage Info Search"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Tableview Datasource And Deleagte Methods
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 11
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < 6{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("ACManageInfoUserDetailsTVCellID", forIndexPath: indexPath) as! ACManageInfoUserDetailsTVCell
            
            let userInfo = manageInfoDictArray [0] as! ACUserInfo
            switch indexPath.row {
            case 0:
                cell.manageUserName.text = "Name"
                cell.manageUserDirectoryButton.selected = userInfo.isName
                break
            case 1:
                cell.manageUserName.text = "Phone Number"
                cell.manageUserDirectoryButton.selected = userInfo.isPhone
                break
            case 2:
                cell.manageUserName.text = "Email Address"
                cell.manageUserDirectoryButton.selected = userInfo.isEmail
                break
            case 3:
                cell.manageUserName.text = "Address"
                cell.manageUserDirectoryButton.selected = userInfo.isAddress
                break
            case 4:
                cell.manageUserName.text = "Hobbies"
                cell.manageUserDirectoryButton.selected = userInfo.isHobbies
                break
            default:
                cell.manageUserName.text = "OtherInfo"
                cell.manageUserDirectoryButton.selected = userInfo.isOtherInfo
                break
            }
            cell.manageUserDirectoryButton.tag = indexPath.row
//            cell.manageUserDirectoryButton .addTarget(self, action: #selector(ACManagedInfoDirectoryVC.buttonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            let boolValue = dict1["isSelection"] as? Bool
//            cell.manageUserDirectoryButton.selected = boolValue!
            return cell
            
        } else  {
            let cell = tableView.dequeueReusableCellWithIdentifier("ACAddSocialHandlerTVCellID", forIndexPath: indexPath) as! ACAddSocialHandlerTVCell
            let userInfo = manageInfoDictArray [0] as! ACUserInfo
            
            switch indexPath.row {
            case 6:
                cell.socialName.text = "LinkedIn"
                cell.socialImageView.image = UIImage(named: "icon1")
                cell.socialButton.selected = userInfo.islinkedIn
                break
            case 7:
                cell.socialName.text = "Facebook"
                cell.socialImageView.image = UIImage(named: "icon2")
                cell.socialButton.selected = userInfo.isFacebook
                break
            case 8:
                cell.socialName.text = "Google"
                cell.socialImageView.image = UIImage(named: "s16")
                cell.socialButton.selected = userInfo.isGoogle
                break
            case 9:
                cell.socialName.text = "Instagram"
                cell.socialImageView.image = UIImage(named: "s11")
                cell.socialButton.selected = userInfo.isInstagram
                break
            default:
                cell.socialName.text = "Twitter"
                cell.socialImageView.image = UIImage(named: "s8")
                cell.socialButton.selected = userInfo.isTwitter
                break
            }
//            cell.socialImageView.sd_setImageWithURL(NSURL(string: userInfo.userImage), placeholderImage: UIImage(named: "user"))
            cell.socialButton.tag = indexPath.row
//            cell.socialButton .addTarget(self, action: #selector(ACManagedInfoDirectoryVC.buttonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
          let userInfo = manageInfoDictArray [0] as! ACUserInfo
        switch indexPath.row {
        case 0:
           userInfo.isName = !userInfo.isName
            break
        case 1:
           userInfo.isPhone = !userInfo.isPhone
            break
        case 2:
            userInfo.isEmail = !userInfo.isEmail
            break
        case 3:
            userInfo.isAddress = !userInfo.isAddress
            break
        case 4:
            userInfo.isHobbies = !userInfo.isHobbies
            break
        case 5:
            userInfo.isOtherInfo = !userInfo.isOtherInfo
            break
        case 6:
            userInfo.islinkedIn = !userInfo.islinkedIn
            break
        case 7:
            userInfo.isFacebook = !userInfo.isFacebook
            break
        case 8:
            userInfo.isGoogle = !userInfo.isGoogle
            break
        case 9:
            userInfo.isInstagram = !userInfo.isInstagram
            break
        default:
            userInfo.isTwitter = !userInfo.isTwitter
            break
        }
        manageInfoDirectoryTableView.reloadData()
    }

    //Mark:- UIButton Actions
    @IBAction func saveButtonAction(sender: AnyObject) {
        callApiForUpdatePrivacyStatus()
    }
    
    @IBAction func showInDirectoryButtonAction(sender: AnyObject) {
        showInDirectoryButton.selected = !showInDirectoryButton.selected
         let userInfo = manageInfoDictArray [0] as! ACUserInfo
        userInfo.isImage = !userInfo.isImage
    }
    
//    func buttonAction(sender : UIButton ) -> Void {
//        if sender.tag < 6 {
//            let dict1 : NSDictionary = manageInfoDictArray [sender.tag] as! NSDictionary
//            dict1.setValue(!sender.selected, forKey: "isSelection")
//            manageInfoDictArray.replaceObjectAtIndex(sender.tag, withObject: dict1)
//        } else {
//            sender.selected = !sender.selected
//            let dict1 : NSDictionary = manageInfoDirectoryArray [sender.tag - 6] as! NSDictionary
//            dict1.setValue(!sender.selected, forKey: "isSelected")
//            manageInfoDirectoryArray.replaceObjectAtIndex(sender.tag - 6, withObject: dict1)
//        }
//        
//        manageInfoDirectoryTableView.reloadData()
//    }
    
    //MARK:- Web API Methods
    func callApiForGetPrivacyStatus() {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACPrivacyType] = isFromDirectory ? "register_user" : "search_engine"
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/get_privacy_status", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.manageInfoDictArray.addObject(ACUserInfo.getGABDirectoryInfo(res))
                       self.showInDirectoryButton.selected = (res.objectForKeyNotNull("privacy_status", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("image", expected: 0) as! Bool
                        self.manageInfoDirectoryTableView.delegate = self
                        self.manageInfoDirectoryTableView.dataSource = self
                        self.manageInfoDirectoryTableView.reloadData()
                        //                       self.optInButton.selected = res.objectForKeyNotNull("user_availability", expected: "").boolValue
                        
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForUpdatePrivacyStatus() {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            let status = NSMutableDictionary()
             let userInfo = manageInfoDictArray [0] as! ACUserInfo
            status[ACIsName] = userInfo.isName
            status[ACHobbies] = userInfo.isHobbies
            status[ACEmail] = userInfo.isEmail
            status[ACPhone] = userInfo.isPhone
            status[ACAddress] = userInfo.isAddress
            status[ACOtherInfo] = userInfo.isOtherInfo
            status[ACUserImage] = showInDirectoryButton.selected ? true : false
            status[ACRelationStatus] = true
            status[ACChildren] = true
            status[ACUserImage] = userInfo.isImage
            status[ACSocialCode] = true
            status[ACIsGoogle] = userInfo.isGoogle
            status[ACIsFacebook] = userInfo.isFacebook
            status[ACIsTwitter] = userInfo.isTwitter
            status[ACIsInstagram] = userInfo.isInstagram
            status[ACIsLinkedIn] = userInfo.islinkedIn
            status[ACPrivacyType] = isFromDirectory ? "register_user" : "search_engine"
            let params: [String : AnyObject] = [
                "user": dict ,
                "status" : status
                ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/update_privacy_status", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }

}
