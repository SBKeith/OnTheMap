//
//  AlertViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/15/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    func createAlertView(message: String, title: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        return alertController
    }
}