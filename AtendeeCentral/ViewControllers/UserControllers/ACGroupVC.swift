//
//  ACGroupVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 10/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
@objc protocol customGroupDelegate{
    optional func sendDataBack(selectedArray : NSMutableArray, groupImage : UIImage, groupName : String)
}

class ACGroupVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    var delegate: customGroupDelegate?
    
    @IBOutlet var groupImageView: UIImageView!
    @IBOutlet weak var groupImageButton: UIButton!
    
    var  groupUsersArray : NSMutableArray!
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    var groupImage : UIImage = UIImage(named: "user")!
    var groupName : String = ""
    
    @IBOutlet var groupTableView: UITableView!
    @IBOutlet var groupNameTextField: UITextField!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        groupTableView.reloadData()
        groupNameTextField.text = groupName
        groupImageView.image = groupImage
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Methods
    func customInit() {
        self.navigationItem.title = "Group/Thread"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        getRoundImage(groupImageView)
        getRoundButton(groupImageButton)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            picker?.delegate = self
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            picker?.navigationBar.tintColor = UIColor.whiteColor()
            self .presentViewController(picker!, animated: true, completion: nil)
        } else {
            openGallery()
        }
    }
    
    func openGallery() {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker?.delegate = self
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(picker!, animated: true, completion: nil)
            picker?.navigationBar.tintColor = UIColor.whiteColor()
        } else {
            popover=UIPopoverController(contentViewController: picker!)
            popover!.presentPopoverFromRect(groupImageButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker .dismissViewControllerAnimated(true, completion: nil)
        groupImageView.image = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        groupImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        //        self.imageData = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as? UIImage, 0.6)
        //sets the selected image to image view
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker .dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
        delegate?.sendDataBack!(groupUsersArray,groupImage: groupImageView.image!,groupName: groupNameTextField.text!)
    }

    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return groupUsersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACGroupTVCellID", forIndexPath: indexPath) as! ACGroupTVCell
         let friendsObj = groupUsersArray.objectAtIndex(indexPath.row) as! ACFriendsInfo
        cell.userNameLabel.text = friendsObj.userName
        cell.userProfileImageView.sd_setImageWithURL(NSURL(string: friendsObj.userImage), placeholderImage: UIImage(named: "user"))
        return cell
    }

     //MARK:- TextField Delegate Methods
    func textFieldDidEndEditing(textField: UITextField) {
        groupName = textField.text!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK:- UIButton Action Methods
    @IBAction func addParticipantsButtonAction(sender: UIButton) {
        let groupChatVC = self.storyboard?.instantiateViewControllerWithIdentifier("ACGroupChatVCID") as! ACGroupChatVC
        self.navigationController?.pushViewController(groupChatVC, animated: true)    }

    @IBAction func groupImageButtonAction(sender: UIButton) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        // Present the actionsheet
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            popover=UIPopoverController(contentViewController: alert)
            popover!.presentPopoverFromRect(groupImageButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
}
