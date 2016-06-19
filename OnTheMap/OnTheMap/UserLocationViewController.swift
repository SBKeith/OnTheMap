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

    let variables = Variables.sharedInstance()
    let alert = AlertViewController()
    
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
        variables.getLatLong(locationTextView.text) {(success, error) in
            if success {
                // present new location submission VC
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("kSubmitVC") as! SubmitLocationViewController
                self.presentViewController(vc, animated: true, completion: nil)
            } else {
                // SET ALERT VIEW HERE LATER
                dispatch_async(dispatch_get_main_queue(), {
                    let alertMessage = self.alert.createAlertView("Location not found.", title: "Search Error")
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                })
            }
        }
    }
}
