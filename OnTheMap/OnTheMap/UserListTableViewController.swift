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
}
