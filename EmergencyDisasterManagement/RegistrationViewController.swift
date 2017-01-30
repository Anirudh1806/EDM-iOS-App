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
    }
    
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var dobTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // This function is called once the user taps on the signUp button. This function registers a user.
    @IBAction func signUpBTN(sender: AnyObject) {
        let user = PFUser()
        
        user.username = userNameTF.text!
        user.password = passwordTF.text!
        user.email = emailTF.text!
        
        let image = UIImage(named: "DefaultImage")
       // let imageData = UIImagePNGRepresentation(image!)
       // let imageFile = PFFile(name: userNameTF.text!, data: imageData!)
        
       // user["image"] = imageFile
        user.signUpInBackgroundWithBlock {
            succeded, error in
            if succeded {
                print(PFUser.currentUser()?.username)
                
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
    
    // Function that displays an Alert Message with the passed in title and message.
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
