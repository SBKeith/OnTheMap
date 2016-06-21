//
//  ViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/4/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    let parseAPI = ParseAPIManager.sharedInstance()
    let udacityAPI = UdacityAPIManager.sharedInstance()
    let studentsInfo = StudentInformation.sharedInstance()
    let variables = Variables.sharedInstance()
    let alert = AlertViewController()
    var annotations = [MKPointAnnotation]()
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapStudentCoordinates()
    }
    
    func mapStudentCoordinates() {
        // Reset data array to avoid stacking new data on top of old!
        
        studentsInfo.allStudentsArray.removeAll()
        self.mapView.removeAnnotations(annotations)
        
        activitySpinner.startAnimating()
        activityView.hidden = false
        
        parseAPI.getStudentLocations { (success, data, error) in
            if success {
                self.variables.locations = data
            } else {
                // Display error message
                dispatch_async(dispatch_get_main_queue(), {
                    // Jump back to login screen
                    self.logoutButtonTapped(self.logoutButton)
                    // Set the active view controller for UIAlertView to use
                    let activeViewController = self.navigationController?.visibleViewController
                    // Set and present the alert
                    let alertMessage = self.alert.createAlertView("User data download failed; there was an error with server communication.", title: "Data Error")
                    activeViewController?.presentViewController(alertMessage, animated: true, completion: nil)
                })
            }
    
            for dictionary in self.variables.locations {
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let annotation = MKPointAnnotation()
                
                if let lat = dictionary.lat, let long = dictionary.long {
                    let latitude = CLLocationDegrees(lat)
                    let longitude = CLLocationDegrees(long)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.coordinate = coordinate
                }
                let first = dictionary.firstName!
                let last = dictionary.lastName!
                let mediaURL = dictionary.mediaURL!
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                self.annotations.append(annotation)
            }
            
            // When the array is complete, we add the annotations to the map.
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotations(self.annotations)
                self.activityView.hidden = true
                self.activitySpinner.stopAnimating()
            })
        }
    }
    
    @IBAction func refreshMapButtonTapped(sender: UIBarButtonItem) {
        mapStudentCoordinates()
    }
    
    @IBAction func logoutButtonTapped(sender: UIBarButtonItem) {
        
        let controller =  UIStoryboard.init(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("kLoginID")
        self.presentViewController(controller, animated: true, completion: nil)
        
        udacityAPI.logUserOut { (success, data, errorString) in
            if success {
                // Show spinner?
            } else {
                print("Error with logout process...")
            }
        }
    }

    // MARK: - MKMapViewDelegates
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

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}