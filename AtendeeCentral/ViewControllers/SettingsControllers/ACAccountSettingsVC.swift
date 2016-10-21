//
//  ACAccountSettingsVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACAccountSettingsVC: UIViewController {

    var itemArray = NSMutableArray()
    @IBOutlet weak var settingTblView: UITableView!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        itemArray = ["Advance Settings","Change Password","Ad Free Version","Font +","Logout"]
        settingTblView.reloadData()
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Account Settings"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCellWithIdentifier("ACSettingsTVCellID", forIndexPath: indexPath) as! ACSettingsTVCell
        settingCell.rightArrowImgView.hidden = indexPath.row == 0 ? true : false

//        settingCell.statusSwitch.hidden = indexPath.row == 0 ? false : true
        settingCell.statusSwitch.hidden = true
        settingCell.itemNameLabel.text = itemArray.objectAtIndex(indexPath.row) as? String
        
        return settingCell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
//        case 0:
//            break
        case 0:
            let advanceSettings = self.storyboard?.instantiateViewControllerWithIdentifier("ACAdvanceSettingVCID") as! ACAdvanceSettingVC
            self.navigationController?.pushViewController(advanceSettings, animated: true)
            break
        case 1:
            let changePassword = self.storyboard?.instantiateViewControllerWithIdentifier("ACChangePasswordVCID") as! ACChangePasswordVC
            self.navigationController?.pushViewController(changePassword, animated: true)
            break
        case 2:
            let adFreeVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACADFreeVCID") as! ACADFreeVC
            self.navigationController?.pushViewController(adFreeVC, animated: true)
            break
        case 3:
            let fontChangeVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACFontChangeVCID") as! ACFontChangeVC
            self.navigationController?.pushViewController(fontChangeVC, animated: true)
            break
        default:
            //            kAppDelegate.navController?.popToRootViewControllerAnimated(true)
            AlertController.alert("", message: "Are you sure, you want to logout?", buttons: ["No", "Yes"], tapBlock: { (alertAction, position) -> Void in
                if position == 0 {
                    // do nothing
                } else if position == 1 {
                    self.callApiForSignOut()
                }
            })
            
            break
        }
    }
    
    //MARK:- Web API Methods
    func callApiForSignOut() {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] =  NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            let params: [String : AnyObject] = [
                "user": dict ,
                "device_type" : "iOS",
                "device_id" : "65r34r346r6rt43r76t6"
            ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/sign_out", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        NSUserDefaults.standardUserDefaults().setValue("", forKey: "ACUserID")
                        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "ACToken")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        kAppDelegate.navController!.popToRootViewControllerAnimated(true)
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }


}
