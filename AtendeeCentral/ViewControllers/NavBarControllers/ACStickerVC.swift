//
//  ACStickerVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACStickerVC: UIViewController ,UICollectionViewDataSource , UICollectionViewDelegate {

    var stickerArray = NSMutableArray()
    
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
        stickerArray = ["emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2"]
    }

    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    //MARK:- UICollection View Datasources
    internal func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        return stickerArray.count
    }

func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ACStickerCVCellID", forIndexPath: indexPath) as! ACStickerCVCell
    let img = stickerArray[indexPath.row]
    cell.stickerImageView.image = UIImage(named:img as! String )
    // Configure the cell
    return cell
}
}
