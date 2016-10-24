//
//  ACEditAccountVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import TwitterKit
import AlamofireOauth2
import Alamofire

let instagramOauth2Settings = Oauth2Settings(
    baseURL: "https://api.instagram.com/v1/users/self",
    authorizeURL: "https://api.instagram.com/oauth/authorize",
    tokenURL: "https://api.instagram.com/oauth/access_token",
    redirectURL: "http://172.16.6.55:4000/sa/complete/instagram-oauth2/",
    clientID: "8cf147a30e8c42e5a25a5f04081cf9a9",
    clientSecret: "740870182da64beda2e8c036723f2561",
    scope: "basic"
)

// Minimal Alamofire implementation. For more info see https://github.com/Alamofire/Alamofire#crud--authorization
public enum InstagramRequestConvertible: URLRequestConvertible {
    
    static var baseURLString: String? = instagramOauth2Settings.baseURL
    static var OAuthToken: String?
    
    case Me()
    
    public var URLRequest: NSMutableURLRequest  {
        
        var urlString = ""
        if let token = InstagramRequestConvertible.OAuthToken {
            urlString = String(format: "%@/?access_token=%@",InstagramRequestConvertible.baseURLString!,token)
            
//            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let url = NSURL(string: urlString)!
        let mutableURLRequest = NSMutableURLRequest(URL: url)
        mutableURLRequest.HTTPMethod = "GET"
        
        print("urlString>>>>",   urlString)
        
        return mutableURLRequest
    }
}


enum alertValidation: Int {
    case alert_Empty = 0
    case alert_FirstNameInvalid
    case alert_LastNameInvalid
    case alert_EmailInvalid
    case alert_PhoneNoInvalid
    case alert_None
}

enum socialLogin : Int {
    case linkedIn = 0
    case facebook
    case google
    case instagram
    case twitter
}

class ACEditAccountVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GIDSignInDelegate,GIDSignInUIDelegate {
   
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileImgViewButton: UIButton!
    var editArray = NSMutableArray()
    var rowValue = 10
    var userObj : ACUserInfo!
    var alert:alertValidation = alertValidation(rawValue : 0)!
    var addSocialLogin : socialLogin = socialLogin(rawValue : 0)!
    var  editMyAccountArray = NSMutableArray()
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var socialLoginStatus : Bool = false
     var imageData = NSData()
    var socialObj = ACUserInfo()
    
    @IBOutlet var editMyAccountTableView: UITableView!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Method
    func customInit() {
        self.navigationItem.rightBarButtonItems = ACAppUtilities.rightBarButtonArray(["nav_ic13"],controller: self) as? [UIBarButtonItem]

        self.navigationItem.title = "Edit My Account"
        self.navigationItem.leftBarButtonItem = self.leftBarButton("backArrow")
        editMyAccountTableView.estimatedRowHeight = 50.0
        editMyAccountTableView.rowHeight = UITableViewAutomaticDimension
        profileImgView.sd_setImageWithURL(NSURL(string: userObj.userImage), placeholderImage: UIImage(named: "user"))
        for case let item as ACUserInfo in userObj.socialUserNameArray {
            if(item.socialProvider == "linkedin" && item.socialUserName != "") {
                socialObj.islinkedIn = item.islinkedIn
            } else if (item.socialProvider == "google" && item.socialUserName != "") {
                socialObj.isGoogle =  item.isGoogle
            } else if (item.socialProvider == "facebook" && item.socialUserName != "") {
                socialObj.isFacebook =  item.isFacebook
            } else if (item.socialProvider == "instagram" && item.socialUserName != "") {
                socialObj.isInstagram =  item.isInstagram
            } else if (item.socialProvider == "twitter" && item.socialUserName != ""){
                socialObj.isTwitter =  item.isTwitter
               
            }
        }
       
        getRoundButton(profileImgViewButton)
        getRoundImage(profileImgView)
        
    }
    
