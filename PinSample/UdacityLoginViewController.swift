//
//  ViewController.swift
//  UdacityLogin
//
//  Created by Steven Hertz on 7/22/15.
//  Copyright (c) 2015 Steven Hertz. All rights reserved.
//

import UIKit
import AVFoundation

class UdacityLoginViewController: UIViewController {
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    @IBOutlet weak var testLabel: UILabel!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let session = NSURLSession.sharedSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Mark: Login Button
    @IBAction func loginButton(sender: AnyObject) {
        UdacityLogin.oneSession.loginController(userText.text!, passWord: passWordText.text!) { (success, errorString) in
            if success {
                self.gotoNextScreen()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    
    /* Functions */
    
    func gotoNextScreen() {
        dispatch_async(dispatch_get_main_queue()) {
            var controller : UITabBarController
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("tabbar") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
            //      var controller : UINavigationController
            //      controller = self.storyboard?.instantiateViewControllerWithIdentifier("navctrl") as! UINavigationController
            //      self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func displayError(errorString: String?) {
        if let errorString = errorString {
            dispatch_async(dispatch_get_main_queue()) {
                let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {(paramAction:UIAlertAction) in print("The Done button was tapped - " + paramAction.title!)})
                
                alertController.addAction(action)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
}

