//
//  ViewController.swift
//  EmergencyDisasterManagement
//
//  Created by admin on 1/24/17.
//  Copyright © 2017 Anurag Veerapaneni. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {

    //This is an outlet for the username Textfield.
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    //This an outlet for the password textfield.
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //This will adjust the view by sliding the view slghtly upwards.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    //This function will define how much should the screen size be displayed
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2
            }
            else {
                
            }
        }
        
    }
    
    //This function will define how much should the screen size be hidden
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
               // self.view.frame.origin.y += keyboardSize.height/2
            }
            else {
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//This function will perform a segue upon entering valid username and password
    @IBAction func LoginViewController(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(userNameTF.text!, password: passwordTF.text!) {
            user, error in
            if user != nil {
                self.performSegueWithIdentifier("LoginSuccessful", sender: self)
            } else if let error = error {
                self.displayAlertWithTitle("Login Unsuccessful", message: error.localizedDescription)
            }
        }
    }
    
    // Function that displays an Alert Message with the passed in title and message
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}

