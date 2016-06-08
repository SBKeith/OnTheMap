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
    
    let apiManager = ParseAPIManager.sharedInstance()
    let udacityAPI = UdacityAPIManager.sharedInstance()
    let constants = Constants.sharedInstance()
    var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapStudentCoordinates()
    }
    
    func mapStudentCoordinates() {
        
        // Reset data array to avoid stacking new data on top of old!
        constants.userDataArray.removeAll()
        self.mapView.removeAnnotations(annotations)
        
        apiManager.getStudentLocations { (success, data, error) in
            if success {
                self.constants.locations = data as! [[String: AnyObject]]
            } else {
                // Display error message
                print("TEMP ERROR MESSAGE: NO LOCATIONS FOUND")
            }
            
            // We will create an MKPointAnnotation for each dictionary in "locations". The
            // point f will be stored in this array, and then provided to the map view.
            
            // The "locations" array is loaded with the sample data below. We are using the dictionaries
            // to create map annotations. This would be more stylish if the dictionaries were being
            // used to create custom structs. Perhaps StudentLocation structs.
            
            for dictionary in self.constants.locations {
                
                // Notice that the float values are being used to create CLLocationDegree values.
                // This is a version of the Double type.
                let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = dictionary["firstName"] as! String
                let last = dictionary["lastName"] as! String
                let mediaURL = dictionary["mediaURL"] as! String
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                self.annotations.append(annotation)
            }
            
            // When the array is complete, we add the annotations to the map.
            dispatch_async(dispatch_get_main_queue(), {
                self.mapView.addAnnotations(self.annotations)
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

    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}