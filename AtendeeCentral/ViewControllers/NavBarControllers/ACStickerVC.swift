//
//  ACStickerVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

let collectionOneDict: NSMutableDictionary? = [
    "collectionId" : 1,
    "isSelection" : false as Bool,
    "stickerArray" : NSArray(objects: "emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2")
]

let collectionTwoDict: NSMutableDictionary? = [
    "collectionId" : 2,
    "isSelection" : false as Bool,
    "stickerArray" : NSArray(objects: "emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2")
]

let collectionThreeDict: NSMutableDictionary? = [
    "collectionId" : 3,
    "isSelection" : false as Bool,
    "stickerArray" : NSArray(objects: "emo1","emo2","emo3","emo1","emo2")
]

let collectionFourDict: NSMutableDictionary? = [
    "collectionId" : 4,
    "isSelection" : false as Bool,
    "stickerArray" : NSArray(objects: "emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2,emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2")
]

let collectionFiveDict: NSMutableDictionary? = [
    "collectionId" : 5,
    "isSelection" : false as Bool,
    "stickerArray" : ["emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2"]
]

class ACStickerVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    var collectionArray = NSMutableArray()
    
    @IBOutlet weak var stickerTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Methods
    func customInit() {
        self.navigationItem.title = "Sticker/Emos"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        collectionArray = [collectionOneDict!,collectionTwoDict!,collectionThreeDict!,collectionFourDict!,collectionFiveDict!]
        let response = NSMutableDictionary()
        response.setValue(collectionArray, forKey: "collectionArray")
        
        self.collectionArray = ACStickerinfo.getStickerCollection(response)
        stickerTableView.reloadData()
    }

    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc func selectCollectionButtonAction(button : UIButton) {
        self.view .endEditing(true)
        let collectionObj = collectionArray.objectAtIndex(button.tag - 100) as? ACStickerinfo
        for case let item as ACStickerinfo in collectionArray {
            item.isSelectedStickerCollection = false
        }
        collectionObj?.isSelectedStickerCollection = true
        stickerTableView.reloadData()
    }

    //MARK:- UITableView Delegates and Datasources
     func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return collectionArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ACStickerTVCellID", forIndexPath: indexPath) as! ACStickerTVCell
        
         let collectionObj = collectionArray.objectAtIndex(indexPath.row) as? ACStickerinfo
        cell.selectionButton.selected = (collectionObj?.isSelectedStickerCollection)!
        cell.selectionButton.tag = indexPath.row + 100
        cell.selectionButton.addTarget(self, action: #selector(selectCollectionButtonAction(_:)), forControlEvents: .TouchUpInside)
        return cell
    }
    
     func tableView(tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? ACStickerTVCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    //MARK:- UICollectionView Delegates and Datasources
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ACStickerCVCellID", forIndexPath: indexPath) as! ACStickerCVCell
        let collectionObj = collectionArray.objectAtIndex(collectionView.tag - 100) as? ACStickerinfo
                let img = collectionObj?.stickerArr[indexPath.item]
                cell.stickerImageView.image = UIImage(named:img as! String )
                return cell

    }
}

//func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//    
//    return CGSize(width: (Window_Width/30)-20, height: 50);
//    
//}

extension ACStickerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        print(collectionView.tag)
        let collectionObj = collectionArray.objectAtIndex(collectionView.tag - 100) as? ACStickerinfo
        return (collectionObj?.stickerArr.count)!
    }
    
    
}
