//
//  ACFontChangeVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACFontChangeVC: UIViewController {

    var itemArray = NSMutableArray()
    @IBOutlet weak var fontChngTableView: UITableView!

    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    //MARK:- Memory Management methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Choose the best Font size"
        self.navigationItem.leftBarButtonItem = self.leftBarButton("backArrow")
        itemArray = ["This is an Example","This is an Example","This is an Example","This is an Example","This is an Example","This is an Example"]
    }
    
    func leftBarButton(imageName : NSString) -> UIBarButtonItem {
        
        let button:UIButton = UIButton.init(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 20, 20)
        button.setImage(UIImage(named: imageName as String), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(leftBarButtonAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        
        return leftBarButtonItem
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
        settingCell.itemNameLabel.text = itemArray.objectAtIndex(indexPath.row) as? String
        if indexPath.row == NSUserDefaults.standardUserDefaults().objectForKey("rowValue")?.integerValue {
            settingCell.selectButton.selected = true
        } else {
            settingCell.selectButton.selected = false
        }
        switch indexPath.row {
        case 0:
            settingCell.itemNameLabel.font = UIFont(name:"Raleway-Regular", size:20)
            break
        case 1:
            settingCell.itemNameLabel.font = UIFont(name:"Raleway-Regular", size:18)
            break
        case 2:
            settingCell.itemNameLabel.font = UIFont(name:"Raleway-Regular", size:16)
            break
        case 3:
            settingCell.itemNameLabel.font = UIFont(name:"Raleway-Regular", size:14)
            break
        case 4:
            settingCell.itemNameLabel.font = UIFont(name:"Raleway-Regular", size:12)
            break
        default:
            settingCell.itemNameLabel.font = UIFont(name:"Raleway-Regular", size:10)
            break
        }
        return settingCell
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row, inSection:0)) as! WFSettingTVCell
        //        cell.selectButton.selected = !cell.selectButton.selected
        switch indexPath.row {
        case 0:
            NSUserDefaults.standardUserDefaults().setValue(20, forKey: "size")
            break
        case 1:
            NSUserDefaults.standardUserDefaults().setValue(18, forKey: "size")
            break
        case 2:
            NSUserDefaults.standardUserDefaults().setValue(16, forKey: "size")
            break
        case 3:
            NSUserDefaults.standardUserDefaults().setValue(14, forKey: "size")
            break
        case 4:
            NSUserDefaults.standardUserDefaults().setValue(12, forKey: "size")
            break
        default:
            NSUserDefaults.standardUserDefaults().setValue(10, forKey: "size")
            break
        }
        NSUserDefaults.standardUserDefaults().setObject(String(format: "%d", indexPath.row), forKey: "rowValue")
        NSUserDefaults.standardUserDefaults().synchronize()
        fontChngTableView.reloadData()
    }
    
    // MARK: - UIButton Action Methods
    @IBAction func applyButtonAction(sender: UIButton) {
        AlertController.alert("", message: "Font has been updated successfully.", buttons: ["OK"], tapBlock: { (alertAction, position) -> Void in
            if position == 0 {
                NSNotificationCenter.defaultCenter().postNotificationName("size", object: nil, userInfo:["size": (NSUserDefaults.standardUserDefaults().valueForKey("size")?.stringValue)!])
                
            }
        })
    }


}
