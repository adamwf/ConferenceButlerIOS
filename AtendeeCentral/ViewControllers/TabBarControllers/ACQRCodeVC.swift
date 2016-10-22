//
//  ACQRCodeVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import AVFoundation

class ACQRCodeVC: UIViewController,QRCodeReaderViewControllerDelegate {

    @IBOutlet var scanButton: UIButton!
    @IBOutlet var codeScrollView: UIScrollView!
    lazy var reader = QRCodeReaderViewController(builder: QRCodeViewControllerBuilder {
        $0.reader          = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        $0.showTorchButton = true
        })
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    // MARK: - Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    func customInit() {
        let titleLabel = UILabel(frame:CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,44))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.attributedText = getAttributedText("Scan a AttendeeQRTM and Follow", position: 13)
        self.navigationController?.navigationBar.topItem?.titleView = titleLabel
        
        //        scanButton.setAttributedTitle(getAttributedText("Scan HandleQRTM", position: 2), forState: .Normal)
                }
    
    func getAttributedText(str : String,position : NSInteger) -> NSMutableAttributedString {
        let font:UIFont? = UIFont(name:"VarelaRound", size:13)
        let fontSuper:UIFont? = UIFont(name: "VarelaRound", size:(NSUserDefaults.standardUserDefaults().valueForKey("size") as! CGFloat) - 10)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str, attributes: [NSFontAttributeName:font!])
        attString.setAttributes([NSFontAttributeName:fontSuper!,NSBaselineOffsetAttributeName:6], range: NSRange(location:attString.length-position,length:2))
        return attString
    }
    
    
    //MARK:- UIButton Action Methods
    
    @IBAction func scanQRButtonAction(sender: UIButton) {
        
        if QRCodeReader.supportsMetadataObjectTypes() {
            reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: QRCodeReaderResult?) in
                if let result = result {
                    print("Completion with result: \(result.value) of type \(result.metadataType)")
                }
            }
            
            presentViewController(reader, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        self.dismissViewControllerAnimated(true) { [weak self] in
            print("QRCode=>",result.value)
            let GABVC = self!.storyboard?.instantiateViewControllerWithIdentifier("ACGABUserProfileVCID") as! ACGABUserProfileVC
            GABVC.strQRCode = result.value //"dcb53ac2965b9233"
            GABVC.isFromQRCode = true
            
            self?.navigationController?.pushViewController(GABVC, animated: true)
        }
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
