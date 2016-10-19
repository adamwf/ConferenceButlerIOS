//
//  ACSignUpVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

enum alertForLabel: Int {
    case alert_Empty = 0
    case alert_InvalidUserName
    case alert_FirstNameInvalid
    case alert_LastNameInvalid
    case alert_EmailInvalid
    case alert_PasswordInvalid
    case alert_PasswordNotMatch
    case alert_None
}

class ACSignUpVC: ACBaseVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    var rowValue = 10
    let userObj = ACUserInfo()
    var alert:alertForLabel = alertForLabel(rawValue : 0)!
    
    @IBOutlet weak var tmLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var signUpTblView: UITableView!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        let font:UIFont? = UIFont(name: "VarelaRound", size:13)
        let fontSuper:UIFont? = UIFont(name: "VarelaRound", size:8)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: "Attendee CentralTM", attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:6], range: NSRange(location:attString.length-2,length:2))
        tmLabel.attributedText = attString;
        signUpTblView.estimatedRowHeight = 51
        signUpTblView.rowHeight = UITableViewAutomaticDimension
//        getRoundRect(signUpButton)
    }
    
//    func leftBarButton(imageName : NSString) -> UIBarButtonItem {
//        let button:UIButton = UIButton.init(type: UIButtonType.Custom)
//        button.frame = CGRectMake(0, 0, 20, 20)
//        button.setImage(UIImage(named: imageName as String), forState: UIControlState.Normal)
//        button.addTarget(self, action: #selector(leftBarButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
//        
//        return leftBarButtonItem
//    }
//    
//    @objc func leftBarButtonAction(button : UIButton) {
//        self.view .endEditing(true)
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    func isAllFieldVerified() ->alertForLabel {
        
        if (userObj.userName.length == 0) {
            alert = alertForLabel.alert_Empty
            rowValue = 0
        } else if (!userObj.userName.isValidUserName()) {
            alert = alertForLabel.alert_InvalidUserName
            rowValue = 0
        } else if (userObj.userFName.length == 0) {
            alert = alertForLabel.alert_Empty
            rowValue = 1
        } else if (!userObj.userFName.containsAlphabetsOnly()) {
            alert = alertForLabel.alert_FirstNameInvalid
            rowValue = 1
        } else if (userObj.userLName.length == 0) {
            alert = alertForLabel.alert_Empty
            rowValue = 2
        } else if (!userObj.userLName.containsAlphabetsOnly()) {
            alert = alertForLabel.alert_LastNameInvalid
            rowValue = 2
        } else if (userObj.userEmail.length == 0) {
            alert = alertForLabel.alert_Empty
            rowValue = 3
        } else if (!userObj.userEmail.isEmail()) {
            alert = alertForLabel.alert_Empty
            rowValue = 3
        } else if (userObj.userPassword.length == 0) {
            alert = alertForLabel.alert_Empty
            rowValue = 4
        } else if (userObj.userPassword.length < 6) {
            alert = alertForLabel.alert_PasswordInvalid
            rowValue = 4
        } else if (userObj.userCnfrmPassword.length == 0) {
            alert = alertForLabel.alert_Empty
            rowValue = 5
        } else if (!(userObj.userCnfrmPassword == userObj.userPassword)) {
            alert = alertForLabel.alert_PasswordNotMatch
            rowValue = 5
        } else if !checkButton.selected {
            alert = alertForLabel.alert_Empty
            rowValue = 6
        } else {
            alert = alertForLabel.alert_None
            rowValue = 10
        }
        
        return alert
    }
    
    //MARK: UIButton Action Methods
    @IBAction func signUpButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        if isAllFieldVerified() == alertForLabel.alert_None {
            
            let tabBarVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACCustomTabBarVCID")
            self.navigationController?.navigationBarHidden = false;
            self.navigationController!.pushViewController(tabBarVC!, animated: true)
//            let signUpOtpVC = self.storyboard?.instantiateViewControllerWithIdentifier("WFSignUpOtpVCID")
//            self.navigationController?.pushViewController(signUpOtpVC!, animated: true)
        } else {
            signUpTblView.reloadData()
        }
    }
    
    @IBAction func loginButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tandCButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        let tandCVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACTermsAndConditionVCID") as! ACTermsAndConditionVC
        self.navigationController?.pushViewController(tandCVC, animated: true)
    }
    
    @IBAction func checkButtonAction(sender: UIButton) {
        checkButton.selected = !checkButton.selected
    }
    
    // MARK: - UITableView DataSource Methods >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACSignUpTVCellID", forIndexPath: indexPath) as! ACSignUpTVCell
        cell.commonTextField.returnKeyType = UIReturnKeyType.Next
        cell.commonTextField.delegate = self
        cell.commonTextField.tag = 500 + indexPath.row
        cell.commonTextField.autocapitalizationType = UITextAutocapitalizationType.None
        cell.commonTextField.secureTextEntry = false
        
        switch indexPath.row {
        case 0:
            cell.commonTextField.placeholder = "Username"
            if alert == alertForLabel.alert_Empty && rowValue == 0 {
                cell.alertLabel.text = "*Please enter username"
            } else if alert == alertForLabel.alert_InvalidUserName && rowValue == 0 {
                cell.alertLabel.text = "*Please enter a valid username"
            } else {
                cell.alertLabel.text = ""
            }
            break
        case 1:
            cell.commonTextField.placeholder = "First Name"
            cell.commonTextField.autocapitalizationType = UITextAutocapitalizationType.Words
            if alert == alertForLabel.alert_Empty && rowValue == 1 {
                cell.alertLabel.text = "*Please enter first name"
            } else if alert == alertForLabel.alert_FirstNameInvalid && rowValue == 1 {
                cell.alertLabel.text = "*Please enter a valid first name"
            } else {
                cell.alertLabel.text = ""
            }
            break
        case 2:
            cell.commonTextField.placeholder = "Last Name"
            cell.commonTextField.autocapitalizationType = UITextAutocapitalizationType.Words
            if alert == alertForLabel.alert_Empty && rowValue == 2 {
                cell.alertLabel.text = "*Please enter last name"
            } else if alert == alertForLabel.alert_LastNameInvalid && rowValue == 2 {
                cell.alertLabel.text = "*Please enter a valid last name"
            } else {
                cell.alertLabel.text = ""
            }
            break
        case 3:
            cell.commonTextField.placeholder = "Email"
            cell.commonTextField.keyboardType = UIKeyboardType.EmailAddress
            if alert == alertForLabel.alert_Empty && rowValue == 3 {
                cell.alertLabel.text = "*Please enter email"
            } else if alert == alertForLabel.alert_EmailInvalid && rowValue == 3 {
                cell.alertLabel.text = "*Please enter a valid email"
            } else {
                cell.alertLabel.text = ""
            }
            break
        case 4:
            cell.commonTextField.placeholder = "Password"
            cell.commonTextField.secureTextEntry = true
            if alert == alertForLabel.alert_Empty && rowValue == 4 {
                cell.alertLabel.text = "*Please enter password"
            } else if alert == alertForLabel.alert_PasswordInvalid && rowValue == 4 {
                cell.alertLabel.text = "*Password must be minimum 6 characters"
            } else {
                cell.alertLabel.text = ""
            }
            break
        default:
            cell.commonTextField.placeholder = "Confirm Password"
            cell.commonTextField.secureTextEntry = true
            cell.commonTextField.returnKeyType = UIReturnKeyType.Done
            if alert == alertForLabel.alert_Empty && rowValue == 5 {
                cell.alertLabel.text = "*Please enter again to confirm password"
            } else if alert == alertForLabel.alert_PasswordNotMatch && rowValue == 5 {
                cell.alertLabel.text = "*Password does not match"
            } else if alert == alertForLabel.alert_Empty && rowValue == 6 {
                cell.alertLabel.text = "*Please agree to our terms and conditions to continue"
            } else {
                cell.alertLabel.text = ""
            }
            break
        }
        cell.commonTextField.attributedPlaceholder = NSAttributedString(string: cell.commonTextField.placeholder!, attributes: [NSForegroundColorAttributeName : KAppPlaceholderColor ,NSFontAttributeName : KAppRegularFont])
        return cell
        
    }
    
    // MARK: - UITableView Delegate Methods >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if (!(alert == alertForLabel.alert_None) && rowValue == indexPath.row) {
//            return 80
//        } else {
//            return 50
//        }
//    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
    }
    
    // MARK: TextField Delegate Methods
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case 500:
            userObj.userName = textField.text!
            break
        case 501:
            userObj.userFName = textField.text!
            break
        case 502:
            userObj.userLName = textField.text!
            break
        case 503:
            userObj.userEmail = textField.text!
            break
        case 504:
            userObj.userPassword = textField.text!
            break
        default:
            userObj.userCnfrmPassword = textField.text!
            break
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var str:NSString = textField.text! as NSString
        str = str.stringByReplacingCharactersInRange(range, withString: string)
        if (textField.tag == 500 || textField.tag == 503) {
            if (str.length>55) {
                return false
            }
        } else if (textField.tag == 501 || textField.tag == 502){
            if (str.length>30) {
                return false
            }
        } else {
            if (str.length>12) {
                return false
            }
        }
        return true
    }
}
