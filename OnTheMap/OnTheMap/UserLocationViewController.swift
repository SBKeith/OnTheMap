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
        
        // Get LAT / LONG
        getLatLong { (success, error) in
            if success {
                // present new location submission VC
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("kSubmitVC") as! SubmitLocationViewController
                self.presentViewController(vc, animated: true, completion: nil)
            } else {
                // SET ALERT VIEW HERE LATER
                print(error)
            }
        }
    }
    
    // MOVE TO MODEL SECTION
    func getLatLong(completionHandler: (success: Bool, error: String?) -> Void) {
        
        constants.newUserDataDictionary["newLocation"] = locationTextView.text;
        let geocoder:CLGeocoder = CLGeocoder();
        geocoder.geocodeAddressString(constants.newUserDataDictionary["newLocation"] as! String) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if placemarks?.count > 0 {
                let topResult:CLPlacemark = placemarks![0];
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult);
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                self.constants.newUserDataDictionary["lat"] = coordinates.latitude
                self.constants.newUserDataDictionary["long"] = coordinates.longitude
                
                completionHandler(success: true, error: nil)
            } else {
                completionHandler(success: false, error: "Location not found!")
            }
        }
    }
}
