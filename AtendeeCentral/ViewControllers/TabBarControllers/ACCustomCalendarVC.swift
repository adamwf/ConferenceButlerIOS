//
//  ACCustomCalendarVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 11/10/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACCustomCalendarVC: UIViewController {
    
//    @IBOutlet var placeholderView: UIView!
    var eventArray = NSMutableArray()
    @IBOutlet weak var calendarView: CVCalendarView!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var daysOutSwitch: UISwitch!
    
    var shouldShowDaysOut = false
    var animationFinished = true
    var switched = false
    
    var singleTap = false
    var doubleTap = false
    
    @IBOutlet weak var eventsTextView: UITextView!
    
    var daysSet = NSMutableSet()
    //    @IBOutlet weak var calendar: CalendarView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callApiForEventsList(1)
        self.customInit()
    }
    
    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Helper Methods
    func customInit() {
//        let date = NSDate()
        
        // create an instance of calendar view with
        // base date (Calendar shows 12 months range from current base date)
        // selected date (marked dated in the calendar)
//        let calendarView = CalendarView.instance(date, selectedDate: date) as CalendarView
//        calendarView.delegate = self
//        calendarView.translatesAutoresizingMaskIntoConstraints = false
//        
//        placeholderView.addSubview(calendarView)
//        
//        // Constraints for calendar view - Fill the parent view.
//        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
//        placeholderView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[calendarView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["calendarView": calendarView]))
        self.navigationItem.title = "Calendar"
        self.navigationItem.leftBarButtonItem = self.leftBarButton("backArrow")
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    func getFormattedDate(strDate : String) -> NSDateComponents {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        let date = dateFormatter.dateFromString(strDate)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day,.Month,.Year], fromDate: date!)
        return components
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
    
    //MARK:- Web API Methods
    func callApiForEventsList(pageNo:NSInteger) {
        if kAppDelegate.hasConnectivity() {
            let params: [String : AnyObject] = [
                "page" : pageNo
            ]
            ServiceHelper.sharedInstance.createGetRequest(params, apiName: "event_apis/event_list", completion: { (response, error) in
                if error != nil {
                    AlertController.alert((error?.localizedDescription)!)
                }
                if response != nil {
                    let res = response as! NSMutableDictionary
                    if res.objectForKeyNotNull("responseCode", expected: 0) as! NSInteger == 200 {
                        self.eventArray.addObjectsFromArray(ACEventInfo.getEventList(res) as [AnyObject])
                        for case let item as ACEventInfo in self.eventArray {
                            let component = self.getFormattedDate(item.eventStartDate)
                            let day = component.day
                            let month = component.month
                            let year = component.year
                            let s = "\(day) \(month) \(year)"
                            
                            self.daysSet.addObject(s)
                        }
                        self.calendarView.delegate = self
                        self.calendarView.calendarAppearanceDelegate = self
                    } else {
                        AlertController.alert(res.objectForKeyNotNull("responseMessage", expected: "") as! String)
                    }
                }
            })
        }
    }
}

// MARK: - CVCalendarViewDelegate

extension ACCustomCalendarVC: CVCalendarViewDelegate
{
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView
    {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 0.0
        let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
        let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.CGPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool
    {
        if (Int(arc4random_uniform(3)) == 1)
        {
            return true
        }
        return false
    }
    
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        let date = dayView.date
        
        if (self.switched == true) {
            switched = false
            //return
        }
        
        let delay = 0.25 * Double(NSEC_PER_SEC);
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if (self.singleTap == true && self.doubleTap == false) {
                // todo: write the days events into the text field below the calendar
                print("single tap to display events")
                AlertController.alert("", message: self.getEvents(date))
//                self.eventsTextView.text = self.getEvents(date)
            }
            
            self.singleTap = false
            self.doubleTap = false
        }
        
        if (self.singleTap == true) {
            self.doubleTap = true
            
            print("double tap to open creation dialog")
//            let events = self.getEvents(date)
//            self.eventsTextView.text = events
//            createNewEventDialog(date, message: "")
        }
        
