//
//  ACGroupParticipantsListVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 09/09/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACGroupParticipantsListVC: UIViewController {

    let dict: NSMutableDictionary? = [
        "name" : "Kris Stewart",
        "profileImage" : "user1",
        ]
    let dict1: NSMutableDictionary? = [
        "name" : "Angelina",
        "profileImage" : "user2",
        ]
    let dict2: NSMutableDictionary? = [
        "name" : "Veronita",
        "profileImage" : "user2",
        ]
    
    var  groupusersArray = NSMutableArray()
    @IBOutlet var groupTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        groupusersArray = [dict!,dict1!,dict2!]
        groupTableView.reloadData()
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Methods
    func customInit() {
        self.navigationItem.title = "Group Participants"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- Tableview Datasource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return groupusersArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACGroupTVCellID", forIndexPath: indexPath) as! ACGroupTVCell
        let dict = groupusersArray [indexPath.row]
        cell.userNameLabel.text = dict["name"] as? String
        cell.userProfileImageView.image = UIImage(named: dict["profileImage"]! as! String)
        return cell
    }
    
   
}
