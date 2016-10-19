//
//  ACBaseVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 03/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACBaseVC: UIViewController {
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
    }
    
    // MARK: - Memory Management Method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func setupInit() {
        let bgImageView = UIImageView(image: UIImage(named: "bg"))
        bgImageView.frame = CGRectMake(0, -64, Window_Width, Window_Height+64)
        self.view.addSubview(bgImageView);
        self.view.sendSubviewToBack(bgImageView)
    }
}
