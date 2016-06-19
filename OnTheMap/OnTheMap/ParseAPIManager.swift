//
//  ParseAPIManager.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/7/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation

class ParseAPIManager: NSObject {
    
    let sharedVariables = Variables.sharedInstance()
    
    func getStudentLocations(completionHandler: (success: Bool, data: AnyObject?, error: String?) -> Void)  {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            for dictionary in parsedResult["results"] as! [[String: AnyObject]] {
                self.sharedVariables.userDataArray.append(dictionary)
            }
            completionHandler(success: true, data: self.sharedVariables.userDataArray, error: nil)
        }
        task.resume()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> ParseAPIManager {
        struct Singleton {
            static var sharedInstance = ParseAPIManager()
        }
        return Singleton.sharedInstance
    }
}
