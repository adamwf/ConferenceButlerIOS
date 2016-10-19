//
//  ACLoginVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import AlamofireOauth2
import Alamofire

// Create your own clientID and clientSecret at https://developer.wordpress.com/docs/oauth2/
let linkedInOauth2Settings = Oauth2Settings(
    baseURL: "https://api.linkedin.com/v1/people/~:(id,industry,firstName,lastName,emailAddress,headline,summary,publicProfileUrl,specialties,positions:(id,title,summary,start-date,end-date,is-current,company:(id,name,type,size,industry,ticker)),pictureUrls::(original),location:(name))?format=json",
    authorizeURL: "https://www.linkedin.com/uas/oauth2/authorization",
    tokenURL: "https://www.linkedin.com/uas/oauth/accessToken",
    redirectURL: "https://172.16.6.55:4000/sa/complete/linkedin-oauth2/",
    clientID: "815x34ncds6r2m",
    clientSecret: "ONvZ69mcfoQ6DxSx",
    scope: "r_basicprofile,r_emailaddress"
)

//func Oauth2Settings(baseURL:) -> <#return type#> {
//    <#function body#>
//}
// Minimal Alamofire implementation. For more info see https://github.com/Alamofire/Alamofire#crud--authorization

public enum LinkedInRequestConvertible: URLRequestConvertible {
    static var baseURLString: String? = linkedInOauth2Settings.baseURL
    static var OAuthToken: String?
    
    case Me()
    
    public var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: LinkedInRequestConvertible.baseURLString!)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = "GET"
        if let token = LinkedInRequestConvertible.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return mutableURLRequest
    }
}

class ACLoginVC: ACBaseVC,UIGestureRecognizerDelegate {
    @IBOutlet weak var userNameTextField: ACCustomTextField!
    @IBOutlet weak var passwordTextField: ACCustomTextField!
    @IBOutlet weak var alertUserNameLabel: UILabel!
    @IBOutlet weak var alertPasswordLabel: UILabel!
    
