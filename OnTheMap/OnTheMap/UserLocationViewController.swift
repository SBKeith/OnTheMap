//
//  UserLocationViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/8/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class UserLocationViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findButton.layer.cornerRadius = 10
    }
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}
