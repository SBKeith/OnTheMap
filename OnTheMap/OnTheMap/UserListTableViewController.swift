//
//  UserListTableViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/8/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {

    let udacityAPI = UdacityAPIManager.sharedInstance()
    let studentsInfo = StudentInformation.sharedInstance()

    @IBOutlet var mapTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentsInfo.allStudentsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let userName = "\(self.studentsInfo.allStudentsArray[indexPath.row].firstName!) \(self.studentsInfo.allStudentsArray[indexPath.row].lastName!)"
        let userURL = self.studentsInfo.allStudentsArray[indexPath.row].mediaURL!
   
        let cell = tableView.dequeueReusableCellWithIdentifier("kUserDetailsCell") as! CellLabelsUIView
        cell.userNameLabel.text = userName
        cell.userURLLabel.text = userURL

        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let url = NSURL(string: self.studentsInfo.allStudentsArray[indexPath.row].mediaURL!)
        
        if let url = url {
            UIApplication.sharedApplication().openURL(url)
        }
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
    
    @IBAction func refreshButtonTapped(sender: UIBarButtonItem) {
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidden = false
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mapTableView.reloadData()
        }
    }
}
