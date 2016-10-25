//
//  ServiceHelper.swift
//  WorldFax
//
//  Created by Probir Chakraborty on 01/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import Foundation
import Alamofire

final class ServiceHelper {
    let baseURL = "http://conference-butler.herokuapp.com/webservices/"
    
//    let baseURL = "http://172.16.6.55:3000/webservices/"
    var manager = Manager.sharedInstance
    
    // Specifying the Headers we need
    

    class var sharedInstance: ServiceHelper {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: ServiceHelper? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = ServiceHelper()
        }
        
        return Static.instance!
    }
    
    private class func request(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String : AnyObject]?, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request {
        
        let (request, error) = encoding.encode(NSURLRequest(URL: NSURL(string: URLString.URLString)!), parameters: parameters)
        let mutableURLRequest = request 
        
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let heads = headers {
            for (field, value) in heads {
                mutableURLRequest.setValue(value, forHTTPHeaderField: field)
            }
        }
        
        if (error != nil) {
            return Alamofire.request(mutableURLRequest)
        } else {
            return Alamofire.request(mutableURLRequest)
        }
        
        
    }
    
    //Create Post and send request
    func createPostRequest(params: [String : AnyObject]!,apiName : String, completion: (response: AnyObject?, error: NSError?) -> Void)
    {
        MBProgressHUD.showHUDAddedTo(kAppDelegate.window, animated: true)
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json", //Optional
        ]

        let url = self.baseURL + apiName;
        let parameterDict = params as NSDictionary
        logInfo("\n\n Request URL  >>>>>>\(url)")
        //logInfo("\n\n Request Header >>>>>> \n\(request.allHTTPHeaderFields)")
        logInfo("\n\n Request Parameters >>>>>>\n\(parameterDict.toJsonString())")
        var headers : NSDictionary = [:]
        print("tokenValue=>",NSUserDefaults.standardUserDefaults().valueForKey("ACToken"))
        if NSUserDefaults.standardUserDefaults().valueForKey("ACToken") != nil {
            headers = [
                "token": NSUserDefaults.standardUserDefaults().valueForKey("ACToken")!
            ]
        }
        Alamofire.request(.POST, url, parameters: params,headers: headers as? [String : String]).responseJSON {
            response in
            switch response.result {
            case .Success:
                MBProgressHUD.hideAllHUDsForView(kAppDelegate.window, animated: true)
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
                MBProgressHUD.hideAllHUDsForView(kAppDelegate.window, animated: true)
                completion(response: nil, error: error)
            }
        }
    }
    
    //Create Put and send request
    func createPutRequest(params: [String : AnyObject]!,apiName : String, completion: (response: AnyObject?, error: NSError?) -> Void) {
        MBProgressHUD.showHUDAddedTo(kAppDelegate.window, animated: true)
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json", //Optional
        ]
        
        let url = self.baseURL + apiName;
        let parameterDict = params as NSDictionary
        logInfo("\n\n Request URL  >>>>>>\(url)")
        //logInfo("\n\n Request Header >>>>>> \n\(request.allHTTPHeaderFields)")
        logInfo("\n\n Request Parameters >>>>>>\n\(parameterDict.toJsonString())")
        var headers : NSDictionary = [:]
        
        if NSUserDefaults.standardUserDefaults().valueForKey("ACToken") != nil {
            headers = [
                "token": NSUserDefaults.standardUserDefaults().valueForKey("ACToken")!
            ]
        }
        Alamofire.request(.PUT, url, parameters: params,headers: headers as? [String : String]).responseJSON {
            response in
            switch response.result {
            case .Success:
                MBProgressHUD.hideAllHUDsForView(kAppDelegate.window, animated: true)
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
                MBProgressHUD.hideAllHUDsForView(kAppDelegate.window, animated: true)
                completion(response: nil, error: error)
            }
        }
    }
    
    //Create Get and send request
    func createGetRequest(params: [String : AnyObject]!,apiName : String, completion: (response: AnyObject?, error: NSError?) -> Void) {
        MBProgressHUD.showHUDAddedTo(kAppDelegate.window, animated: true)
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json", //Optional
        ]
        
        let url = self.baseURL + apiName;
        let parameterDict = params as NSDictionary
        logInfo("\n\n Request URL  >>>>>>\(url)")
        //logInfo("\n\n Request Header >>>>>> \n\(request.allHTTPHeaderFields)")
        logInfo("\n\n Request Parameters >>>>>>\n\(parameterDict.toJsonString())")
        var headers : NSDictionary = [:]
        
        if NSUserDefaults.standardUserDefaults().valueForKey("ACToken") != nil {
            headers = [
                "token": NSUserDefaults.standardUserDefaults().valueForKey("ACToken")!
            ]
        }
        Alamofire.request(.GET, url, parameters: params,headers: headers as? [String : String]).responseJSON {
            response in
            switch response.result {
            case .Success:
                MBProgressHUD.hideAllHUDsForView(kAppDelegate.window, animated: true)
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
                MBProgressHUD.hideAllHUDsForView(kAppDelegate.window, animated: true)
                completion(response: nil, error: error)
            }
        }
    }
    
    //Create Delete and send request
    func createDeleteRequest(params: [String : AnyObject]!,apiName : String, completion: (response: AnyObject?, error: NSError?) -> Void) {
        MBProgressHUD.showHUDAddedTo(kAppDelegate.window, animated: true)
        manager.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json", //Optional
        ]
        
        let url = self.baseURL + apiName;
        let parameterDict = params as NSDictionary
        logInfo("\n\n Request URL  >>>>>>\(url)")
        //logInfo("\n\n Request Header >>>>>> \n\(request.allHTTPHeaderFields)")
        logInfo("\n\n Request Parameters >>>>>>\n\(parameterDict.toJsonString())")
        var headers : NSDictionary = [:]
        
        if NSUserDefaults.standardUserDefaults().valueForKey("ACToken") != nil {
            headers = [
                "token": NSUserDefaults.standardUserDefaults().valueForKey("ACToken")!
            ]
        }
        manager.request(.DELETE, url, parameters: params,headers: headers as? [String : String]).responseJSON {
            response in
            switch response.result {
            case .Success:
                MBProgressHUD.hideAllHUDsForView(kAppDelegate.window, animated: true)
                completion(response: response.result.value, error: nil)
            case .Failure(let error):
                MBProgressHUD.hideAllHUDsForView(kAppDelegate.window, animated: true)
                completion(response: nil, error: error)
            }
        }
    }
    
}


