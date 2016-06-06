//
//  UdacityAPIManager.Swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/6/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation

class UdacityAPIManager: NSObject {
    
    // MARK: Properties
    var session = NSURLSession.sharedSession()
    
    // Authentication state
    var sessionID: String? = nil
    var userKey: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
    func getSessionID(email: String, password: String, completionHandlerForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
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
            
            self.sessionID = parsedResult["session"]!!["id"]!! as? String
            self.userKey = parsedResult["account"]!!["key"]!! as? String
            
            completionHandlerForToken(success: true, data: parsedResult, errorString: nil)
        }
        task.resume()
    }
    
    func getUserData(key: String, completionHanderForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(key)")!)
        
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
            
            self.firstName = parsedResult["user"]!!["first_name"]!! as? String
            self.lastName = parsedResult["user"]!!["last_name"]!! as? String
            
            completionHanderForToken(success: true, data: parsedResult, errorString: nil)
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




