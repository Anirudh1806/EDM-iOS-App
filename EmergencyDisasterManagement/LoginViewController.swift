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

    
    var timestamp:String!
    //This is an outlet for the username Textfield.
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    //This an outlet for the password textfield.
    @IBOutlet weak var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundColor = hexStringToUIColor("#F0FFF0")
        
        self.view.backgroundColor = backgroundColor
        //This will adjust the view by sliding the view slghtly upwards.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    func getTimestamp() {
    }
    
    //This function will define how much should the screen size behidden
    //.
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
            //print("Hi")
            if user != nil {
                //print("Hello")
                let secondViewController = self.storyboard!.instantiateViewControllerWithIdentifier("SecondViewController") as! UserViewController
                self.navigationController!.pushViewController(secondViewController, animated: true)
                self.timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                let user =  UserDetails()
                user.sesionLogin = self.timestamp
                user.saveInBackgroundWithBlock({(success,error)->Void in
                    if error != nil {
                        print("Something has gone wrong saving in background: \(error)")
                    } else {
                        print("Success while saving")
                    }
                })
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
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}

