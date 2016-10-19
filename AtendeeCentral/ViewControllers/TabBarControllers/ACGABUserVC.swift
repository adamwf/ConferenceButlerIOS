//
//  ACGABUserVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACGABUserVC: UIViewController {
    let dict: NSMutableDictionary? = [
        "profileType" : "LinkedIn", // Always use optional values carefully!
        "profileLogo" : "icon1",
        "profileName" : "User Name",
        ]
    let dict1: NSMutableDictionary? = [
        "profileType" : "Facebook", // Always use optional values carefully!
        "profileLogo" : "icon2",
        "profileName" : "User Name",
        ]
    let dict2: NSMutableDictionary? = [
        "profileType" : "Snapchat", // Always use optional values carefully!
        "profileLogo" : "icon3",
        "profileName" : "User Name",
        ]
    
    let dictParams: NSMutableDictionary? = [
        "username" : "Alessio", // Always use optional values carefully!
        "userEmail" : "abcd_845@gmail.com",
        "userNumber" : "9987372232",
        "userAddress" : "Charleston,Sect-05,New York",
        "userImage" : "user1"
    ]

    var  userProfileArray = NSMutableArray()

    @IBOutlet var gabScreenHeaderView: UIView!
    @IBOutlet var gabScreenFooterView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var emailIdLabel: UILabel!
    @IBOutlet var phoneNoLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var viewSocialCodeButtonProperty: UIButton!
    @IBOutlet var gabScreenTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
        self.UserData()
        self.gabScreenTableView.tableFooterView = self.gabScreenFooterView;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    func customInit() {
        userProfileArray = [dict!,dict1!,dict2!]
        self.navigationItem.title = "GAB <Kris>"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        getRoundImage(userImageView)
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Tableview Datasource And Deleagte Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACDirectoryHandlerTVCellID", forIndexPath: indexPath) as! ACDirectoryHandlerTVCell
        let dict = userProfileArray [indexPath.row]
        cell.socialMediaName.text = dict["profileType"] as? String
        cell.socialMediaImgView.image = UIImage(named: dict["profileLogo"]! as! String)
        cell.gabScreenUserName.text = dict["profileName"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func UserData() {
        nameLabel.text = dictParams!["username"] as? String
        emailIdLabel.text = dictParams!["userEmail"] as? String
        phoneNoLabel.text = dictParams!["userNumber"] as? String
        addressLabel.text = dictParams!["userAddress"] as? String
        userImageView.image = UIImage(named: dictParams!["userImage"]! as! String)
    }
    
    //MARK:- UIButton Action Methods
    @IBAction func mapButtonAction(sender: UIButton) {
        //        let mapVC = self.storyboard?.instantiateViewControllerWithIdentifier("WFMapVCID") as! WFMapVC
        //        mapVC.addressStr = addressLabel.text!
        //        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func viewSocialCodeButtonAction(sender: UIButton) {
        //        let userQRCodeVC = self.storyboard?.instantiateViewControllerWithIdentifier("WFUserQrCodeVCID") as! WFUserQrCodeVC
        //        self.navigationController?.pushViewController(userQRCodeVC   , animated: true)
    }
    

}
