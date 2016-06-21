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
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findButton.layer.cornerRadius = 10
        locationTextView.delegate = self
        locationTextView.text = "Enter Your Location Here"
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    func textViewDidBeginEditing(textView: UITextView) {
        locationTextView.text = ""
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findButtonTapped(sender: UIButton) {
        
        self.startAlert()
        
        // Get LAT / LONG
        variables.getLatLong(locationTextView.text) {(success, error) in
            if success {
                self.stopAlert({ (success) in
                    // present new location submission VC
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("kSubmitVC") as! SubmitLocationViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                })
            } else {
                self.stopAlert({ (success) in
                    dispatch_async(dispatch_get_main_queue(), {
                        let alertMessage = self.alert.createAlertView("Location not found.", title: "Search Error")
                        self.presentViewController(alertMessage, animated: true, completion: nil)
                    })
                })
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func startAlert() {
        activityIndicator.startAnimating()
        activityView.hidden = false
        activityIndicator.hidden = false
    }
    
    func stopAlert(completionHandler: (success:Bool) -> Void) {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        activityView.hidden = true
        
        completionHandler(success: true)
    }

}
