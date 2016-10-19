//
//  ACAppData.swift
//  AtendeeCentral
//
//  Created by Neha Chhabra on 04/10/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit

class ACAppData: NSObject {

    class var appInfoSharedInstance: ACAppData {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ACAppData? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ACAppData()
        }
        return Static.instance!
    }
    var appUserInfo: ACUserInfo!
}
