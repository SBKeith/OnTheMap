//
//  UdacityAPIManager.Swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/6/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import MapKit

class UdacityAPIManager: NSObject {
    
    // MARK: Properties
    var session = NSURLSession.sharedSession()
    let constants = Constants.sharedInstance()
    
    // Authentication state
    
    func getSessionID(email: String, password: String, completionHandlerForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: constants.kSession)!)
        request.HTTPMethod = constants.kMethod
        request.addValue(constants.kApplication, forHTTPHeaderField: constants.kAccept)
        request.addValue(constants.kApplication, forHTTPHeaderField: constants.kContent_type)
        request.HTTPBody = constants.kHttpBody(email, password: password).dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForToken(success: false, data: data!, errorString: "Login failed (sessionID).")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            if let p1 = parsedResult["session"]??["id"] as? String, let p2 = parsedResult["account"]??["key"] as? String {
                self.constants.newUserDataDictionary["sessionID"] = p1
                self.constants.newUserDataDictionary["userKey"] = p2
            }
            
            if let _ = self.constants.newUserDataDictionary["userKey"] as? String {
                completionHandlerForToken(success: true, data: parsedResult, errorString: nil)
            } else {
                completionHandlerForToken(success: false, data: parsedResult, errorString: "Incorrect Email or Password.  Please try again.")
            }
        }
        task.resume()
    }
    
    func getUserData(completionHanderForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(constants.kUserKey)\(self.constants.newUserDataDictionary["userKey"]!)")!)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completionHanderForToken(success: false, data: data!, errorString: "Login failed (user data).")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            self.constants.newUserDataDictionary["firstName"] = parsedResult["user"]!!["first_name"]!! as? String
            self.constants.newUserDataDictionary["lastName"] = parsedResult["user"]!!["last_name"]!! as? String
            
            completionHanderForToken(success: true, data: parsedResult, errorString: nil)
        }
        task.resume()
    }
    
    func logUserOut(completionHandlerForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        constants.newUserDataDictionary = [:]
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            completionHandlerForToken(success: true, data: parsedResult, errorString: nil)
        }
        task.resume()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> UdacityAPIManager {
        struct Singleton {
            static var sharedInstance = UdacityAPIManager()
        }
        return Singleton.sharedInstance
    }
}