        self.singleTap = true
    }
    
    func getEvents(date: Date) -> String {
        
        var message = ""
        var current = 1
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for case let item as ACEventInfo in eventArray {
            let component = getFormattedDate(item.eventStartDate)

            if component.day == date.day && component.month == date.month && component.year == date.year {
                let val = item.eventName
                print(item.eventStartDate)
                
                if (message != "") {
                    message = "\(message)\n"
                }
                
                message = "\(message)\(current).) \(val)"
                
                current = current + 1
            }
        }
        
        
        if (message == "") {
            message = "No Scheduled Events"
        }
        
        return message
    }
    
//    func getParticularEvent(date: Date) -> String {
//        
//        var message = ""
//        var current = 1
//        print(date)
//        for case let item as ACEventInfo in eventArray {
//            let val = item.eventName
//            
//            if (message != "") {
//                message = "\(message)\n"
//            }
//            
//            message = "\(message)\(current).) \(val)"
//            
//            current = current + 1
//        }
//        
//        if (message == "") {
//            message = "No Scheduled Events"
//        }
//        
//        return message
//    }
    
//    func createNewEventDialog(date: Date, message: String) {
//        let alert = UIAlertController(title: "\(date.commonDescription)",
//                                      message: message,
//                                      preferredStyle: .Alert)
//        
//        let saveAction = UIAlertAction(title: "Add",
//                                       style: .Default) { (action: UIAlertAction) -> Void in
//                                        let textField = alert.textFields![0]
//                                        self.saveEvent(textField.text!, date: date)
//        }
//        
//        let cancelAction = UIAlertAction(title: "Close",
//                                         style: .Default) { (action: UIAlertAction) -> Void in
//        }
//        
//        alert.addTextFieldWithConfigurationHandler {
//            (textField: UITextField!) -> Void in
//            let textField = alert.textFields![0]
//            textField.placeholder = "Add Event"
//            textField.autocapitalizationType = UITextAutocapitalizationType.Words
//        }
//        
//        alert.addAction(cancelAction)
//        alert.addAction(saveAction)
//        
//        presentViewController(alert,
//                              animated: true,
//                              completion: nil)
//    }
    
//    func saveEvent(title: String, date: Date) {
//        //1
//        let appDelegate =
//            UIApplication.sharedApplication().delegate as! AppDelegate
//        
//        let managedContext = appDelegate.managedObjectContext!
//        
//        //2
//        let entity =  NSEntityDescription.entityForName("Event",
//                                                        inManagedObjectContext:
//            managedContext)
//        
//        let event = NSManagedObject(entity: entity!,
//                                    insertIntoManagedObjectContext:managedContext)
//        
//        //3
//        event.setValue(title, forKey: "title")
//        event.setValue(date.day, forKey: "day")
//        event.setValue(date.month, forKey: "month")
//        event.setValue(date.year, forKey: "year")
//        
//        //4
//        var error: NSError?
//        do {
//            try managedContext.save()
//        } catch let error1 as NSError {
//            error = error1
//            print("Could not save \(error), \(error?.userInfo)")
//        }
//        
//    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            
            switched = true
            
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransformIdentity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    // TODO: dots for the days with events
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let date = dayView.date
        
        if isToday(date) {
            return false
        }
        
        let s = "\(date.day) \(date.month) \(date.year)"
        
        if daysSet.containsObject(s) {
            return true
        }
        
        return false
    }
    
    func isToday(date : CVDate) -> Bool {
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: today)
        let day = components.day
        let month = components.month
        let year = components.year
        
        if day == date.day && month == date.month && year == date.year {
            return true
        } else {
            return false
        }
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> UIColor {
        let day = dayView.date.day
        
        let red = CGFloat(0 / 255)
        let green = CGFloat(0 / 255)
        let blue = CGFloat(600 / 255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        return color
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension ACCustomCalendarVC: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return true
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - CVCalendarMenuViewDelegate

extension ACCustomCalendarVC: CVCalendarMenuViewDelegate {
    // firstWeekday() has been already implemented.
}

// MARK: - IB Actions

extension ACCustomCalendarVC {
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.WeekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.MonthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension ACCustomCalendarVC {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        let calendarManager = calendarView.manager
        let components = CalenderManager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
}