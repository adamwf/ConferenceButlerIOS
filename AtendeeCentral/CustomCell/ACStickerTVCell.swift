//
//  ACStickerTVCell.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 27/10/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACStickerTVCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var selectionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row + 100
        collectionView.reloadData()
    }
}
