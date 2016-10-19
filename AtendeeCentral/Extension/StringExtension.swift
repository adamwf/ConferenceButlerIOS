//
//  StringExtension.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 02/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import Foundation
import UIKit
extension String {
    
    func contains(string: String) -> Bool {
        return self.rangeOfString(string) != nil
    }
    
    func substringFromIndex(index: Int) -> String {
        if (index < 0 || index > self.characters.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return self.substringFromIndex(self.startIndex.advancedBy(index))
    }
    
    func substringToIndex(index: Int) -> String {
        if (index < 0 || index > self.characters.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return self.substringToIndex(self.startIndex.advancedBy(index))
    }
    
    func trimWhiteSpace () -> String {
        
        let trimmedString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        return trimmedString
    }
    
    func isValidMobileNumber() -> Bool {
        
        let mobileNoRegEx = "^((\\+)|(00)|(\\*)|())[0-9]{9,14}((\\#)|())$"
        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
        return mobileNoTest.evaluateWithObject(self)
    }
    
    func isEmail() -> Bool {
        let emailRegex = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        print(emailTest.evaluateWithObject(self))
        return emailTest.evaluateWithObject(self)
    }
    
    func isValidUserName() -> Bool {
        
        let nameRegEx = "^[a-zA-Z0-9\\s]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluateWithObject(self)
    }
    
    func containsNumberOnly() -> Bool {
        
        let nameRegEx = "^[0-9]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluateWithObject(self)
    }
    
    func containsAlphabetsOnly() -> Bool {
        
        let nameRegEx = "^[a-zA-Z]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluateWithObject(self)
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func dateFromString(format:String) -> NSDate? {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.dateFromString(self) {
            return date
        } else {
            print("Unable to format date")
        }
        
        return nil
    }
    
    //>>>> removes all whitespace from a string, not just trailing whitespace <<<//
    
    func removeWhitespace() -> String {
        return self.replaceString(" ", withString: "")
    }
    
    //>>>> Replacing String with String <<<//
    func replaceString(string:String, withString:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func getAttributedString(string_to_Attribute:String, color:UIColor, font:UIFont) -> NSAttributedString {
        
        let range = (self as NSString).rangeOfString(string_to_Attribute)
        
        let attributedString = NSMutableAttributedString(string:self)
        
        // multiple attributes declared at once
        let multipleAttributes = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: font,
            ]
        
        attributedString.addAttributes(multipleAttributes, range: range)
        
        return attributedString.mutableCopy() as! NSAttributedString
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
    
    //>>>>>>>>>>>>>>>>>>>>>> Finding OccurrencesOfString <<<<<<<<<<<<<<<<<<<<<<<<<<<<<//
    func occurrencesOfString(aString: String) -> Int {
        var occurrences: Int = 0
        // Set the initial range to the full string
        var range: Range<String.Index>? = self.startIndex..<self.endIndex
        
        while range != nil {
            // Search for the string in the current range
            range = self.rangeOfString(aString,
                                       options: NSStringCompareOptions.CaseInsensitiveSearch,
                                       range: range,
                                       locale: nil)
            
            if range != nil {
                // String was found, move the range
                range = range!.endIndex..<self.endIndex
                // Increment the number of occurrences
                occurrences += 1
            }
        }
        return occurrences
    }
    
}
