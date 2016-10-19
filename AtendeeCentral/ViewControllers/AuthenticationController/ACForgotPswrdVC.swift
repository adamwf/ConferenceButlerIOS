//
//  ACForgotPswrdVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 03/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACForgotPswrdVC: UIViewController {

    let userObj = ACUserInfo()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    // MARK: - Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Reset Your Password"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
         emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.grayColor() ,NSFontAttributeName : KAppRegularFont])
    }
    
    func isAllFieldVerified() ->Bool {
        var fieldVerified: Bool = false
        
        if (userObj.userEmail.trimWhiteSpace().length == 0) {
            alertLabel.text = "*Please enter email"
        } else if (!userObj.userEmail.isEmail()) {
            alertLabel.text = "*Please enter a valid email"
        } else {
            fieldVerified = true
        }
        return fieldVerified
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: TextField Delegate Methods
    func textFieldDidEndEditing(textField: UITextField) {
        userObj.userEmail = textField.text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var str:NSString = textField.text! as NSString
        str = str.stringByReplacingCharactersInRange(range, withString: string)
        if (str.length>55) {
            return false
        }
        return true
    }
    
    // MARK: - UIButton Action Methods
    @IBAction func submitButtonAction(sender: UIButton) {
        self.view .endEditing(true)
        if self.isAllFieldVerified() {
            self.callApiForForgotPassword()
        }
    }

    //MARK:- Web API Methods
    func callApiForForgotPassword() {
        if kAppDelegate.hasConnectivity() {
            let params: [String : AnyObject] = [
                ACEmail : emailTextField.text!
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/forget_password", completion: { (response, error) in
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
