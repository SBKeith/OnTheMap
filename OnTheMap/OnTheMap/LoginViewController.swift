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
    
    let apiManager = UdacityAPIManager.sharedInstance()
    let constants = Constants()
    
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
    
    @IBAction func signUpButtonTapped(sender: UIButton) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: constants.kUdacitySignUp)!)
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
             
             Step 1: Create a session ID
             Step 2: Get the user key
             Step 3: Go to the next view!
             */
            
            // STEP 1:
            apiManager.getSessionID(emailTextField.text!, password: passwordTextField.text!, completionHandlerForToken: { (success, data, errorString) in
                if success {
                    // STEP 2:
                    self.apiManager.getUserData({ (success, data, errorString) in
                        if success {
                            // STEP 3:
                            // Segue to new view controller (map view)
                            self.completeLogin()

                            print("\(self.apiManager.sessionID!)\n\(self.apiManager.userKey!)\n\(self.apiManager.firstName!) \(self.apiManager.lastName!)")
                        } else {
                            self.debugLabel.text = errorString
                        }
                    })
                } else {
                    self.debugLabel.text = errorString
                }
            })
        }

    }
    
    private func completeLogin() {
        performUIUpdatesOnMain {
            self.debugLabel.text = ""
            self.setUIEnabled(true)
            let controller =  UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("kMainID") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        }
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

