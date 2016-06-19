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
    var variables = Variables.sharedInstance()
    
    // Authentication state
    
    func getSessionID(email: String, password: String, completionHandlerForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: kSession)!)
        request.HTTPMethod = kMethod
        request.addValue(kApplication, forHTTPHeaderField: kAccept)
        request.addValue(kApplication, forHTTPHeaderField: kContent_type)
        request.HTTPBody = variables.kHttpBody(email, password: password).dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForToken(success: false, data: "", errorString: "sessionID")
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
                self.variables.newUserDataDictionary["sessionID"] = p1
                self.variables.newUserDataDictionary["userKey"] = p2
            }
            
            if let _ = self.variables.newUserDataDictionary["userKey"] as? String {
                completionHandlerForToken(success: true, data: parsedResult, errorString: nil)
            } else {
                completionHandlerForToken(success: false, data: parsedResult, errorString: "Incorrect Email or Password.  Please try again.")
            }
        }
        task.resume()
    }
    
    func getUserData(completionHanderForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(kUserKey)\(self.variables.newUserDataDictionary["userKey"]!)")!)
        
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
            
            self.variables.newUserDataDictionary["firstName"] = parsedResult["user"]!!["first_name"]!! as? String
            self.variables.newUserDataDictionary["lastName"] = parsedResult["user"]!!["last_name"]!! as? String
            
            completionHanderForToken(success: true, data: parsedResult, errorString: nil)
        }
        task.resume()
    }
    
    func logUserOut(completionHandlerForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        variables.newUserDataDictionary = [:]
        
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