    @IBOutlet weak var logoLabel: UILabel!
    let userObj = ACUserInfo()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        passwordTextField.text = ""
        alertPasswordLabel.text = ""
        alertUserNameLabel.text = ""
        self.navigationController?.navigationBarHidden = true
    }
    
    // MARK: Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Helper Methods
    func customInit() {
        let font:UIFont? = Window_Width == 320 ? UIFont(name: "VarelaRound", size:(NSUserDefaults.standardUserDefaults().valueForKey("size") as! CGFloat)-2) : KAppRegularFont
        let fontSuper:UIFont? = UIFont(name: "VarelaRound", size:(NSUserDefaults.standardUserDefaults().valueForKey("size") as! CGFloat) - 6)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: "Welcome Back! to Attendee CentralTM", attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:6], range: NSRange(location:attString.length-2,length:2))
        logoLabel.attributedText = attString;
        self.navigationItem.title = "Login"
        getGesture()
    }
    
    func getGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(ACLoginVC.handleTap))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    func isAllFieldVerified() ->Bool {
        
        var fieldVerified: Bool = false
        
        if (userObj.userName.trimWhiteSpace().length == 0) {
            alertUserNameLabel.text = "*Please enter username"
            alertPasswordLabel.text = ""
        } else if (!userObj.userName.isEmail() && !userObj.userName.isValidUserName() ) {
            alertUserNameLabel.text = "*Please enter a valid username"
            alertPasswordLabel.text = ""
        } else if (userObj.userPassword.trimWhiteSpace().length == 0) {
            alertPasswordLabel.text = "*Please enter password"
            alertUserNameLabel.text = ""
        } else if (userObj.userPassword.trimWhiteSpace().length < 6) {
            alertPasswordLabel.text = "*Password must be minimum 6 characters"
            alertUserNameLabel.text = ""
        } else {
            fieldVerified = true
        }
        
        return fieldVerified
    }
    
    // MARK: TextField Delegate Methods
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 500 {
            userObj.userName = textField.text!
        } else {
            userObj.userPassword = textField.text!
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 500 {
            let kTextField = getViewWithTag(501, view: self.view) as? UITextField
            kTextField?.becomeFirstResponder()
        } else {
            self.view .endEditing(true)
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var str:NSString = textField.text! as NSString
        str = str.stringByReplacingCharactersInRange(range, withString: string)
        if textField.tag == 500 {
            if (str.length>55) {
                return false
            }
        } else {
            if (str.length>12) {
                return false
            }
        }
        return true
    }
    
    // MARK: UIButton Action Methods
    @IBAction func fbButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        SocialHelper.facebookManager.getFacebookInfoWithCompletionHandler(self) { (dataDictionary:Dictionary<String, AnyObject>?, error:NSError?) -> Void in
            if let infoDict = dataDictionary {
                print(infoDict)
                self.callApiForSocialLogIn(infoDict, provider: "facebook")
            } else {
                AlertController.alert("Error!", message: (error?.localizedDescription)!)
            }
        }
    }
    
    @IBAction func signUpButtonAction(sender: UIButton) {
                self.view.endEditing(true)
                let signUpVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACSignUpVCID")
                self.navigationController?.pushViewController(signUpVC!, animated: true)
    }
    
    @IBAction func loginButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        if self.isAllFieldVerified() {
            self.callApiForLogIn()
//
        }
    }
    
    @IBAction func linkedInButtonAction(sender: UIButton) {
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
    }
    
    @IBAction func forgotPswrdButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        let forgotPswrdVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACForgotPswrdVCID") as! ACForgotPswrdVC
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.pushViewController(forgotPswrdVC, animated: true)
    }
    
    //MARK:- Web API Methods
    func callApiForLogIn() {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACEmail] = userNameTextField.text
            dict[ACPassword] = passwordTextField.text
            let params: [String : AnyObject] = [
                "user": dict ,
                "device_type" : "iOS",
                "device_id" : NSUserDefaults.standardUserDefaults().valueForKey("device_token")!
            ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/attendee_sign_in", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        NSUserDefaults.standardUserDefaults().setValue((res.objectForKeyNotNull("user", expected: NSDictionary()).objectForKeyNotNull("id", expected: "") as? String ?? ""), forKey: "ACUserID")
                        print(NSUserDefaults.standardUserDefaults().valueForKey("ACUserID"))
                        NSUserDefaults.standardUserDefaults().setValue((res.objectForKeyNotNull("user", expected: NSDictionary()).objectForKeyNotNull("access_token", expected: "") as? String ?? ""), forKey: "ACToken")
                        print(NSUserDefaults.standardUserDefaults().valueForKey("ACToken"))
                        NSUserDefaults.standardUserDefaults().synchronize()
                        ACAppData.appInfoSharedInstance.appUserInfo = ACUserInfo.getUserLoginInfo(response!)
                        let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACCustomTabBarVCID")
                        self.navigationController?.navigationBarHidden = false;
                        self.navigationController!.pushViewController(tabBarVC!, animated: true)
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
            dict[ACEmail] = provider == "facebook" ? info.objectForKeyNotNull("email", expected: "") as! String : info.objectForKeyNotNull("emailAddress", expected: "") as! String
            dict[ACProvider] = provider
            dict[ACUserImage] = provider == "facebook" ? ((info.objectForKeyNotNull("picture", expected: NSDictionary()) as! NSDictionary ).objectForKeyNotNull("data", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("url", expected: "") as! String : String(format:"%@.jpg",info.objectForKeyNotNull("publicProfileUrl", expected: "") as! String)
            dict[ACUserName] = provider == "facebook" ? info.objectForKeyNotNull("name", expected: "") as! String : String(format: "%@ %@", info.objectForKeyNotNull("firstName", expected: "") as! String ,info.objectForKeyNotNull("lastName", expected: "") as! String)
            dict[ACFirstName] = provider == "facebook" ? info.objectForKeyNotNull("first_name", expected: "") as! String : info.objectForKeyNotNull("firstName", expected: "") as! String
            dict[ACLastName] = provider == "facebook" ? info.objectForKeyNotNull("last_name", expected: "") as! String : info.objectForKeyNotNull("lastName", expected: "") as! String
            dict[ACSocialUID] = provider == "facebook" ? info.objectForKeyNotNull("id", expected: "") as! String : info.objectForKeyNotNull("id", expected: "") as! String
            let params: [String : AnyObject] = [
                "user": dict ,
                "device_type" : "iOS",
                "device_id" : NSUserDefaults.standardUserDefaults().valueForKey("device_token")!
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/social_login", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        NSUserDefaults.standardUserDefaults().setValue((res.objectForKeyNotNull("user", expected: NSDictionary()).objectForKeyNotNull("id", expected: "") as? String ?? ""), forKey: "ACUserID")
                        NSUserDefaults.standardUserDefaults().setValue((res.objectForKeyNotNull("user", expected: NSDictionary()).objectForKeyNotNull("access_token", expected: "") as? String ?? ""), forKey: "ACToken")
                        print(NSUserDefaults.standardUserDefaults().valueForKey("ACToken"))
                        NSUserDefaults.standardUserDefaults().synchronize()
                        ACAppData.appInfoSharedInstance.appUserInfo = ACUserInfo.getUserLoginInfo(response!)
                        let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACCustomTabBarVCID")
                        kAppDelegate.navController!.pushViewController(tabBarVC!, animated: true)
                    } else {
                        AlertController.alert("")
                    }
                }
            })
        }
    }

}


