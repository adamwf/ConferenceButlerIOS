//
//  ACAdvanceSettingVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACAdvanceSettingVC: UIViewController {

    @IBOutlet weak var centerSeparatorLabel: UILabel!
    @IBOutlet weak var advanceSettingTblView: UITableView!
    @IBOutlet weak var footrView: UIView!
    
    @IBOutlet weak var caseOneHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var caseTwoHeightConstraint: NSLayoutConstraint!
    
    var caseOneSelected = Bool()
    var caseTwoSelected = Bool()

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        callApiForGetAdvanceSettings()
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Advance Settings"
        self.navigationItem.leftBarButtonItem = self.leftBarButton("backArrow")
        footrView.frame = CGRectMake(0, 0, Window_Width, 0)
        advanceSettingTblView.tableFooterView = footrView
        advanceSettingTblView.estimatedRowHeight = 100
        advanceSettingTblView.rowHeight = UITableViewAutomaticDimension
    }
    
    func leftBarButton(imageName : NSString) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setImage(UIImage(named: imageName as String), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(leftBarButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
    }
    
    func getAttributtedText(text : NSString) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Justified
        paragraphStyle.lineSpacing = 2
        let myAttributes = [NSParagraphStyleAttributeName:paragraphStyle,
                            NSFontAttributeName:KAppRegularFont]
        let attrString = NSAttributedString(
            string: text as String,
            attributes: myAttributes)
        
        return attrString
    }
    
    func updateSelection(index : NSInteger) {
        let cell = advanceSettingTblView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection:0)) as! ACAdFreeTVCell
        cell.selectButton.selected = !cell.selectButton.selected
        switch index {
        case 1:
            if cell.selectButton.selected  {
                caseOneSelected = true
                centerSeparatorLabel.hidden = false
                caseOneHeightConstraint.constant = 60
                if !caseTwoSelected  {
                    caseTwoHeightConstraint.constant = 0
                    footrView.frame = CGRectMake(0, 0, Window_Width, 140)
                    centerSeparatorLabel.hidden = true
                    advanceSettingTblView.tableFooterView = footrView
                } else {
                    caseTwoHeightConstraint.constant = 60
                    footrView.frame = CGRectMake(0, 0, Window_Width, 200)
                    advanceSettingTblView.tableFooterView = footrView
                }
                
            } else {
                caseOneSelected = false
                caseOneHeightConstraint.constant = 0
                if !caseTwoSelected {
                    footrView.frame = CGRectMake(0, 0, Window_Width, 0)
                    advanceSettingTblView.tableFooterView = footrView
                } else {
                    footrView.frame = CGRectMake(0, 0, Window_Width, 140)
                    centerSeparatorLabel.hidden = true
                    advanceSettingTblView.tableFooterView = footrView
                }
            }
        case 2:
            if cell.selectButton.selected  {
                caseTwoSelected = true
                centerSeparatorLabel.hidden = false
                caseTwoHeightConstraint.constant = 60
                if !caseOneSelected {
                    caseOneHeightConstraint.constant = 0
                    footrView.frame = CGRectMake(0, 0, Window_Width, 140)
                    centerSeparatorLabel.hidden = true
                    advanceSettingTblView.tableFooterView = footrView
                } else {
                    caseOneHeightConstraint.constant = 60
                    footrView.frame = CGRectMake(0, 0, Window_Width, 200)
                    advanceSettingTblView.tableFooterView = footrView
                }
            } else {
                caseTwoSelected = false
                caseTwoHeightConstraint.constant = 0
                if !caseOneSelected {
                    caseOneHeightConstraint.constant = 0
                    footrView.frame = CGRectMake(0, 0, Window_Width, 0)
                    advanceSettingTblView.tableFooterView = footrView
                } else {
                    caseOneHeightConstraint.constant = 60
                    footrView.frame = CGRectMake(0, 0, Window_Width, 140)
                    centerSeparatorLabel.hidden = true
                    advanceSettingTblView.tableFooterView = footrView
                }
            }
        default:
            footrView.frame = CGRectMake(0, 0, Window_Width, 0)
            advanceSettingTblView.tableFooterView = footrView
        }
    }

    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - TableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let settingCell = tableView.dequeueReusableCellWithIdentifier("ACSettingsTVCellID", forIndexPath: indexPath) as! ACSettingsTVCell
            settingCell.itemNameLabel.attributedText = getAttributtedText("Your Profile will visible to those that request to follow and that you \"accept\"; after you \"accept\" you will be able to message them. All AttendeeQR that you scan are automatically \"accepted\" requests. Please see our T&Cs for more info.")
            
            return settingCell
        } else {
            let adFreeCell = tableView.dequeueReusableCellWithIdentifier("ACAdFreeTVCellID", forIndexPath: indexPath) as! ACAdFreeTVCell
            if indexPath.row == 1 {
                adFreeCell.itemLabel.text = "To have your profile info displayed within Search Engine results for Google, Bing, Yahoo, etc."
            } else {
                adFreeCell.itemLabel.text = "To have your profile info appear in our Directory of registered Users."
            }
            
            return adFreeCell
        }
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 {
            let cell = advanceSettingTblView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection:0)) as! ACAdFreeTVCell
            cell.selectButton.selected = !cell.selectButton.selected
            switch indexPath.row {
            case 1:
                if cell.selectButton.selected  {
                    caseOneSelected = true
                    centerSeparatorLabel.hidden = false
                    caseOneHeightConstraint.constant = 60
                    if !caseTwoSelected  {
                        caseTwoHeightConstraint.constant = 0
                        footrView.frame = CGRectMake(0, 0, Window_Width, 140)
                        centerSeparatorLabel.hidden = true
                        tableView.tableFooterView = footrView
                    } else {
                        caseTwoHeightConstraint.constant = 60
                        footrView.frame = CGRectMake(0, 0, Window_Width, 200)
                        tableView.tableFooterView = footrView
                    }
                      
                } else {
                    caseOneSelected = false
                    caseOneHeightConstraint.constant = 0
                    if !caseTwoSelected {
                        footrView.frame = CGRectMake(0, 0, Window_Width, 0)
                        tableView.tableFooterView = footrView
                    } else {
                        footrView.frame = CGRectMake(0, 0, Window_Width, 140)
                        centerSeparatorLabel.hidden = true
                        tableView.tableFooterView = footrView
                    }
                }
            case 2:
                if cell.selectButton.selected  {
                    caseTwoSelected = true
                    centerSeparatorLabel.hidden = false
                    caseTwoHeightConstraint.constant = 60
                    if !caseOneSelected {
                        caseOneHeightConstraint.constant = 0
                        footrView.frame = CGRectMake(0, 0, Window_Width, 140)
                        centerSeparatorLabel.hidden = true
                        tableView.tableFooterView = footrView
                    } else {
                        caseOneHeightConstraint.constant = 60
                        footrView.frame = CGRectMake(0, 0, Window_Width, 200)
                        tableView.tableFooterView = footrView
                    }
                } else {
                    caseTwoSelected = false
                    caseTwoHeightConstraint.constant = 0
                    if !caseOneSelected {
                        caseOneHeightConstraint.constant = 0
                        footrView.frame = CGRectMake(0, 0, Window_Width, 0)
                        tableView.tableFooterView = footrView
                    } else {
                        caseOneHeightConstraint.constant = 60
                        footrView.frame = CGRectMake(0, 0, Window_Width, 140)
                        centerSeparatorLabel.hidden = true
                        tableView.tableFooterView = footrView
                    }
                }
                default:
                footrView.frame = CGRectMake(0, 0, Window_Width, 0)
                tableView.tableFooterView = footrView
            }
        } else {
            
        }
    }
    
    //MARK: - UIButton Action
    @IBAction func showInDirectoryButtonAction(sender: UIButton) {
        let manageInfoDirectoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACManagedInfoDirectoryVCID") as! ACManagedInfoDirectoryVC
        manageInfoDirectoryVC.isFromDirectory = true
        self.navigationController?.pushViewController(manageInfoDirectoryVC, animated: true)
        
    }
    
        @IBAction func showInPublicButtonAction(sender: UIButton) {
        let manageInfoSearchVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACManagedInfoDirectoryVCID") as! ACManagedInfoDirectoryVC
        manageInfoSearchVC.isFromDirectory = false
        self.navigationController?.pushViewController(manageInfoSearchVC, animated: true)
    }
    
    @IBAction func applySettingsButtonAction(sender: UIButton) {
        callApiForSetAdvanceSettings()
    }
    
    //MARK:- Web API Methods
    func callApiForGetAdvanceSettings() {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/get_settings", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        if res.objectForKeyNotNull("search_engine", expected: Bool()) as! Bool == true && res.objectForKeyNotNull("register_user", expected: Bool()) as! Bool == true {
                            self.updateSelection(1)
                            self.updateSelection(2)
                        } else if res.objectForKeyNotNull("search_engine", expected: Bool()) as! Bool == true {
                            self.updateSelection(1)
                        } else if res.objectForKeyNotNull("register_user", expected: Bool()) as! Bool == true {
                            self.updateSelection(2)
                        }
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
    
    func callApiForSetAdvanceSettings() {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            dict[ACRegisterUser] = caseTwoSelected
            dict[ACGabOnly] = false
            dict[ACSearchEngine] = caseOneSelected
            let params: [String : AnyObject] = [
                "user": dict ,
                ]
            
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/set_settings", completion: { (response, error) in
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
                    } else {
                        AlertController.alert("", message: res.objectForKeyNotNull("responseMessage", expected: "") as! String, buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
                            if position == 0 {
                                self.navigationController?.popViewControllerAnimated(true)
                            }
                        })
                    }
                }
            })
        }
    }

}
