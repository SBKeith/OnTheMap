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
    let constants = Constants.sharedInstance()
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
            constants.newUserDataDictionary["mediaURL"] = textView.text
        }
        
        alertIndicator.startAnimating()
        alertView.hidden = false
        alertIndicator.hidden = false
        
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
    
    // MOVE TO MODEL
    
    func startAlert() {
        
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
            
        let dictionary = self.constants.newUserDataDictionary
            
        let lat = dictionary["lat"] as! Double
        let long = dictionary["long"] as! Double
        
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
        annotation.subtitle = constants.newUserDataDictionary["newLoc"] as? String
        
        // Finally we place the annotation in an array of annotations.
        self.annotations.append(annotation)
    
        // May need to complete in closure... (below)
        
        // When the array is complete, we add the annotations to the map.
        dispatch_async(dispatch_get_main_queue(), {
            self.mapView.addAnnotations(self.annotations)
        })
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
    
    func setNewLocationForStudent(completionHandler: (success: Bool) -> Void) {
        
        let studentInfo = Student.init(studentInfo: self.constants.newUserDataDictionary)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.HTTPBody = "{\"uniqueKey\": \"\(studentInfo!.userKey!)\", \"firstName\": \"\(studentInfo!.firstName!)\", \"lastName\": \"\(studentInfo!.lastName!)\",\"mapString\": \"\(studentInfo!.newLocation!)\", \"mediaURL\": \"\(studentInfo!.mediaURL!)\", \"latitude\": \(studentInfo!.lat!), \"longitude\": \(studentInfo!.long!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        // OVERWRITE PREVIOUS LOCATION BEFORE SETTING NEW ON MAP!!  (below)
        
        // See if posting student location returns objectID in 'data' or 'response' JSON (task call below)
        // User objectID to check if previous location has been store
        // If not, POST new data; otherwise, PUT new data via objectID...
        
        let session = NSURLSession.sharedSession()

        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                dispatch_async(dispatch_get_main_queue(), {
                    let alertMessage = self.alert.createAlertView("User data upload failed.", title: "Upload Error")
                    self.presentViewController(alertMessage, animated: true, completion: nil)
                })
            } else if error == nil {
                completionHandler(success: true)
            }
        }
        task.resume()
    }
}
