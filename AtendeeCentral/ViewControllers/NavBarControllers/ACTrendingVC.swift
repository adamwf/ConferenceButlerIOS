//
//  ACTrendingVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACTrendingVC: UIViewController {

    @IBOutlet weak var trendingTblView: UITableView!
    var trendingArray = NSMutableArray()
    var pageNo : NSInteger = 1
    var maxPageNo : NSInteger = 1
    
    var adImg : String = ""
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.trendingArray.removeAllObjects()
        pageNo = 1
        callApiForTrendingList(pageNo)
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Trending"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        trendingTblView.estimatedRowHeight = 100.0
        trendingTblView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc func viewUserProfile(button : UIButton) {
        self.view .endEditing(true)
        let userProfileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACGABUserProfileVCID") as! ACGABUserProfileVC
        userProfileVC.isFromQRCode = false
        print(button.tag)
        let trends = trendingArray.objectAtIndex(button.tag - 101) as! ACUserInfo
        userProfileVC.strUserID = trends.userID
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
          return trendingArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 && NSUserDefaults.standardUserDefaults().valueForKey("ACPaymentType") as! String == "free" {
            let cell = tableView.dequeueReusableCellWithIdentifier("ACAdTVCellID", forIndexPath: indexPath) as! ACAdTVCell
            cell.adImgView.sd_setImageWithURL(NSURL(string: adImg), placeholderImage: UIImage(named: "plc_evntLarge"))
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ACViewersTVCellID", forIndexPath: indexPath) as!
            ACViewersTVCell
            let trends = trendingArray.objectAtIndex(NSUserDefaults.standardUserDefaults().valueForKey("ACPaymentType") as! String == "free" ? indexPath.row - 1 : indexPath.row) as! ACUserInfo
            cell.viewersUserName.text = trends.userName
            cell.viewersImgView.sd_setImageWithURL(NSURL(string:trends.userImage), placeholderImage: UIImage(named: "user"))
            cell.selectionButton.tag = indexPath.row + 100
            cell.selectionButton.addTarget(self, action: #selector(viewUserProfile(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
    }
    
    //MARK:- Tableview Delegate Methods
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40.0 && pageNo < maxPageNo+1) {
            pageNo += 1
            callApiForTrendingList(pageNo)
        }
    }
    


    //MARK:- Web API Methods
    func callApiForTrendingList(pageNo:NSInteger) {
        if kAppDelegate.hasConnectivity() {
            let params: [String : AnyObject] = [ "page" : pageNo ]
            ServiceHelper.sharedInstance.createGetRequest(params, apiName: "event_apis/trending", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.trendingArray.addObjectsFromArray(ACUserInfo.getTrendingList(res) as [AnyObject])
                        self.adImg = (((res.objectForKeyNotNull("ads", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("image", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("standard", expected: NSDictionary()) as! NSDictionary).objectForKeyNotNull("url", expected: "") as! String
                        self.maxPageNo = res.objectForKeyNotNull("total_pages", expected: 0) as! NSInteger
                        self.trendingTblView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
 
}
