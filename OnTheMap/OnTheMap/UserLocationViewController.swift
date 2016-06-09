//
//  UserLocationViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/8/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import MapKit

class UserLocationViewController: UIViewController, UITextViewDelegate {

    let constants = Constants.sharedInstance()
    
    @IBOutlet weak var locationTextView: UITextView!
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findButton.layer.cornerRadius = 10
        locationTextView.delegate = self
        locationTextView.text = "Enter Your Location Here"
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        locationTextView.text = ""
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findButtonTapped(sender: UIButton) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        request.HTTPBody = "{\"uniqueKey\": \"\(self.constants.userKey!)\", \"firstName\": \"\(self.constants.firstName!)\", \"lastName\": \"\(self.constants.lastName!)\",\"mapString\": \"\(self.locationTextView.text!)\", \"mediaURL\": \"https://google.com\", \"latitude\": \(self.lat), \"longitude\": \(self.long)}".dataUsingEncoding(NSUTF8StringEncoding)
        
//        print("{\"uniqueKey\": \"\(self.constants.userKey!)\", \"firstName\": \"\(self.constants.firstName!)\", \"lastName\": \"\(self.constants.lastName!)\",\"mapString\": \"\(self.locationTextView.text!)\", \"mediaURL\": \"https://google.com\", \"latitude\": \"\(self.lat)\", \"longitude\": \"\(self.long)\"}")
        
//        let session = NSURLSession.sharedSession()
//        
//        let task = session.dataTaskWithRequest(request) { data, response, error in
//            if error != nil { // Handle error…
//                print(error)
//            }
//            
//            let parsedResult: AnyObject!
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
//            } catch {
//                print("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            print(parsedResult)
//        }
//        task.resume()
        
        getLatLong { (success, data, error) in
            if success {
//                print(data!["component"]!!)
            }
        }
    }
    
    func getLatLong(completionHandler: (success: Bool, data: AnyObject?, error: String?) -> Void) {
        
        let location = locationTextView.text;
        let geocoder:CLGeocoder = CLGeocoder();
        geocoder.geocodeAddressString(location!) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if placemarks?.count > 0 {
                let topResult:CLPlacemark = placemarks![0];
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult);
                
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate

                print(coordinates.latitude, "\n", coordinates.longitude)    // found coordinates
                
//                completionHandler(success: true, data: placemark, error: nil)
            }
        }
    }
}
