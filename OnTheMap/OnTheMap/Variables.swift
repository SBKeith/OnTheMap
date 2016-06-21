//
//  Variables.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/19/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import MapKit

class Variables {
    
    // DATA
    var locations: [StudentInformation.AllStudents] = []
    var userDataArray: [[String : AnyObject]] = []
    
    // USER PROVIDED DATA
    var newUserDataDictionary: [String : AnyObject] = [:]
    // Data stored in newUserDataDictionary:
/* [ "firstName" : String,
     "lastName"  : String,
     "sessionID" : String,
     "userKey"   : String,
     "newLoc"    : String,
     "mediaURL"  : String,
     "lat"       : Double,
     "long"      : Double ]
     */

    // MARK: Helper methods
    func kHttpBody(email: String, password: String) -> String {
        return "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}"
    }
    
    func getLatLong(locationTextView: String, completionHandler: (success: Bool, error: String?) -> Void) {
        
        self.newUserDataDictionary["newLocation"] = locationTextView;
        let geocoder:CLGeocoder = CLGeocoder();
        geocoder.geocodeAddressString(self.newUserDataDictionary["newLocation"] as! String) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if placemarks?.count > 0 {
                let topResult:CLPlacemark = placemarks![0];
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult);
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                self.newUserDataDictionary["latitude"] = coordinates.latitude
                self.newUserDataDictionary["longitude"] = coordinates.longitude
                
                completionHandler(success: true, error: nil)
            } else {
                completionHandler(success: false, error: "Location not found!")
            }
        }
    }

    
    // MARK: Shared Instance
    class func sharedInstance() -> Variables {
        struct Singleton {
            static var sharedInstance = Variables()
        }
        return Singleton.sharedInstance
    }
}