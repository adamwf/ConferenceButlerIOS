//
//  ACADFreeVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACADFreeVC: UIViewController {

    var statusOne = Bool()
    var statusTwo = Bool()
    @IBOutlet weak var adFreeTblView: UITableView!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()

    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Purchase Ad Free Version"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        statusOne = true
    }
    
        // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let adCell = tableView.dequeueReusableCellWithIdentifier("ACAdFreeTVCellID", forIndexPath: indexPath) as! ACAdFreeTVCell
        if indexPath.row == 0 {
            adCell.itemLabel.text = "$1 per Month"
            adCell.selectButton.selected = statusOne
        } else {
            adCell.itemLabel.text = "$5 per Year"
            adCell.selectButton.selected = statusTwo
        }
        
        return adCell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            statusOne = true
            statusTwo = false
        } else {
            statusTwo = true
            statusOne = false
        }
        adFreeTblView.reloadData()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            statusOne = false
        } else {
            statusTwo = false
        }
        adFreeTblView.reloadData()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 50))
        let label = UILabel(frame: CGRectMake(10, 10, tableView.bounds.size.width, 30))
        label.font = UIFont(name: "VarelaRound", size: 16)
        label.text = "Choose your Plan :"
        label.textColor = UIColor.blackColor()
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - UIButton Action Methods
    @IBAction func purchaseButtonAction(sender: UIButton) {
        AlertController.alert("Work in Progress")
    }

    //MARK:- Web API Methods
    func callApiForPurchaseAdFree() {
        if kAppDelegate.hasConnectivity() {
            
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            //            dict[HDNewConfirmPassword] = confirmPswrdTextField.text!
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
