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
}
