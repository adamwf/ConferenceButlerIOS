//
//  ACTermsAndConditionVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 05/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACTermsAndConditionVC: UIViewController {

    @IBOutlet weak var termsTextView: UITextView!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        self.navigationItem.title = "Terms and Conditions"
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

}
