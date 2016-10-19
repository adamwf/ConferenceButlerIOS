//
//  ACProfileVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import EventKit

class ACProfileVC: ACBaseVC {
    var userArray = NSMutableArray()
    var userInfo = ACUserInfo()
    
    @IBOutlet weak var myAccountTblView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var gabSearchTextField: UITextField!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        callApiForProfile()
    }
    
    // MARK: - Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "My Account"
        myAccountTblView.rowHeight = UITableViewAutomaticDimension
        myAccountTblView.estimatedRowHeight = 250
        getRoundImage(self.userImageView)
        self.navigationItem.rightBarButtonItems = ACAppUtilities.rightBarButtonArray(["nav_ic3","nav_ic2",""],controller: self) as? [UIBarButtonItem]
        self.navigationItem.leftBarButtonItems = ACAppUtilities.leftBarButtonArray(["nav_ic1","V",""],controller: self) as? [UIBarButtonItem]
      
    }
    
    func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.saveEvent(event, span: .ThisEvent)
                } catch let e as NSError {
                    completion?(success: false, error: e)
                    return
                }
                completion?(success: true, error: nil)
            } else {
                completion?(success: false, error: error)
            }
        })
    }
    
    func leftBarButtonsAction(button : UIButton) {
        print(button.tag)
        self.view .endEditing(true)
        if button.tag == 200 {
            let myWebsite = NSURL(string:"http://www.google.com/")
            //            let img: UIImage = image!
            let textToShare = "Hello!! Wlcome to world fax"
            guard let url = myWebsite else {
                print("nothing found")
                return
            }
            //            let shareItems:Array = [img, url]
            let shareItems:Array = [url,textToShare]
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
        } else if button.tag == 201 {
            let viewersVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACViewersVCID")
            self.navigationController?.pushViewController(viewersVC!, animated: true)
        }
    }
    
    func rightBarButtonsAction(barbutton : UIButton) {
        self.view .endEditing(true)
        if barbutton.tag == 100 {
            let editAccountVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACEditAccountVCID") as! ACEditAccountVC
            editAccountVC.userObj = self.userInfo
            self.navigationController?.pushViewController(editAccountVC, animated: true)

        } else  {
            let accountSettingsVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACAccountSettingsVCID") as! ACAccountSettingsVC
            self.navigationController?.pushViewController(accountSettingsVC, animated: true)
        }
    }
    
    func qrCodeButtonAction(sender : UIButton) {
        let userQRVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACUserQrCodeVCID") as! ACUserQrCodeVC
        userQRVC.qrCodeImage = self.userInfo.qrImage
        self.navigationController?.pushViewController(userQRVC, animated: true)
    }

    // MARK: - UITableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let qrCodeCell = tableView.dequeueReusableCellWithIdentifier("ACQRCodeTVCellID", forIndexPath: indexPath) as! ACQRCodeTVCell
        qrCodeCell.detailLabel.text = userInfo.userInfoHandlers //userInfo.userDetail
        qrCodeCell.qrCodeImageView.sd_setImageWithURL(NSURL(string: self.userInfo.qrImage),placeholderImage: UIImage(named: "qrLSPlaceholder"))
        qrCodeCell.qrCodeButton.addTarget(self, action: #selector(ACProfileVC.qrCodeButtonAction(_:)), forControlEvents: .TouchUpInside)
        return qrCodeCell
    }
    
    // MARK: - UITableView Delegate Methods
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK:- Web API Methods
    func callApiForProfile() {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            let params: [String : AnyObject] = [
                "user": dict ,
                
                ]
            ServiceHelper.sharedInstance.createPostRequest(params, apiName: "user_apis/profile", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.userInfo = ACUserInfo.getProfileInfo(res.objectForKeyNotNull("user", expected: NSDictionary())as! NSDictionary)
                        self.usernameLabel.text = self.userInfo.userName
                        self.emailLabel.text = self.userInfo.userEmail
                        self.userImageView.sd_setImageWithURL(NSURL(string: self.userInfo.userImage),placeholderImage: UIImage(named: "user"))
                        self.myAccountTblView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }    
}
