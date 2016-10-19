//
//  ACResetPasswordVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACResetPasswordVC: UIViewController {

    let userObj = ACUserInfo()
    
    @IBOutlet var accessCodeTextField: UITextField!
    @IBOutlet weak var newPswrdTextField: UITextField!
    @IBOutlet weak var confirmPswrdTextField: UITextField!
    
    @IBOutlet weak var cnfrmPswrdAlertLabel: UILabel!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()

    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Forgor Password"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        accessCodeTextField.attributedPlaceholder = NSAttributedString(string: "Access Code", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor() ,NSFontAttributeName : KAppRegularFont])
        newPswrdTextField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor() ,NSFontAttributeName : KAppRegularFont])
        confirmPswrdTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor() ,NSFontAttributeName : KAppRegularFont])
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func isAllFieldVerified() ->Bool {
        var fieldVerified: Bool = false
        
        if (accessCodeTextField.text!.trimWhiteSpace().length == 0) {
            cnfrmPswrdAlertLabel.text = "*Please enter your access code"
        }else if (newPswrdTextField.text!.trimWhiteSpace().length == 0) {
            cnfrmPswrdAlertLabel.text = "*Please enter new password"
        } else if (newPswrdTextField.text!.trimWhiteSpace().length < 6) {
            cnfrmPswrdAlertLabel.text = "*Password must be minimum 6 characters"
        } else if (confirmPswrdTextField.text!.trimWhiteSpace().length == 0) {
            cnfrmPswrdAlertLabel.text = "*Please enter again to confirm password"
        } else if (!(confirmPswrdTextField.text! == newPswrdTextField.text!) ) {
            cnfrmPswrdAlertLabel.text = "*Password does not match"
        }   else {
            cnfrmPswrdAlertLabel.text = ""
            fieldVerified = true
        }
        
        return fieldVerified
    }
    // MARK: - UIButton Action Methods
    
    @IBAction func doneButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        if isAllFieldVerified() {
            AlertController.alert("", message: "Password changed successfully", buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
                if position == 0 {
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }else {
            
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
        if (str.length>16) {
            return false
        }
        return true
    }
}
