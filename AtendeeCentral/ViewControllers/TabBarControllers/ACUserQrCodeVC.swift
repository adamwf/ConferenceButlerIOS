//
//  ACUserQrCodeVC.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 06/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import AVFoundation

class ACUserQrCodeVC: UIViewController {

    @IBOutlet var codeScrollView: UIScrollView!
    @IBOutlet var qrCodeImageView: UIImageView!
    @IBOutlet var saveToGalleryButton: UIButton!
    var qrCodeImage : String!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Helper Method
    func customInit() {
        self.navigationItem.title = "AttendeeQR"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        qrCodeImageView.sd_setImageWithURL(NSURL(string: qrCodeImage), placeholderImage: UIImage(named: "qrLPlaceholder"))
        activityIndicator.hidden = true
    }
    
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK:- UIButton Action Methods
    @IBAction func saveToGalleryButtonAction(sender: UIButton) {
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        UIImageWriteToSavedPhotosAlbum(qrCodeImageView.image!, self, #selector(ACUserQrCodeVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        if error == nil {
            AlertController.alert("", message: "AttendeeQR saved successfully.")
        } else {
            AlertController.alert("", message: "Unable to save this AttendeeQR.")
            return
        }
    }
}
