//
//  ACTravelChatVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 11/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import MediaPlayer
import AVKit

class ACTravelChatVC:  UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    @IBOutlet var chatTableView: UITableView!
    var chatArray = NSMutableArray()
    @IBOutlet weak var chatDescriptionImageView: UIImageView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet var bottomConstraintChatView: NSLayoutConstraint!
    
    @IBOutlet weak var chatTitleLabel: UILabel!
    
    @IBOutlet var statusLabel: UILabel!
    
    @IBOutlet weak var audioPickerView: UIView!
    
    @IBOutlet weak var audioPickerBgView: UIView!
    
    @IBOutlet weak var recordAudioButton: UIButton!
    
    @IBOutlet weak var playAudioButton: UIButton!
    
    @IBOutlet weak var deleteAudioButton: UIButton!
    
    @IBOutlet weak var useAudioButton: UIButton!
    
    var stickerArray = NSMutableArray()
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    var meterTimer:NSTimer!
    var soundFileURL:NSURL!
    var index:NSInteger!
    
    @IBOutlet weak var heightConstraintCollectionView: NSLayoutConstraint!
    
    var pickerController:UIImagePickerController?=UIImagePickerController()
    private var texts = ["Edit", "Delete", "Report"]
    
    private var popover: Popover!
    private var popoverOptions: [PopoverOption] = [
        .Type(.Down),
        .BlackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName("tabViewChangeNotification", object: nil,userInfo:["hiddenTrue" : "0"] )
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().postNotificationName("tabViewChangeNotification", object: nil,userInfo:["hiddenTrue" : "1"] )
    }
    
    // MARK: - Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper Methods
    func customInit() {
        NSNotificationCenter.defaultCenter().postNotificationName("tabViewChangeNotification", object: nil,userInfo:["hiddenTrue" : "0"] )
        self.navigationItem.title = "Travel Chat"
        self.navigationItem.leftBarButtonItems = ACAppUtilities.leftBarButtonArray(["nav_ic4","nav_ic7"], controller: self) as? [UIBarButtonItem]
      
        chatTableView.estimatedRowHeight = 80.0
        chatTableView.rowHeight = UITableViewAutomaticDimension
        sendButton.layer.cornerRadius = 5.0
        sendButton.clipsToBounds = true
        sendButton.layer.borderWidth = 1.0
        sendButton.layer.borderColor = UIColor.blackColor().CGColor
        audioPickerView.layer.cornerRadius = 10.0
        audioPickerView.clipsToBounds = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ACChatVC.keyboardWillAppear), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ACChatVC.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        self.getDummyData()
    }
    
    // MARK: - Selector Methods
    func leftBarButtonsAction(button : UIButton) {
        print(button.tag)
        self.view .endEditing(true)
        if button.tag == 200 {
            self.navigationController?.popViewControllerAnimated(true)
        } else if button.tag == 201 {
           NSNotificationCenter.defaultCenter().postNotificationName("setHomeTab", object: nil,userInfo:["tabValue" : "5002"] )
        } else {
            AlertController.alert("Not Defined")
        }
    }

    func getDummyData() {
         stickerArray = ["emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2","emo3","emo1","emo2"]
        let tempDict : NSMutableDictionary = ["userImage" : "user","message" : "This a dummy message from a new sender","time" : "2.00","isReceiver" : false,"isAudio" : false,"isImage" : false,"isVideo" : false, "image" : "","video" : "", "audio" : ""]
        let tempArray : NSMutableArray = [tempDict]
        let response = NSMutableDictionary()
        response.setValue(tempArray, forKey: "chatArray")
        
        chatArray = ACChatInfo.getChatInfo(response)
        chatTableView.reloadData()
    }
    
    func getChatDummyData(chatText : String, isAudio : Bool, isImage : Bool ,isVideo : Bool, image : String, video : String,audio : String ) {
        let tempDict : NSMutableDictionary = ["userImage" : "user1","message" : chatText,"time" : "2.00","isReceiver" : true,"isAudio" : isAudio,"isImage" : isImage,"isVideo" : isVideo, "image" : image,"video" : video, "audio" : audio]
        let tempArray : NSMutableArray = [tempDict]
        let response = NSMutableDictionary()
        response.setValue(tempArray, forKey: "chatArray")
        print("before",chatArray.count)
        
        let arr = ACChatInfo.getChatInfo(response)
        let modal = arr.lastObject!
        chatArray .addObject(modal)
        print(chatArray.count)
        chatTableView.reloadData()
        
        if chatArray.count > 1 {
            let indexPath = NSIndexPath(forRow: chatArray.count-1, inSection: 0)
            chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
    }
    
    //    func directoryURL() -> NSURL? {
    //        let fileManager = NSFileManager.defaultManager()
    //        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    //        let documentDirectory = urls[0] as NSURL
    //        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
    //        return soundURL
    //    }
    
    func updateAudioMeter(timer:NSTimer) {
        
        if audioRecorder != nil && audioRecorder.recording {
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime % 60)
            let s = String(format: "%02d:%02d", min, sec)
            statusLabel.text = s
            audioRecorder.updateMeters()
            // if you want to draw some graphics...
            //var apc0 = recorder.averagePowerForChannel(0)
            //var peak0 = recorder.peakPowerForChannel(0)
        } else if audioPlayer != nil && audioPlayer.playing {
            let min = Int(audioPlayer.currentTime / 60)
            let sec = Int(audioPlayer.currentTime % 60)
            let s = String(format: "%02d:%02d", min, sec)
            statusLabel.text = s
            audioPlayer.updateMeters()
        }
    }
    
    func keyboardWillAppear(notification : NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
                self.heightConstraintCollectionView.constant = 0
            }) { _ in
                self.view.layoutSubviews()
                self.view.layoutIfNeeded()
                self.bottomConstraintChatView.constant = keyboardSize.height
            }
            if chatArray.count > 1 {
                let indexPath = NSIndexPath(forRow: chatArray.count-1, inSection: 0)
                chatTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
    }
    
    func keyboardWillHide(notification : NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            bottomConstraintChatView.constant = 0
        }
    }
    
    func getAttributedParagraphString(text : String) -> NSMutableAttributedString {
        let para = NSMutableAttributedString(string: text)
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 2
        paraStyle.alignment = NSTextAlignment.Left
        para.addAttribute(NSParagraphStyleAttributeName, value: paraStyle, range: NSRange(location: 0,length: para.length))
        return para
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let chatObj = chatArray.objectAtIndex(indexPath.row) as! ACChatInfo
        
        if !chatObj.isReceiver {
            let senderCell = tableView.dequeueReusableCellWithIdentifier("ACSenderChatTVCellID", forIndexPath: indexPath) as! ACChatTVCell
            senderCell.chatDateLabel.text = chatObj.time
            senderCell.chatDetailLabel.attributedText = self.getAttributedParagraphString(chatObj.message)
            senderCell.userPicImageView.image = UIImage(named: chatObj.userImage)
            senderCell.audioStatusProgressView.hidden = true
            senderCell.audioTimerLabel.hidden = true
            senderCell.chatItemButton.hidden =  false
            if chatObj.isImage {
                senderCell.chatImageView.image = chatObj.image
                senderCell.heightConstraintChatImgView.constant = 150
            } else if chatObj.isVideo{
                senderCell.chatImageView.image = chatObj.videoThumbnail
                senderCell.heightConstraintChatImgView.constant = 150
            } else if chatObj.isAudio{
                senderCell.audioStatusProgressView.hidden = false
                senderCell.audioTimerLabel.hidden = false
                senderCell.chatImageView.image = chatObj.videoThumbnail
                senderCell.heightConstraintChatImgView.constant = 60
            } else {
                senderCell.chatImageView.image = nil
                senderCell.chatItemButton.hidden =  true
            }
            senderCell.chatItemButton.tag = indexPath.row + 5000
            senderCell.audioStatusProgressView.tag = indexPath.row + 6000
            senderCell.audioTimerLabel.tag = indexPath.row + 7000
            senderCell.chatItemButton.addTarget(self, action: #selector(playSenderAudioVideo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return senderCell
        } else {
            let receiverCell = tableView.dequeueReusableCellWithIdentifier("ACReceiverChatTVCellID", forIndexPath: indexPath) as! ACChatTVCell
            receiverCell.chatDateLabel.text = chatObj.time
            receiverCell.chatDetailLabel.attributedText = self.getAttributedParagraphString(chatObj.message)
            receiverCell.userPicImageView.image = UIImage(named: chatObj.userImage)
            receiverCell.audioStatusProgressView.hidden = true
            receiverCell.audioTimerLabel.hidden = true
            receiverCell.chatItemButton.hidden =  false
            if chatObj.isImage {
                receiverCell.chatImageView.image = chatObj.image
                receiverCell.heightConstraintChatImgView.constant = 150
            } else if chatObj.isVideo{
                receiverCell.chatImageView.image = chatObj.videoThumbnail
                receiverCell.heightConstraintChatImgView.constant = 150
            } else if chatObj.isAudio{
                receiverCell.audioStatusProgressView.hidden = false
                receiverCell.audioTimerLabel.hidden = false
                receiverCell.chatImageView.image = chatObj.videoThumbnail
                receiverCell.heightConstraintChatImgView.constant = 60
            } else {
                receiverCell.chatImageView.image = nil
                receiverCell.chatItemButton.hidden =  true
            }
            receiverCell.chatItemButton.tag = indexPath.row + 1000
            receiverCell.audioStatusProgressView.tag = indexPath.row + 3000
            receiverCell.audioTimerLabel.tag = indexPath.row + 2000
            receiverCell.chatItemButton.addTarget(self, action: #selector(playAudioVideo(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            return receiverCell
        }
    }
    
    //MARK:- Tableview Deleagte Methods
    func  tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
            self.heightConstraintCollectionView.constant = 0
        }) { _ in
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK:- UIButton Action Methods
    @IBAction func attachButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
            self.heightConstraintCollectionView.constant = 0
        }) { _ in
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        AlertController.actionSheet("Choose Image", message: "", sourceView: self.view, actions: [cameraAction,galleryAction,cancelAction])
    }
    
    @IBAction func sendButtonAction(sender: UIButton) {
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
            self.heightConstraintCollectionView.constant = 0
        }) { _ in
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
            if !(self.messageTextView.text == "") {
                self.getChatDummyData(self.messageTextView.text ,isAudio: false,isImage: false,isVideo: false,image: "",video: "", audio: "")
            } else {
                AlertController.alert("Please enter text.")
            }
            self.messageTextView.text = ""
        }
    }
    
    @IBAction func emoticonsButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
            self.heightConstraintCollectionView.constant = 200
        }) { _ in
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func speakerButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
            self.heightConstraintCollectionView.constant = 0
        }) { _ in
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
            self.audioPickerBgView.hidden = false
            self.audioPickerBgView.alpha = 1.0
        }
    }
    
    @IBAction func videoRecordButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
            self.heightConstraintCollectionView.constant = 0
        }) { _ in
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
            sender.exclusiveTouch = true
            self.openVideoCamera()
        }
    }
    
    @IBAction func closeAudioButtonAction(sender: UIButton) {
        UIView.animateWithDuration(1.0, animations: {
            if (self.audioPlayer != nil && !self.audioPlayer.playing){
                self.audioPlayer.stop()
            }
            self.audioPickerBgView.alpha = 0.0
            self.audioPickerBgView.hidden = true
        })
    }
    
    @IBAction func recAudioButtonAction(sender: UIButton) {
        sender.selected = !sender.selected
        if audioPlayer != nil && audioPlayer.playing {
            audioPlayer.stop()
        }
        
        if audioRecorder == nil {
            print("recording. recorder nil")
            playAudioButton.enabled = false
            useAudioButton.enabled = false
            deleteAudioButton.enabled = false
            recordWithPermission(true)
            return
        } else if audioRecorder != nil && audioRecorder.recording {
            print("pausing")
            audioRecorder.stop()
            
        } else {
            print("recording")
            playAudioButton.enabled = false
            useAudioButton.enabled = false
            deleteAudioButton.enabled = false
            //            recorder.record()
            recordWithPermission(false)
        }
    }
    
    @IBAction func deleteAudioButtonAction(sender: UIButton) {
        if (audioPlayer != nil && !self.audioPlayer.playing){
            self.audioPlayer.stop()
        } else if audioRecorder != nil {
            self.audioRecorder.deleteRecording()
            playAudioButton.enabled = false
            useAudioButton.enabled = false
            deleteAudioButton.enabled = false
        }
        self.meterTimer.invalidate()
        statusLabel.text = "00:00"
        recordAudioButton.enabled = true
        recordAudioButton.selected = false
        playAudioButton.enabled = false
        useAudioButton.enabled = false
        deleteAudioButton.enabled = false
    }
    
    @IBAction func playAudioButtonAction(sender: UIButton) {
        if (!audioRecorder.recording){
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
                //                audioPlayer.delegate = self
                audioPlayer.play()
                //                audioPlayer.meteringEnabled = true
                recordAudioButton.enabled = false
                
            } catch {
            }
        } else if audioPlayer.playing {
            self.meterTimer.invalidate()
            statusLabel.text = "00:00"
            self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                                                                     target:self,
                                                                     selector:#selector(self.updateAudioMeter(_:)),
                                                                     userInfo:nil,
                                                                     repeats:true)
        } else {
            meterTimer.invalidate()
        }
    }
    
    
    @IBAction func useAudioButtonAction(sender: UIButton) {
        UIView.animateWithDuration(1.0, animations: {
            if (self.audioPlayer != nil && !self.audioPlayer.playing){
                self.audioPlayer.stop()
            }
            self.meterTimer.invalidate()
            self.statusLabel.text = "00:00"
            self.recordAudioButton.enabled = true
            self.playAudioButton.enabled = false
            self.useAudioButton.enabled = false
            self.deleteAudioButton.enabled = false
            
            self.audioPickerBgView.alpha = 0.0
            self.audioPickerBgView.hidden = true
            self.getChatDummyData("",isAudio: true,isImage: false,isVideo: false,image: "",video: "",audio: NSString(format: "%@",self.soundFileURL) as String)
        })
    }
    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.audioRecorder.record()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                        target:self,
                        selector:#selector(self.updateAudioMeter(_:)),
                        userInfo:nil,
                        repeats:true)
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setupRecorder() {
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        print(currentFileName)
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.soundFileURL = documentsDirectory.URLByAppendingPathComponent(currentFileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            audioRecorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            pickerController?.delegate = self
            pickerController!.sourceType = UIImagePickerControllerSourceType.Camera
            pickerController?.navigationBar.tintColor = UIColor.whiteColor()
            self .presentViewController(pickerController!, animated: true, completion: nil)
        } else {
            openGallery()
        }
    }
    
    func openGallery() {
        pickerController!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController?.delegate = self
        self.presentViewController(pickerController!, animated: true, completion: nil)
        pickerController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func openVideoCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            self.view.layoutIfNeeded()
            
            print("captureVideoPressed and camera available.")
            
            self.pickerController!.delegate = self
            self.pickerController!.sourceType = .Camera;
            self.pickerController!.mediaTypes = [kUTTypeMovie as String]
            self.pickerController!.allowsEditing = false
            self.pickerController!.videoMaximumDuration = NSTimeInterval(10)
            self.pickerController!.showsCameraControls = true
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                self.presentViewController(self.pickerController!, animated: true, completion: nil)
            }
            
        } else {
            print("Camera not available.")
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        pickerController!.dismissViewControllerAnimated(true, completion: nil)
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqualToString(kUTTypeImage as NSString as String) {
            
            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            let imageName = imageURL.path!
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
            let localPath = documentDirectory.stringByAppendingPathComponent(imageName)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImagePNGRepresentation(image)
            data!.writeToFile(localPath, atomically: true)
            
            self.getChatDummyData("",isAudio: false,isImage: true,isVideo: false,image: localPath,video: "",audio: "")
        } else {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            let videoData = NSData(contentsOfURL: videoURL)
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent("/vid1.mp4")
            
            videoData?.writeToFile(dataPath, atomically: false)
            
            self.getChatDummyData("",isAudio: false,isImage: false,isVideo: true,image: "",video: dataPath, audio: "")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        pickerController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func playSenderAudioVideo(sender: UIButton) {
        let chatObj = chatArray.objectAtIndex(sender.tag - 5000) as! ACChatInfo
        if chatObj.isImage {
            let imgView = UIImageView(image: chatObj.image)
            EXPhotoViewer.showImageFrom(imgView)
        }else if chatObj.isVideo {
            self.presentMovieController(chatObj.video)
        } else {
            if (!audioRecorder.recording){
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(string: chatObj.audio)!)
                    //                audioPlayer.delegate = self
                    audioPlayer.play()
                    //                audioPlayer.meteringEnabled = true
                    recordAudioButton.enabled = false
                    if audioPlayer != nil {
                        audioPlayer.delegate = self
                    }
                    let kView = getViewWithTag(sender.tag + 2000, view: self.view) as? UIProgressView
                    index = sender.tag
                    kView?.progress = 0
                    self.meterTimer.invalidate()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(1,
                                                                             target:self,
                                                                             selector:#selector(self.updateCellAudioStatus(_:)),
                                                                             userInfo:nil,
                                                                             repeats:true)
                    
                    
                    kView?.progress = 0
                } catch {
                }
            } else {
                meterTimer.invalidate()
            }
        }
    }
    
    func playAudioVideo(sender: UIButton) {
        let chatObj = chatArray.objectAtIndex(sender.tag - 1000) as! ACChatInfo
        if chatObj.isImage {
            let imgView = UIImageView(image: chatObj.image)
            EXPhotoViewer.showImageFrom(imgView)
        } else if chatObj.isVideo {
            self.presentMovieController(chatObj.video)
        } else {
            if (!audioRecorder.recording){
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(string: chatObj.audio)!)
                    //                audioPlayer.delegate = self
                    audioPlayer.play()
                    //                audioPlayer.meteringEnabled = true
                    recordAudioButton.enabled = false
                    if audioPlayer != nil {
                        audioPlayer.delegate = self
                    }
                    let kView = getViewWithTag(sender.tag + 2000, view: self.view) as? UIProgressView
                    index = sender.tag
                    kView?.progress = 0
                    self.meterTimer.invalidate()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(1,
                                                                             target:self,
                                                                             selector:#selector(self.updateCellAudioStatus(_:)),
                                                                             userInfo:nil,
                                                                             repeats:true)
                    
                    kView?.progress = 0
                } catch {
                }
            } else {
                meterTimer.invalidate()
            }
        }
    }
    
    func updateCellAudioStatus(timer : NSTimer) {
        let kLabel = getViewWithTag(index + 1000, view: self.view) as? UILabel
        kLabel?.text = String(format: "%02d:%02d", Int(audioPlayer.currentTime / 60), Int(audioPlayer.currentTime % 60))
        let kView = getViewWithTag(index + 2000, view: self.view) as? UIProgressView
        
        kView?.setProgress(Float(self.audioPlayer.currentTime)/Float(self.audioPlayer.duration), animated: true)
        
        audioPlayer.updateMeters()
    }
    
    //MARK:- MPMovie Player
    func playVideo(sender : UIButton) {
        let chatObj = chatArray.objectAtIndex(sender.tag - 1000) as! ACChatInfo
        self.presentMovieController(chatObj.video)
    }
    
    func presentMovieController(url : NSString){
        let filePath = NSURL(fileURLWithPath:url as String)
        let player = AVPlayer(URL: filePath)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true)
        {
            player.play()
        }
    }
    
    @objc func moviePlayBackDidFinish(notification: NSNotification){
        let moviePlayer:MPMoviePlayerController = notification.object as! MPMoviePlayerController
        
        moviePlayer.view.removeFromSuperview()
        self.dismissMoviePlayerViewControllerAnimated()
    }
    
    @objc func movieFinish(sender: UIButton){
        self.dismissMoviePlayerViewControllerAnimated()
    }
    
    
    // MARK: AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        print("finished recording \(flag)")
        playAudioButton.enabled = true
        deleteAudioButton.enabled = true
        useAudioButton.enabled = true
        //            // iOS8 and later
        //            let alert = UIAlertController(title: "Recorder",
        //                                          message: "Finished Recording",
        //                                          preferredStyle: .Alert)
        //            alert.addAction(UIAlertAction(title: "Keep", style: .Default, handler: {action in
        //                print("keep was tapped")
        //            }))
        //            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: {action in
        //                print("delete was tapped")
        //                self.audioRecorder.deleteRecording()
        //            }))
        //            self.presentViewController(alert, animated:true, completion:nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder,
                                          error: NSError?) {
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
        recordAudioButton.enabled = true
        meterTimer.invalidate()
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
    
    //MARK:- UICollection View Datasources
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int  {
        return stickerArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ACStickerCVCellID", forIndexPath: indexPath) as! ACStickerCVCell
        let img = stickerArray[indexPath.row]
        cell.stickerImageView.image = UIImage(named:img as! String )
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.view.endEditing(true)
        UIView.animateWithDuration(1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
            self.heightConstraintCollectionView.constant = 0
        }) { _ in
            self.view.layoutSubviews()
            self.view.layoutIfNeeded()
            let imageName = self.stickerArray[indexPath.row]
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
            let localPath = documentDirectory.stringByAppendingPathComponent(imageName as! String)
            
            let image = UIImage(named: imageName as! String)
            let data = UIImagePNGRepresentation(image!)
            data!.writeToFile(localPath, atomically: true)
            
            self.getChatDummyData("",isAudio: false,isImage: true,isVideo: false,image: localPath,video: "",audio: "")
        }
    }
    
}
