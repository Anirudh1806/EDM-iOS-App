//
//  RegistrationViewController.swift
//  Remindinator
//
//  Created by Peram,Vinod Kumar Reddy on 10/25/16.
//  Copyright © 2016 Parne,Pruthivi R. All rights reserved.
//

import UIKit
import Parse

class RegistrationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = hexStringToUIColor("#F0FFF0")
        self.view.backgroundColor = backgroundColor
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    //Created the references for the outlets in the view
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var certTF: UITextField!
    
    @IBOutlet weak var professionTF: UITextField!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // This function is called once the user taps on the signUp button. This function registers a user
    @IBAction func signUpBTN(sender: AnyObject) {
        let user = PFUser()
        if userNameTF.text! == "" || passwordTF.text! == "" || emailTF.text! == "" || dobTF.text! == "" || addressTF.text! == "" || cityTF.text! == "" || mobileNumberTF.text! == "" || stateTF.text! == "" || certTF.text! == "" {
            displayAlertWithTitle("Empty Fileds", message: "Please fill all the text fields")
        }
        else {
            if passwordTF.text!.containsString(" ") || passwordTF.text!.characters.count < 8 {
                displayAlertWithTitle("Password Error", message: "Password should not contain spaces and should be 8 characters long")
            }
            else {
                if !emailTF.text!.containsString("@"){
                    displayAlertWithTitle("Incorrect email", message: "Enter a valid email address")
                }
                else{
                    if mobileNumberTF.text!.componentsSeparatedByString("-").count != 3 || mobileNumberTF.text!.componentsSeparatedByString("-")[0].characters.count != 3 || mobileNumberTF.text!.componentsSeparatedByString("-")[1].characters.count != 3 || mobileNumberTF.text!.componentsSeparatedByString("-")[2].characters.count != 4  {
                        displayAlertWithTitle("Incorrect phone number", message: "Enter a valid phone number which of length 10 digits in the format xxx-xxx-xxxx")
                    }
                    else {
                        if !(dobTF.text!.componentsSeparatedByString("/").count == 3) {
                            displayAlertWithTitle("Incorrect DOB", message: "Enter a valid date of birth in the format MM/DD/YYYY")
                        }
                        else {
                            if Int(mobileNumberTF.text!.componentsSeparatedByString("-")[0]) == nil || Int(mobileNumberTF.text!.componentsSeparatedByString("-")[1]) == nil || Int(mobileNumberTF.text!.componentsSeparatedByString("-")[2]) == nil {
                                displayAlertWithTitle("Incorrect phone number", message: "Enter a valid phone number in the format xxx-xxx-xxxx")
                            }
                            else {
                                user.username = userNameTF.text!
                                user.password = passwordTF.text!
                                user.email = emailTF.text!
                                let volunteer = Volunteer(userName: userNameTF.text!,password: passwordTF.text!,emailID: emailTF.text!,dob: dobTF.text!,address: addressTF.text!,city: cityTF.text!,mobileNumber: mobileNumberTF.text!,state: stateTF.text!,cert: certTF.text!, profession: professionTF.text!)
//                                volunteer.saveInBackgroundWithBlock({ (success, error) -> Void in
//                                    if success {
//                                        print("Success")
//                                    } else {
//                                        
//                                        
//                                        if let error = error {
//                                            print("Something terrible happened. Something like \(error.localizedDescription)")
//                                        }
//                                    }
//                                })
                                user.signUpInBackgroundWithBlock {
                                    succeded, error in
                                    if succeded {
                                        volunteer.saveInBackgroundWithBlock({ (success, error) -> Void in
                                            if success {
                                                print("Success")
                                            } else {
                                                
                                                
                                                if let error = error {
                                                    print("Something terrible happened. Something like \(error.localizedDescription)")
                                                }
                                            }
                                        })
                                        print(PFUser.currentUser()?.username!)
                                        self.displayAlertWithTitle1("Sign up successful", message: "Login to report a disaster")
                                        //self.navigationController?.popViewControllerAnimated(true)
                                        
                                    } else {
                                        self.displayAlertWithTitle("Whoops!", message: "\(error!.localizedDescription)")
                                        
                                        let emailVerified = user["emailVerified"]
                                        if emailVerified != nil && (emailVerified as! Bool) == true {
                                            // Everything is fine
                                        } else {
                                            // The email has not been verified, so logout the user
                                            PFUser.logOut()
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
    }
    
    // Function that displays an Alert Message with the passed in title and message.
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func displayAlertWithTitle1(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(action)
        
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
