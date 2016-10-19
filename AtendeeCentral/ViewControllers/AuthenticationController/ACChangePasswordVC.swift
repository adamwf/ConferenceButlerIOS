//
//  ACChangePasswordVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 09/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPswrdTextField: UITextField!
    @IBOutlet weak var newPswrdTextField: UITextField!
    @IBOutlet weak var confirmPswrdTextField: UITextField!
    
    @IBOutlet var oldPswrdAlertLabel: UILabel!
    @IBOutlet var newPswrdAlertLabel: UILabel!
    @IBOutlet weak var cnfrmPswrdAlertLabel: UILabel!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        oldPswrdTextField.attributedPlaceholder = NSAttributedString(string: "Old Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor() ,NSFontAttributeName : KAppRegularFont])
        newPswrdTextField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor() ,NSFontAttributeName : KAppRegularFont])
        confirmPswrdTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor() ,NSFontAttributeName : KAppRegularFont])
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Change Password"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
    }
    
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func isAllFieldVerified() ->Bool {
        
        var fieldVerified: Bool = false
        
        if (oldPswrdTextField.text!.trimWhiteSpace().length == 0) {
            oldPswrdAlertLabel.text = "*Please enter your password"
            newPswrdAlertLabel.text = ""
            cnfrmPswrdAlertLabel.text = ""
        } else if (oldPswrdTextField.text!.trimWhiteSpace().length < 6) {
            oldPswrdAlertLabel.text = "*Password must be minimum 6 characters"
            newPswrdAlertLabel.text = ""
            cnfrmPswrdAlertLabel.text = ""
        } else if (newPswrdTextField.text!.trimWhiteSpace().length == 0) {
            oldPswrdAlertLabel.text = ""
            newPswrdAlertLabel.text = "*Please enter new password"
            cnfrmPswrdAlertLabel.text = ""
        } else if (newPswrdTextField.text!.trimWhiteSpace().length < 6) {
            oldPswrdAlertLabel.text = ""
            newPswrdAlertLabel.text = "*Password must be minimum 6 characters"
            cnfrmPswrdAlertLabel.text = ""
        } else if (confirmPswrdTextField.text!.trimWhiteSpace().length == 0) {
            oldPswrdAlertLabel.text = ""
            newPswrdAlertLabel.text = ""
            cnfrmPswrdAlertLabel.text = "*Please enter again to confirm password"
        } else if (!(confirmPswrdTextField.text! == newPswrdTextField.text!) ) {
            oldPswrdAlertLabel.text = ""
            newPswrdAlertLabel.text = ""
            cnfrmPswrdAlertLabel.text = "*Password does not match"
        }   else {
            cnfrmPswrdAlertLabel.text = ""
            fieldVerified = true
        }
        
        return fieldVerified
    }
    // MARK: - UIButton Action Methods
    
    @IBAction func saveButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        if isAllFieldVerified() {
            callApiForChangePassword()
        }
    }
    
    // MARK: TextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 500 {
            let kTextField = getViewWithTag(501, view: self.view) as? UITextField
            kTextField?.becomeFirstResponder()
        }else if textField.tag == 501 {
            let kTextField = getViewWithTag(502, view: self.view) as? UITextField
            kTextField?.becomeFirstResponder()
        } else {
            self.view .endEditing(true)
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var str:NSString = textField.text! as NSString
        str = str.stringByReplacingCharactersInRange(range, withString: string)
        if (str.length>12) {
            return false
        }
        return true
    }

    //MARK:- Web API Methods
    func callApiForChangePassword() {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACOldPassword] = oldPswrdTextField.text!
            dict[ACNewPassword] = newPswrdTextField.text!
            dict[ACNewConfirmPassword] = confirmPswrdTextField.text!
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/change_password", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
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

}
