//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/19/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation

class StudentInformation {

    var allStudentsArray: [AllStudents]? = []

    struct AllStudents {
        var firstName: String?
        var lastName: String?
        var sessionID: String?
        var userKey: String?
        var newLocation: String?
        var mediaURL: String?
        var lat: Double?
        var long: Double?
        
        init(studentInfo: [String: AnyObject]) {
            firstName = studentInfo["firstName"] as? String
            lastName = studentInfo["lastName"] as? String
            sessionID = studentInfo["sessionID"] as? String
            userKey = studentInfo["userKey"] as? String
            newLocation = studentInfo["newLocation"] as? String
            mediaURL = studentInfo["mediaURL"] as? String
            lat = studentInfo["latitude"] as? Double
            long = studentInfo["longitude"] as? Double
        }
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> StudentInformation {
        struct Singleton {
            static var sharedInstance = StudentInformation()
        }
        return Singleton.sharedInstance
    }
}