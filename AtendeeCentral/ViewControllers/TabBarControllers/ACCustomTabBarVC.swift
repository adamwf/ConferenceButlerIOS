//
//  ACCustomTabBarVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACCustomTabBarVC: UIViewController {
    var navMessage: UINavigationController!
    var navContact: UINavigationController!
    var navHome: UINavigationController!
    var navProfile: UINavigationController!
    var navUser: UINavigationController!
    var navQRCode: UINavigationController!
    
    var viewMessage: ACInboxVC!
    var viewContacts: ACContactVC!
    var viewHome: ACHomeVC!
    var viewProfile: ACProfileVC!
    var viewUser: ACUserVC!
    var viewQRCode: ACQRCodeVC!
    
    var controllerArray : NSMutableArray!
    var controller : UINavigationController!
    @IBOutlet weak var leadingConstraintBubbleView: NSLayoutConstraint!
    @IBOutlet var tabBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var bottomConstraintContentView: NSLayoutConstraint!
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
        self.customInit()
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Helper Methods
    func setHomeTab(note : NSNotification) {
        let userInfo : [String:String!] = note.userInfo as! [String:String!]
        self.setSelectedController(NSInteger((userInfo["tabValue"]! as NSString).integerValue))
    }
    
    func customInit() {
        NSNotificationCenter.defaultCenter().addObserverForName(
            "tabViewChangeNotification",
            object: nil, queue: nil,
            usingBlock:{
                [unowned self] note in
                self.methodOFReceivedNotication(note)
            })
        NSNotificationCenter.defaultCenter().addObserverForName(
            "setHomeTab",
            object: nil, queue: nil,
            usingBlock:{
                [unowned self] note in
                self.setHomeTab(note)
            })
        
        self.navigationController?.navigationBarHidden = true
        self.viewMessage = self.storyboard?.instantiateViewControllerWithIdentifier("ACInboxVCID") as! ACInboxVC
        self.viewContacts = self.storyboard?.instantiateViewControllerWithIdentifier("ACContactVCID") as! ACContactVC
        self.viewHome = self.storyboard?.instantiateViewControllerWithIdentifier("ACHomeVCID") as! ACHomeVC
        self.viewProfile = self.storyboard?.instantiateViewControllerWithIdentifier("ACProfileVCID") as! ACProfileVC
        self.viewUser = self.storyboard?.instantiateViewControllerWithIdentifier("ACUserVCID") as! ACUserVC
        self.viewQRCode = self.storyboard?.instantiateViewControllerWithIdentifier("ACQRCodeVCID") as! ACQRCodeVC
        self.navMessage = UINavigationController(rootViewController: self.viewMessage)
        self.navContact = UINavigationController(rootViewController: self.viewContacts)
        self.navHome = UINavigationController(rootViewController: self.viewHome)
        self.navProfile = UINavigationController(rootViewController: self.viewProfile)
        self.navUser = UINavigationController(rootViewController: self.viewUser)
        self.navQRCode = UINavigationController(rootViewController: self.viewQRCode)
        
        controllerArray = [self.navMessage,self.navContact,self.navHome,self.navProfile,self.navUser,self.navQRCode]
        self.setSelectedController(5002)
        let kButton = getViewWithTag(5002, view: self.view) as? UIButton
        kButton?.selected = true
    }
    
    @IBAction func commonTabButtonAction(sender: UIButton) {
        for i in (5000...5005) {
            let kButton = getViewWithTag(i, view: self.view) as? UIButton
            if i==sender.tag {
                sender.selected = true
                self.setSelectedController(i)
            } else {
                kButton!.selected = false
            }
        }
    }
    
    func setSelectedController(index : NSInteger){
        for subview in containerView.subviews {
            subview.removeFromSuperview()
        }
        for i in (5000...5005) {
            let kButton = getViewWithTag(i, view: self.view) as? UIButton
            if i==index {
                leadingConstraintBubbleView.constant = ((kButton?.frame.size.width)! * CGFloat(i - 5000))
                UIView.animateWithDuration(0.2 ,
                                           animations: {
                                            kButton!.transform = CGAffineTransformMakeScale(0.6, 0.6)
                                            kButton!.selected = true

                    },
                                           completion: { finish in
                                            UIView.animateWithDuration(0.4){
                                                kButton!.transform = CGAffineTransformIdentity
                                            }
                })
            } else {
                kButton!.selected = false
            }
        }
        controller = controllerArray[index - 5000] as! UINavigationController
        controller.view.frame = containerView.bounds
        containerView.addSubview(controller.view)
        self.addChildViewController(controller)
        controller.didMoveToParentViewController(self)
        if (controller.topViewController!.isKindOfClass(ACChatVC) || controller.topViewController!.isKindOfClass(ACTravelChatVC)) {
            self.bottomConstraintContentView.constant = 0
            self.controller.view.frame = self.containerView.bounds
        } else {
            self.bottomConstraintContentView.constant = 70
        }
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    func methodOFReceivedNotication(note : NSNotification) {
        let userInfo : [String:String!] = note.userInfo as! [String:String!]
        
            if (userInfo["hiddenTrue"] == "0"){
                self.bottomConstraintContentView.constant = 0
            } else {
                self.bottomConstraintContentView.constant = 70
            }
        print(NSStringFromCGRect(self.controller.view.frame))
        print(NSStringFromCGRect(self.containerView.frame))
        self.controller.view.frame = self.containerView.frame
        self.view.layoutSubviews()
        self.view.layoutIfNeeded()
    }
    
}