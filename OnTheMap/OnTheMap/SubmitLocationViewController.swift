//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/10/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocationViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var alertIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alertView: UIView!
    
    let studentInfo = Student(studentInfo: [:])
    let variables = Variables.sharedInstance()
    let alert = AlertViewController()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 10
        textView.text = "Enter a link to Share Here"
        textView.delegate = self
        mapStudentCoordinates()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        let presentingViewController = self.presentingViewController
        self.dismissViewControllerAnimated(false, completion: {
            presentingViewController!.dismissViewControllerAnimated(true, completion: {})
        })
        
        // Add observer to call 'refresh' on main screen (maybe observer for when THIS view is dismissed)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        textView.text = ""
    }
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        if textView.text != nil {
            variables.newUserDataDictionary["mediaURL"] = textView.text
        }
        
        startAlert()
        
        setNewLocationForStudent { (success) in
            if success {
                self.stopAlert({ (success) in
                    let presentingViewController = self.presentingViewController
                    self.dismissViewControllerAnimated(false, completion: {
                        presentingViewController!.dismissViewControllerAnimated(true, completion: {})
                    })
                })
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
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
}
