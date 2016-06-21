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
    let sharedStudents = StudentInformation.sharedInstance()
    let alert = AlertViewController()
    
    func getStudentLocations(completionHandler: (success: Bool, data: [StudentInformation.AllStudents], error: String?) -> Void)  {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?order=-updatedAt")!)
        request.addValue(kParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(kParseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                completionHandler(success: false, data: self.sharedStudents.allStudentsArray!, error: "Server Error")
                return
            }
            
            guard (parsedResult["results"] as? [[String: AnyObject]]) != nil else {
                completionHandler(success: false, data: self.sharedStudents.allStudentsArray!, error: "Server Error")
                return
            }
            
                for dictionary in parsedResult["results"] as! [[String: AnyObject]] {
                    
                    guard let _: AnyObject? = dictionary else {
                        completionHandler(success: false, data: self.sharedStudents.allStudentsArray!, error: "Server error")
                        return
                    }
                    
                    let singleStudent = StudentInformation.AllStudents.init(studentInfo: dictionary)
                    self.sharedStudents.allStudentsArray!.append(singleStudent)
                }
                completionHandler(success: true, data: self.sharedStudents.allStudentsArray!, error: nil)
            }
        task.resume()
    }
    
    func setNewLocationForStudent(completionHandler: (success: Bool) -> Void) {
        
        let studentInfo = StudentInformation.AllStudents(studentInfo: self.sharedVariables.newUserDataDictionary)
        
        let request = NSMutableURLRequest(URL: NSURL(string: kParseURL)!)
        request.HTTPMethod = "POST"
        request.addValue(kParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(kParseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(studentInfo.userKey!)\", \"firstName\": \"\(studentInfo.firstName!)\", \"lastName\": \"\(studentInfo.lastName!)\",\"mapString\": \"\(studentInfo.newLocation!)\", \"mediaURL\": \"\(studentInfo.mediaURL!)\", \"latitude\": \(studentInfo.lat!), \"longitude\": \(studentInfo.long!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        // OVERWRITE PREVIOUS LOCATION BEFORE SETTING NEW ON MAP!!  (below)
        // See if posting student location returns objectID in 'data' or 'response' JSON (task call below)
        // User objectID to check if previous location has been store
        // If not, POST new data; otherwise, PUT new data via objectID...
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false)
            } else if error == nil {
                completionHandler(success: true)
            }
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