    func  addToolBar(name:NSString) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - 46, Window_Width, 46)
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(nextBarButtonAction(_:)))
        toolbarItems = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil),nextButton]
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.lightGrayColor()
        toolbar.setItems(toolbarItems, animated: false)
        return toolbar
    }
    
    func leftBarButton(imageName : NSString) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setImage(UIImage(named: imageName as String), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(leftBarButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
    }
    
    func rightBarButtonsAction(barbutton : UIButton) {
        self.view .endEditing(true)
        if  self.isAllFieldVerified() == alertValidation.alert_None {
            callApiForUpdateUser()
        } else {
            editMyAccountTableView.reloadData()
        }
       
    }

    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc func nextBarButtonAction(button : UIButton) {
        let kTextField = getViewWithTag(553, view: self.view) as? UITextField
        kTextField?.becomeFirstResponder()
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker?.delegate = self
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            picker?.navigationBar.tintColor = UIColor.whiteColor()
            self .presentViewController(picker!, animated: true, completion: nil)
        } else {
            openGallery()
        }
    }
    
    func openGallery() {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker?.delegate = self
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(picker!, animated: true, completion: nil)
            picker?.navigationBar.tintColor = UIColor.whiteColor()
        } else {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(profileImgViewButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker .dismissViewControllerAnimated(true, completion: nil)
        self.imageData = NSData()
        self.imageData = UIImagePNGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!)!
        profileImgView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        //        self.imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as? UIImage, 0.6)
        //sets the selected image to image view
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker .dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- GooglePlus Delegate Methods
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (user != nil) {
            let paramDict  =  NSMutableDictionary()
            paramDict.setValue(user.userID, forKey: "userID")
            paramDict.setValue(user.profile.name, forKey: "userName")
            paramDict.setValue(user.profile.email, forKey: "emailID")
            paramDict.setValue(String(format: "%@", user.profile.imageURLWithDimension(400)), forKey: "userImage")
            print("==========",paramDict)
            self.addSocialLogin = socialLogin.google
            callApiForSocialLogIn(paramDict, provider: "google")
        }
    }

    //MARK:- UIButton Actions Methods
    @IBAction func createFreeSocialCodeButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        self.callApiForGenerateQR()
    }
    
    @IBAction func profileImgtButtonAction(sender: UIButton) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(profileImgViewButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        
    }
    
    //MARK:- Tableview Datasource And Deleagte Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (section == 0) {
            return 7
        } else {
            return 5
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
//            if (indexPath.row == 7 || indexPath.row == 8) {
//                let cell = tableView.dequeueReusableCellWithIdentifier("ACAdFreeTVCellID", forIndexPath: indexPath) as! ACAdFreeTVCell
//                cell.itemLabel.lineBreakMode = .ByWordWrapping
//
//                if (indexPath.row == 7) {
//                    cell.itemLabel.text = editArray.objectAtIndex(0) as? String
//                    cell.selectButton.selected = userObj.isEnableRegisteredUser
//                    
//                } else {
//                    cell.itemLabel.text = editArray.objectAtIndex(1) as? String
//                    cell.selectButton.selected = userObj.isEnableSearchEngines
//                }
//                if (indexPath.row == 9) {
//                    cell.itemLabel.text = editArray.objectAtIndex(2) as? String
//                    cell.selectButton.selected = activeUser.isEnableFollowers
//                }
                
//                return cell
//            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("ACSignUpTVCellID", forIndexPath: indexPath) as! ACSignUpTVCell
            
                cell.commonTextField.returnKeyType = UIReturnKeyType.Next
                cell.commonTextField.delegate = self
                cell.commonTextField.tag = 550 + indexPath.row
                cell.commonTextField.autocapitalizationType = UITextAutocapitalizationType.None
                cell.commonTextField.secureTextEntry = false
                
                switch indexPath.row {
                case 0:
                    cell.commonTextField.placeholder = "First Name"
                    cell.commonTextField.text = self.userObj.userFName
                    cell.commonTextField.autocapitalizationType = UITextAutocapitalizationType.Words
                    if alert == alertValidation.alert_Empty && rowValue == 0 {
                        cell.alertLabel.text = "*Please enter first name"
                    } else if alert == alertValidation.alert_FirstNameInvalid && rowValue == 0 {
                        cell.alertLabel.text = "*Please enter a valid first name"
                    } else {
                        cell.alertLabel.text = ""
                    }
                    
                    break
                case 1:
                    cell.commonTextField.placeholder = "Last Name"
                    cell.commonTextField.text = self.userObj.userLName
                    cell.commonTextField.autocapitalizationType = UITextAutocapitalizationType.Words
                    if alert == alertValidation.alert_Empty && rowValue == 1 {
                        cell.alertLabel.text = "*Please enter last name"
                    } else if alert == alertValidation.alert_LastNameInvalid && rowValue == 1 {
                        cell.alertLabel.text = "*Please enter a valid last name"
                    } else {
                        cell.alertLabel.text = ""
                    }
                    
                    break
                case 2:
                    cell.commonTextField.placeholder = "Phone Number(Optional)"
                    cell.commonTextField.text = self.userObj.userPhone
                    cell.commonTextField.keyboardType = UIKeyboardType.NumberPad
                    cell.commonTextField.inputAccessoryView = addToolBar("Next")
                    if alert == alertValidation.alert_PhoneNoInvalid && rowValue == 2 {
                        cell.alertLabel.text = "*Please enter a valid phone number"
                    } else {
                        cell.alertLabel.text = ""
                    }
                    
                    break
                case 3:
                    cell.commonTextField.placeholder = "Email(Optional)"
                    cell.commonTextField.text = self.userObj.userEmail
                    if alert == alertValidation.alert_Empty && rowValue == 3 {
                        cell.alertLabel.text = "*Please enter email"
                    } else if alert == alertValidation.alert_EmailInvalid && rowValue == 3 {
                        cell.alertLabel.text = "*Please enter a valid email"
                    } else {
                        cell.alertLabel.text = ""
                    }
                    
                    break
                case 4:
                    cell.commonTextField.placeholder = "Address(Optional)"
                    cell.commonTextField.text = self.userObj.userAddress
                    cell.alertLabel.text = ""
                    break
                case 5:
                    cell.commonTextField.placeholder = "Hobbies(Optional)"
                    cell.commonTextField.text = self.userObj.userHobbies
                    cell.alertLabel.text = ""
                    break
                default:
                    cell.commonTextField.placeholder = "Other Info(Optional)"
                    cell.commonTextField.text = self.userObj.otherInfo
                    cell.alertLabel.text = ""
                    cell.commonTextField.returnKeyType = UIReturnKeyType.Done
                    break
                }
                cell.commonTextField.attributedPlaceholder = NSAttributedString(string: cell.commonTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.grayColor() ,NSFontAttributeName : KAppRegularFont])
                return cell
            
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ACAddSocialHandlerTVCellID", forIndexPath: indexPath) as! ACAddSocialHandlerTVCell
            
            cell.socialButton.tag = indexPath.row
            switch indexPath.row {
            case 0:
                cell.socialImageView.image = UIImage(named:"icon1")
                cell.socialName.text = "LinkedIn"
                cell.socialButton.selected = self.socialObj.islinkedIn
                break
            case 1:
                cell.socialImageView.image = UIImage(named:"icon2")
                cell.socialName.text = "Facebook"
                cell.socialButton.selected = self.socialObj.isFacebook
                break
            case 2:
                cell.socialImageView.image = UIImage(named:"s16")
                cell.socialName.text = "Google+"
                cell.socialButton.selected = socialObj.isGoogle
                break
            case 3:
                cell.socialImageView.image = UIImage(named:"s11")
                cell.socialName.text = "Instagram"
                cell.socialButton.selected = socialObj.isInstagram
                break
            default:
                cell.socialImageView.image = UIImage(named:"s8")
                cell.socialName.text = "Twitter"
                cell.socialButton.selected = socialObj.isTwitter
                break
            }
            return cell
        }
    }
    
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 50))
            let label = UILabel(frame: CGRectMake(20, 10, tableView.bounds.size.width, 30))
            headerView.backgroundColor = RGBA(230, g: 230, b: 230, a: 1)
            label.text = "Add your social profile"
            label.font = KAppRegularFont
            label.textColor = UIColor.darkGrayColor()
            headerView.addSubview(label)
            
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if (indexPath.section == 0) {
//            if indexPath.row == 7 {
//                userObj.isEnableRegisteredUser = !userObj.isEnableRegisteredUser
//            } else if indexPath.row == 8 {
//                userObj.isEnableSearchEngines = !userObj.isEnableSearchEngines
//            }
//
//        } else {
        switch indexPath.row {
        case 0:
          
            if userObj.islinkedIn == false {
                print(linkedInOauth2Settings)
                self.view.endEditing(true)
                UsingOauth2(linkedInOauth2Settings, performWithToken: { (token) in
                    LinkedInRequestConvertible.OAuthToken = token
                    print(LinkedInRequestConvertible.Me())
                    
                    Alamofire.request(LinkedInRequestConvertible.Me()).response(completionHandler: {(request, response, json, error) in
                        //                self.result.text = "\(json)"
                        print("JSON = \(json)")
                        do {
                            let result = try NSJSONSerialization.JSONObjectWithData(json!, options: NSJSONReadingOptions.MutableContainers)
                            logInfo("\n\n controller  >>>>>>\n\(self)")
                            print(result)
                            self.addSocialLogin = socialLogin.linkedIn
                            self.callApiForSocialLogIn(result as AnyObject as! NSDictionary, provider: "linkedin")
                            logInfo("\n\n Response >>>>>> \n\(result)")
                            
                        } catch {
                            logInfo("\n\n error  >>>>>>\n\(error)")
                        }
                        //                let result = JSON(data: json!)
                        //                print(result)
                    })
                }) {
                    print("Oauth2 failed")
                }

            } else {
                callApiForSocialLogIn([:], provider: "linkedin")
            }
            break
        case 1:
//            userObj.isFacebook = !userObj.isFacebook
            if userObj.isFacebook == false {
                self.view.endEditing(true)
                SocialHelper.facebookManager.getFacebookInfoWithCompletionHandler(self) { (dataDictionary:Dictionary<String, AnyObject>?, error:NSError?) -> Void in
                    if let infoDict = dataDictionary {
                        print(infoDict)
                        self.addSocialLogin = socialLogin.facebook
                        self.callApiForSocialLogIn(infoDict, provider: "facebook")
                    } else {
                        AlertController.alert("Error!", message: (error?.localizedDescription)!)
                    }
                }

            } else {
                callApiForSocialLogIn([:], provider: "facebook")
            }
            break
        case 2:
//            userObj.isGoogle = !userObj.isGoogle
            if userObj.isGoogle == false {
                let signIn : GIDSignIn = GIDSignIn.sharedInstance()
                signIn.shouldFetchBasicProfile =  true
                signIn.clientID = kClientId
                signIn.scopes = ["https://www.googleapis.com/auth/plus.login"]
                signIn.delegate = self
                signIn.uiDelegate = self
                signIn.signIn()

            } else {
                callApiForSocialLogIn([:], provider: "google")
            }
            break
        case 3:
//            userObj.isInstagram = !userObj.isInstagram
            if userObj.isInstagram == false {
                print(instagramOauth2Settings)
                self.view.endEditing(true)
                UsingOauth2(instagramOauth2Settings, performWithToken: { (token) in
                    InstagramRequestConvertible.OAuthToken = token
                    print(InstagramRequestConvertible.Me())
                    
                    Alamofire.request(InstagramRequestConvertible.Me()).response(completionHandler: {(request, response, json, error) in
                        //                self.result.text = "\(json)"
                        print("JSON = \(json)")
                        do {
                            let result = try NSJSONSerialization.JSONObjectWithData(json!, options: NSJSONReadingOptions.MutableContainers)
                            logInfo("\n\n controller  >>>>>>\n\(self)")
                            print(result)
                            self.addSocialLogin = socialLogin.instagram
                            self.callApiForSocialLogIn(result as AnyObject as! NSDictionary, provider: "instagram")
                            logInfo("\n\n Response >>>>>> \n\(result)")
                            
                        } catch {
                            logInfo("\n\n error  >>>>>>\n\(error)")
                        }
                        //                let result = JSON(data: json!)
                        //                print(result)
                    })
                }) {
                    print("Oauth2 failed")
                }
                
            } else {
                callApiForSocialLogIn([:], provider: "linkedin")
            }

            break
        default:
//            userObj.isTwitter = !userObj.isTwitter
            if userObj.isTwitter == false {
                Twitter.sharedInstance().logInWithCompletion({ (session, error) in
                    if let unwrappedSession = session {
                        let client = TWTRAPIClient.clientWithCurrentUser()
                        let request : NSURLRequest = client.URLRequestWithMethod("GET", URL: "https://api.twitter.com/1.1/account/verify_credentials.json", parameters: [
                            "include_email" : "true",
                            "skip_status": "true"
                            ], error: nil)
                        client.sendTwitterRequest(request, completion: { (response, data, connectionError ) in
                            do {
                            let jsonDict  = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                            print(jsonDict)
                            self.addSocialLogin = socialLogin.twitter
                            self.callApiForSocialLogIn(jsonDict as! NSDictionary, provider: "twitter")
                            } catch {
                                logInfo("\n\n error  >>>>>>\n\(error)")
                            }
                        })
                        let alert = UIAlertController(title: "Logged In",
                            message: "User \(unwrappedSession.userName) has logged in",
                            preferredStyle: UIAlertControllerStyle.Alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                       
                    } else {
                        NSLog("Login error: %@", error!.localizedDescription);
                    }
                })

            } else {
                callApiForSocialLogIn([:], provider: "twitter")
            }
            break
                }
//        }
        editMyAccountTableView.reloadData()
    }
    
    //MARK:- UIButton Validations
    func isAllFieldVerified() ->alertValidation {
        if (userObj.userFName.length == 0) {
            alert = alertValidation.alert_Empty
            rowValue = 0
        } else if (!userObj.userFName.containsAlphabetsOnly()) {
            alert = alertValidation.alert_FirstNameInvalid
            rowValue = 0
        } else if (userObj.userLName.length == 0) {
            alert = alertValidation.alert_Empty
            rowValue = 1
        } else if (!userObj.userLName.containsAlphabetsOnly()) {
            alert = alertValidation.alert_LastNameInvalid
            rowValue = 1
        } else if (userObj.userPhone.length > 0 && userObj.userPhone.length < 10 && !userObj.userPhone.containsNumberOnly()) {
            alert = alertValidation.alert_PhoneNoInvalid
            rowValue = 2
        } else if (userObj.userEmail.length > 0 && !userObj.userEmail.isEmail()) {
            alert = alertValidation.alert_EmailInvalid
            rowValue = 3
        }  else {
            alert = alertValidation.alert_None
            rowValue = 10
        }
        return alert
    }
    
    // MARK: TextField Delegate Methods
    func textFieldDidEndEditing(textField: UITextField) {
        switch (textField.tag) {
        case 550:
            userObj.userFName = textField.text!
            break
        case 551:
            userObj.userLName = textField.text!
            break
        case 552:
            userObj.userPhone = textField.text!
            break
        case 553:
            userObj.userEmail = textField.text!
            break
        case 554:
            userObj.userAddress = textField.text!
            break
        case 555:
            userObj.userHobbies = textField.text!
            break
        default:
            userObj.otherInfo = textField.text!
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.returnKeyType == UIReturnKeyType.Next {
            let kTextField = getViewWithTag(textField.tag+1, view: self.view) as? UITextField
            kTextField?.becomeFirstResponder()
        } else {
            self.view .endEditing(true)
        }
        return true
    }

    //MARK:- Web API Methods
    func callApiForUpdateUser() {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACEmail] = userObj.userEmail
            dict[ACUserName] = userObj.userName
            dict[ACFirstName] = userObj.userFName
            dict[ACLastName] = userObj.userLName
            dict[ACRole] = "attendee"
            dict[ACPhone] = userObj.userPhone
            dict[ACHobbies] = userObj.userHobbies
            dict[ACChildren] = userObj.userChildren
            dict[ACRelationStatus] = userObj.relationStatus
            dict[ACOtherInfo] = userObj.otherInfo
            dict[ACAppearInRegisteredUser] = userObj.isEnableRegisteredUser
            dict[ACAppearInSearchEngine] = userObj.isEnableSearchEngines
            dict[ACUserImage] = self.imageData != "" ? self.imageData.base64EncodedString() : ""
            let params: [String : AnyObject] = [
                "user": dict ,
                "device_type" : "iOS",
                "device_id" : "65r34r346r6rt43r76t6"
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/update_user", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                    ACAppData.appInfoSharedInstance.appUserInfo = ACUserInfo.getUserEditProfileInfo(response!)
                        AlertController.alert("", message: res.objectForKeyNotNull("responseMessage", expected: "") as! String, buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
                            if position == 0 {
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                        })
                        
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForGenerateQR() {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "event_apis/generate_qr", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        let userQRVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACUserQrCodeVCID") as! ACUserQrCodeVC
                        userQRVC.qrCodeImage = (res.objectForKeyNotNull("social_code", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("code", expected: "") as! String
                        userQRVC.qrCodeImage = (res.objectForKeyNotNull("social_code", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("image", expected: "") as! String
                        self.navigationController?.pushViewController(userQRVC, animated: true)
                        
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForSocialLogIn(info : NSDictionary , provider : String) {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACProvider] = provider
            
            switch addSocialLogin {
            case socialLogin.linkedIn:
                dict[ACSocialLoginStatus] = !socialObj.islinkedIn
                dict[ACUserName] = String(format: "%@ %@", info.objectForKeyNotNull("firstName", expected: "") as! String ,info.objectForKeyNotNull("lastName", expected: "") as! String)
                dict[ACSocialUID] = info.objectForKeyNotNull("id", expected: "") as! String
                break
            case socialLogin.facebook :
                dict[ACSocialLoginStatus] = !socialObj.isFacebook
                dict[ACUserName] = info.objectForKeyNotNull("name", expected: "") as! String
                dict[ACSocialUID] =  info.objectForKeyNotNull("id", expected: "") as! String
                break
            case socialLogin.google :
                dict[ACSocialLoginStatus] = !socialObj.isGoogle
                dict[ACUserName] = info.objectForKeyNotNull("userName", expected: "") as! String
                dict[ACSocialUID] =  info.objectForKeyNotNull("userID", expected: "")  as! String
                break
            case socialLogin.instagram :
                dict[ACSocialLoginStatus] = !socialObj.isInstagram
                dict[ACUserName] =  (info.objectForKeyNotNull("data", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("full_name", expected: "") as! String
                dict[ACSocialUID] = (info.objectForKeyNotNull("data", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("id", expected: "") as! String
                break
            default:
                dict[ACSocialLoginStatus] = !socialObj.isTwitter
                dict[ACUserName] = info.objectForKeyNotNull("name", expected: "") as! String
                dict[ACSocialUID] =  info.objectForKeyNotNull("id_str", expected: "") as! String
                break
            }
          
            let params: [String : AnyObject] = [
                "user": dict ,
                "device_type" : "iOS",
                "device_id" : NSUserDefaults.standardUserDefaults().valueForKey("device_token")!
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "event_apis/add_social_login", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        switch self.addSocialLogin {
                        case socialLogin.linkedIn:
                            self.socialObj.islinkedIn = (res.objectForKeyNotNull("social_login", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("login_status", expected: 0) as! Bool

                            break
                        case socialLogin.facebook :
                            self.socialObj.isFacebook = (res.objectForKeyNotNull("social_login", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("login_status", expected: 0) as! Bool
                            break
                        case socialLogin.google :
                            self.socialObj.isGoogle = (res.objectForKeyNotNull("social_login", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("login_status", expected: 0) as! Bool
                            break
                        case socialLogin.instagram :
                            self.socialObj.isInstagram = (res.objectForKeyNotNull("social_login", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("login_status", expected: 0) as! Bool
                            break
                        default:
                            self.socialObj.isTwitter = (res.objectForKeyNotNull("social_login", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("login_status", expected: 0) as! Bool

                            break
                        }
                        self.editMyAccountTableView.reloadData()
                            } else {
                        AlertController.alert("")
                    }
                }
            })
        }
    }
}
