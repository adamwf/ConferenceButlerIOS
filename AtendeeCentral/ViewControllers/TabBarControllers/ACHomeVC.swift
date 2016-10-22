//
//  ACHomeVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import MediaPlayer

class ACHomeVC: ACBaseVC  {
    @IBOutlet var homeTableView: UITableView!
    var homeArray = NSMutableArray()
    var pageNo : NSInteger = 1
    var maxPageNo : NSInteger = 1
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         homeArray.removeAllObjects()
        pageNo = 1
         callApiForFeedsList(pageNo)
    }
    
    // MARK: - Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Home"
        homeTableView.estimatedRowHeight = 250.0
        homeTableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.rightBarButtonItems = ACAppUtilities.rightBarButtonArray(["T","D","G"],controller: self) as? [UIBarButtonItem]
        self.navigationItem.leftBarButtonItems = ACAppUtilities.leftBarButtonArray(["E","S","R"],controller: self) as? [UIBarButtonItem]
    }
    
    func getDummyData() {
        let tempDictOne : NSMutableDictionary = ["feedID" : "100","feedTitle" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod.","feedImage" : "ban","feedURL" : "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v","feedAd" : ""]
        let tempDictTwo : NSMutableDictionary = ["feedID" : "100","feedTitle" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod.","feedImage" : "ban","feedURL" : "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v","feedAd" : ""]
        let tempDictThree : NSMutableDictionary = ["feedID" : "100","feedTitle" : "","feedImage" : "","feedURL" : "","feedAd" : "ad"]
        let tempDictFour : NSMutableDictionary = ["feedID" : "100","feedTitle" : "John you are the best man, just keep it up I am waiting","feedImage" : "","feedURL" : "","feedAd" : ""]
        let tempDictFive : NSMutableDictionary = ["feedID" : "100","feedTitle" : "Yeah man I make the things more easier for you just give me some time","feedImage" : "ban","feedURL" : "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v","feedAd" : ""]
        let tempArray : NSMutableArray = [tempDictOne,tempDictTwo,tempDictThree,tempDictFour,tempDictFive]
        let response = NSMutableDictionary()
        response.setValue(tempArray, forKey: "feedsArray")
        
        homeArray = ACFeedsInfo.getFeedsInfo(response)
        homeTableView.reloadData()
    }
    
    func getPreviewImageForVideoAtURL(videoURL: NSURL, atInterval: Int ,senderTag : Int) {
        var frameImg : UIImage!
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
        print("Taking pic at \(atInterval) second")
        let asset = AVAsset(URL: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(atInterval), 10)
        let operationQueue = NSOperationQueue()
        
        let operation1 : NSBlockOperation = NSBlockOperation (block: {
            do {
                let img = try assetImgGenerate.copyCGImageAtTime(time, actualTime: nil)
                frameImg = UIImage(CGImage: img)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let kImageView = getViewWithTag(senderTag, view: self.view) as? UIImageView
                    kImageView?.image = frameImg
                })
                
            } catch {
                /* error handling here */
            }
        })
        operationQueue.addOperation(operation1)
    }
    
    func leftBarButtonsAction(button : UIButton) {
        print(button.tag)
        self.view .endEditing(true)
        if button.tag == 200 {
            let eventsVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACEventsVCID")
            
            self.navigationController?.pushViewController(eventsVC!, animated: true)
        } else if button.tag == 201 {
            let shopVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACShopVCID")
            self.navigationController?.pushViewController(shopVC!, animated: true)
        } else {
            let requestsVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACRequestsVCID")
            self.navigationController?.pushViewController(requestsVC!, animated: true)
        }
    }
    
    func rightBarButtonsAction(barbutton : UIButton) {
        self.view .endEditing(true)
        if barbutton.tag == 100 {
            let trendingVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACTrendingVCID")
            self.navigationController?.pushViewController(trendingVC!, animated: true)
        } else if barbutton.tag == 101 {
            let discoverVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACDiscoverVCID")
            self.navigationController?.pushViewController(discoverVC!, animated: true)
        } else {
            let stickerVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACStickerVCID")
            self.navigationController?.pushViewController(stickerVC!, animated: true)
        }
    }
    
    func playVideo(sender : UIButton) {
        let feedObj = homeArray[sender.tag - 100] as! ACFeedsInfo
        self.presentMovieController(feedObj.feedVideoURL)
    }
    
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return homeArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let feedObj = homeArray[indexPath.row] as! ACFeedsInfo
        print(NSUserDefaults.standardUserDefaults().valueForKey("ACPaymentType"))
        if feedObj.feedAdImg != nil && NSUserDefaults.standardUserDefaults().valueForKey("ACPaymentType") as! String == "free" {
            let cell = tableView.dequeueReusableCellWithIdentifier("ACAdTVCellID", forIndexPath: indexPath) as! ACAdTVCell
            cell.adImgView.sd_setImageWithURL(feedObj.feedAdImg, placeholderImage: UIImage(named: ""))
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ACHomeTVCellID", forIndexPath: indexPath) as! ACHomeTVCell
            cell.feedImageView.tag = indexPath.row
            //            self.getPreviewImageForVideoAtURL(feedObj.feedVideoURL!,atInterval:3,senderTag: indexPath.row)
            
            if feedObj.feedVideoURL == "" {
                cell.staticPostLabel.text = "Post"
                cell.feedDescriptionLabel.text = feedObj.feedTitle
                cell.heightConstraintImgView.constant = 0
            } else {
                cell.staticPostLabel.text = ""
                cell.heightConstraintImgView.constant = 220
                cell.feedDescriptionLabel.text = ""
                cell.feedImageView.sd_setImageWithURL(NSURL(string:feedObj.feedThumbnail), placeholderImage: UIImage(named: "play_button"))
            }
            cell.feedPlayButton.tag = 100 + indexPath.row
            cell.feedPlayButton.addTarget(self, action: #selector(playVideo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            return cell
        }
    }
    
    //MARK:- Tableview Deleagte Methods
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (maximumOffset - currentOffset <= -40.0 && pageNo < maxPageNo+1) {
            pageNo += 1
            callApiForFeedsList(pageNo)
        }
    }
    
    //MARK:- MPMovie Player
    func presentMovieController(url : NSString){
        var movieViewController : MPMoviePlayerViewController?
        let url = NSURL(string: url as String)!
        movieViewController = MPMoviePlayerViewController(contentURL: url)
        movieViewController?.moviePlayer.scalingMode = MPMovieScalingMode.AspectFit
        movieViewController?.moviePlayer.fullscreen = true
        movieViewController?.moviePlayer.controlStyle = .Embedded
        let headerView = UIView()
        headerView.frame = CGRectMake(0, 0, Window_Height, 64)
        headerView.backgroundColor = UIColor.blackColor()
        let backButton = UIButton()
        backButton.frame = CGRectMake(20, 24, 20, 20)
        backButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: #selector(movieFinish(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(backButton)
        movieViewController?.view.addSubview(headerView)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(moviePlayBackDidFinish(_:)),
            name: MPMoviePlayerPlaybackDidFinishNotification,
            object: movieViewController?.moviePlayer)
        self.presentMoviePlayerViewControllerAnimated(movieViewController)
    }
    
    @objc func moviePlayBackDidFinish(notification: NSNotification){
        let moviePlayer:MPMoviePlayerController = notification.object as! MPMoviePlayerController
        
        moviePlayer.view.removeFromSuperview()
        self.dismissMoviePlayerViewControllerAnimated()
    }
    
    @objc func movieFinish(sender: UIButton){
        self.dismissMoviePlayerViewControllerAnimated()
    }

    //MARK:- Web API Methods
    func callApiForFeedsList(pageNo:NSInteger) {
        if kAppDelegate.hasConnectivity() {
            let dict = NSMutableDictionary()
            dict[ACUserId] = NSUserDefaults.standardUserDefaults().valueForKey("ACUserID")
            let params: [String : AnyObject] = [
                "page" : pageNo
            ]
            ServiceHelper.sharedInstance.createGetRequest(params, apiName: "event_apis/home", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.homeArray.addObjectsFromArray(ACFeedsInfo.getFeedsInfo(res) as [AnyObject])
                        self.maxPageNo = res.objectForKeyNotNull("total_pages", expected: 0) as! NSInteger
                        self.homeTableView.reloadData()
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }

}
