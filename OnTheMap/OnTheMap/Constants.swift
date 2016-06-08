//
//  Constants.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/6/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation

class Constants: NSObject {
    
    // DATA
    var locations: [[String : AnyObject]] = []
    
    // UDACITY SITE URLS
    let kUdacitySignUp = "https://www.udacity.com/account/auth#!/signup"
    let kSession = "https://www.udacity.com/api/session"
    let kUserKey = "https://www.udacity.com/api/users/"
    
    // JSON data
    let kMethod = "POST"
    let kApplication = "application/json"
    let kAccept = "Accept"
    let kContent_type = "Content-Type"
    
    // Helper methods
    func kHttpBody(email: String, password: String) -> String {
        return "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
    }
}