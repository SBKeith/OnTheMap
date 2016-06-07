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
    let constants = Constants()
    
    // Authentication state
    var sessionID: String? = nil
    var userKey: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    
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
            
            self.sessionID = parsedResult["session"]!!["id"]!! as? String
            self.userKey = parsedResult["account"]!!["key"]!! as? String
            
            completionHandlerForToken(success: true, data: parsedResult, errorString: nil)
        }
        task.resume()
    }
    
    func getUserData(completionHanderForToken: (success: Bool, data: AnyObject, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(constants.kUserKey)\(self.userKey!)")!)
        
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