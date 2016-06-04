//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Keith Kowalski on 6/4/16.
//  Copyright © 2016 TouchTapApp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: Properties
    var keyboardOnScreen = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToNotification(UIKeyboardWillShowNotification, selector: #selector(keyboardWillShow))
        subscribeToNotification(UIKeyboardWillHideNotification, selector: #selector(keyboardWillHide))
        subscribeToNotification(UIKeyboardDidShowNotification, selector: #selector(keyboardDidShow))
        subscribeToNotification(UIKeyboardDidHideNotification, selector: #selector(keyboardDidHide))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboardFromView(_:))))
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        
        userDidTapView(self)
        
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            debugLabel.text = "Username or Password Empty."
        } else {
            setUIEnabled(false)
            
            /*
             Steps for Authentication...
             https://docs.google.com/document/d/1MECZgeASBDYrbBg7RlRu9zBBLGd3_kfzsN-0FtURqn0/pub?embedded=true#h.x5crhfekac4e
             
             Step 1: Create a request token
             Step 2: Ask the user for permission via the API ("login")
             Step 3: Create a session ID
             
             Extra Steps...
             Step 4: Get the user id ;)
             Step 5: Go to the next view!
             */
            getSessionID({ (success, data, errorString) in
                
                if success {
                    
                    print(String(data: data, encoding: NSUTF8StringEncoding)!)
                    
                    
                    
                    
//                    self.getUserData(sessionID!)
                } else {
                    print(errorString)
                }
            })
        }

    }
    
    private func getSessionID(completionHandlerForToken: (success: Bool, data: NSData, errorString: String?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"cwafavre@gmail.com\", \"password\": \"Teeker1435\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandlerForToken(success: false, data: data!, errorString: "ERROR")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            completionHandlerForToken(success: true, data: newData, errorString: nil)
        }
        task.resume()
    }
    
    private func getUserData(sessionID: String) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/\(sessionID)")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}


// MARK: - LoginViewController (Notifications)

extension LoginViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

