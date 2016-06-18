//
//  ActivityIndicatorViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/18/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {

    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        activitySpinner.startAnimating()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        activitySpinner.stopAnimating()
    }

}
