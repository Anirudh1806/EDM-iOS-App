//
//  ForgotPasswordViewController.swift
//  EmergencyDisasterManagement
//
//  Created by admin on 2/28/17.
//  Copyright © 2017 Anurag Veerapaneni. All rights reserved.
//

import UIKit
import Parse
class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundColor = hexStringToUIColor("#F0FFF0")
        self.view.backgroundColor = backgroundColor

        self.navigationController?.setNavigationBarHidden(false, animated: true)

        // Do any additional setup after loading the view.
            }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBOutlet weak var emailTF: UITextField!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendPassword(sender: AnyObject) {
        let userEmail = emailTF.text!
        PFUser.requestPasswordResetForEmailInBackground(userEmail) {
            (success:Bool, error:NSError?) -> Void in
            if(success)
            {
                let successMessage = "Email message was sent to you at \(userEmail)"
                self.displayMessage(successMessage)
                return
            }
            if(error != nil)
            {
                let errorMessage:String = error!.userInfo["error"] as! String
                self.displayMessage(errorMessage)
            }
        }
    }
    
    func displayMessage(theMesssage:String)
    {
        // Display alert message with confirmation.
        var myAlert = UIAlertController(title:"Alert", message:theMesssage, preferredStyle: UIAlertControllerStyle.Alert);let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion:nil);
        }
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated:true, completion:nil);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
