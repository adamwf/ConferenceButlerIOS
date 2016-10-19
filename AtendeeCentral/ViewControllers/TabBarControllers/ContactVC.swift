//
//  ContactVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 09/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ContactVC: UIViewController {

    let dict: NSMutableDictionary? = [
        "name" : "Neha",
        "userName" : "neha1004",
        "email" : "neha@gmail.com",
        "profileImage" : "user",
        ]
    
    var  userProfileArray = NSMutableArray()
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var sortButton: UIButton!
    
    @IBOutlet weak var gabTblView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Mark:- Helper Methods
    func customInit() {
        self.navigationItem.title = "Global Address Book"
        sortButton.layer.cornerRadius = 5
        sortButton.clipsToBounds = true
        let padView =  UIView(frame: CGRectMake(0, 0, 10, searchTextField.frame.size.height))
        searchTextField.leftView = padView;
        searchTextField.leftViewMode = UITextFieldViewMode.Always
        searchTextField.attributedPlaceholder = NSAttributedString(string: searchTextField.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.whiteColor() ,NSFontAttributeName : UIFont(name:"Raleway-Regular", size:16)!])
        gabTblView.estimatedRowHeight = 100
        gabTblView.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACGABUserTVCellID", forIndexPath: indexPath) as! ACGABUserTVCell
        let dict = userProfileArray [indexPath.row]
        cell.nameLabel.text = dict["name"] as? String
        cell.userImageView.image = UIImage(named: dict["profileImage"]! as! String)
        cell.userNameLabel.text = dict["userName"] as? String
        cell.userEmailIdLabel.text = dict["email"] as? String
        cell.messageLabel.text = "Message"
        return cell
    }
    
    //MARK:- Tableview Delegate Methods
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
    }
    
    //MARK:- UIButton Actions
    @IBAction func sortButtonAction(sender: UIButton) {
        self.view.endEditing(true)
    }
    
    // MARK: TextField Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view .endEditing(true)
        return true
    }



}
