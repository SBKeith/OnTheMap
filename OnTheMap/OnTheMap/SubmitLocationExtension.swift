//
//  SubmitLocationExtension.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/19/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension SubmitLocationViewController {
        
    func startAlert() {
        alertIndicator.startAnimating()
        alertView.hidden = false
        alertIndicator.hidden = false
    }
    
    func stopAlert(completionHandler: (success:Bool) -> Void) {
        self.alertIndicator.stopAnimating()
        self.alertIndicator.hidden = true
        self.alertView.hidden = true
        
        completionHandler(success: true)
    }
    
    func mapStudentCoordinates() {
        
        // Reset data array to avoid stacking new data on top of old!
        self.mapView.removeAnnotations(annotations)
        
        let dictionary = self.variables.newUserDataDictionary
        
        let lat = dictionary["latitude"] as! Double
        let long = dictionary["longitude"] as! Double
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let span = MKCoordinateSpanMake(0.075, 0.075)
        let coordinate = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: span)
        mapView.setRegion(coordinate, animated: true)
        
        let first = dictionary["firstName"] as! String
        let last = dictionary["lastName"] as! String
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate.center
        annotation.title = "\(first) \(last)"
        annotation.subtitle = variables.newUserDataDictionary["newLoc"] as? String
        
        // Finally we place the annotation in an array of annotations.
        self.annotations.append(annotation)
        
        // May need to complete in closure... (below)
        
        // When the array is complete, we add the annotations to the map.
        dispatch_async(dispatch_get_main_queue(), {
            self.mapView.addAnnotations(self.annotations)
        })
    }

//    func setNewLocationForStudent(completionHandler: (success: Bool) -> Void) {
//        
//        let studentInfo = StudentInformation.AllStudents(studentInfo: self.variables.newUserDataDictionary)
//        
//        let request = NSMutableURLRequest(URL: NSURL(string: kParseURL)!)
//        request.HTTPMethod = "POST"
//        request.addValue(kParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
//        request.addValue(kParseRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        request.HTTPBody = "{\"uniqueKey\": \"\(studentInfo.userKey!)\", \"firstName\": \"\(studentInfo.firstName!)\", \"lastName\": \"\(studentInfo.lastName!)\",\"mapString\": \"\(studentInfo.newLocation!)\", \"mediaURL\": \"\(studentInfo.mediaURL!)\", \"latitude\": \(studentInfo.lat!), \"longitude\": \(studentInfo.long!)}".dataUsingEncoding(NSUTF8StringEncoding)
//        
//        // OVERWRITE PREVIOUS LOCATION BEFORE SETTING NEW ON MAP!!  (below)
//        // See if posting student location returns objectID in 'data' or 'response' JSON (task call below)
//        // User objectID to check if previous location has been store
//        // If not, POST new data; otherwise, PUT new data via objectID...
//        
//        let session = NSURLSession.sharedSession()
//        
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if error != nil { // Handle error…
//                dispatch_async(dispatch_get_main_queue(), {
//                    let alertMessage = self.alert.createAlertView("User data upload failed.", title: "Upload Error")
//                    self.presentViewController(alertMessage, animated: true, completion: nil)
//                })
//            } else if error == nil {
//                completionHandler(success: true)
//            }
//        }
//        task.resume()
//    }
}