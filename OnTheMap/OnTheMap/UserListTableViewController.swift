//
//  UserListTableViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/8/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {

    let apiManager = Constants.sharedInstance()
    let udacityAPI = UdacityAPIManager.sharedInstance()

    @IBOutlet var mapTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return apiManager.userDataArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let userName = "\(self.apiManager.userDataArray[indexPath.row]["firstName"]!) \(self.apiManager.userDataArray[indexPath.row]["lastName"]!)"
        let userURL = self.apiManager.userDataArray[indexPath.row]["mediaURL"]!
   
        let cell = tableView.dequeueReusableCellWithIdentifier("kUserDetailsCell") as! CellLabelsUIView
        cell.userNameLabel.text = userName as String
        cell.userURLLabel.text = userURL as? String

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = NSURL(string: self.apiManager.userDataArray[indexPath.row]["mediaURL"]! as! String)
        
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
        
        dispatch_async(dispatch_get_main_queue()) { 
            
            self.mapTableView.reloadData()
        }
    }
}
