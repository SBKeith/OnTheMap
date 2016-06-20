//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/16/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation

// This struct is ONLY for the data the user enters.  This struct does NOT contain the information of all students.  (This was misunderstood in the original review.)

// Please refer to the 'AllStudents' struct, located in class 'StudentInformation' for the required fix.  This file (PersonalStudentInfo.swift) is designed to support the app user only; it is used in the class 'SubmitLocationViewController', within the 'setNewLocation' function call.

struct Student {
    var firstName: String?
    var lastName: String?
    var sessionID: String?
    var userKey: String?
    var newLocation: String?
    var mediaURL: String?
    var lat: Double?
    var long: Double?
    
    init?(studentInfo: [String: AnyObject]) {
        firstName = studentInfo["firstName"] as? String
        lastName = studentInfo["lastName"] as? String
        sessionID = studentInfo["sessionID"] as? String
        userKey = studentInfo["userKey"] as? String
        newLocation = studentInfo["newLocation"] as? String
        mediaURL = studentInfo["mediaURL"] as? String
        lat = studentInfo["lat"] as? Double
        long = studentInfo["long"] as? Double
    }
}