//
//  ProfileSettingsViewController.swift
//  EmergencyDisasterManagement
//
//  Created by admin on 2/28/17.
//  Copyright © 2017 Anurag Veerapaneni. All rights reserved.
//

import UIKit
import Parse
class ProfileSettingsViewController: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var professionTF: UITextField!
    @IBOutlet weak var certTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = hexStringToUIColor("#F0FFF0")
        self.view.backgroundColor = backgroundColor
        //let backgroundColor = hexStringToUIColor("#B39DDB")
        //self.view.backgroundColor = backgroundColor
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //passwordTF.text = PFUser.currentUser()?.username
        // Do any additional setup after loading the view.
        var volunteer = PFQuery(className: "Volunteer")
        //print(PFUser.currentUser()!.username!)
        volunteer.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
        do{
            var obj = try volunteer.findObjects()
            for object in obj {
                print(obj)
                
                passwordTF.text = object["password"]! as! String
                addressTF.text = object["address"]! as! String
                professionTF.text = object["profession"]! as! String
                certTF.text = object["cert"] as! String
                cityTF.text = object["city"] as! String
                stateTF.text = object["state"] as! String
                mobileTF.text = object["mobileNumber"] as! String
            }

        }
        catch{
            print("Volunteer not found")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //passwordTF.text = PFUser.currentUser()?.username
        //print(PFUser.currentUser()?.password)
        var volunteer = PFQuery(className: "Volunteer")
        //print(PFUser.currentUser()!.username!)
        volunteer.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
        do{
            var obj = try volunteer.findObjects()
            for object in obj {
                //print(obj)
                passwordTF.text = object["password"]! as! String
                addressTF.text = object["address"]! as! String
                professionTF.text = object["profession"]! as! String
                certTF.text = object["cert"] as! String
                cityTF.text = object["city"] as! String
                stateTF.text = object["state"] as! String
                mobileTF.text = object["mobileNumber"] as! String
            }
            
        }
        catch{
            print("Volunteer not found")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitBTN(sender: AnyObject) {
        if passwordTF.text! == "" || professionTF.text! == "" || certTF.text! == "" || addressTF.text! == "" || mobileTF.text! == "" || cityTF.text! == "" || stateTF.text! == "" {
            displayAlertWithTitle("Empty fileds",message: "Please fill all the details")
        }
        else {
            if passwordTF.text!.containsString(" ") || passwordTF.text!.characters.count < 8 {
                displayAlertWithTitle("Password format error", message: "password cannot contain spaces and cannot be lessthan 8 characters")
            }
            else {
                if mobileTF.text!.componentsSeparatedByString("-").count != 3 || mobileTF.text!.componentsSeparatedByString("-")[0].characters.count != 3 || mobileTF.text!.componentsSeparatedByString("-")[1].characters.count != 3 || mobileTF.text!.componentsSeparatedByString("-")[2].characters.count != 4 {
                    displayAlertWithTitle("Incorrect phone number", message: "Enter a valid phone number which of length 10 digits in the format xxx-xxx-xxxx")
                }
                else {
                    if Int(mobileTF.text!.componentsSeparatedByString("-")[0]) == nil || Int(mobileTF.text!.componentsSeparatedByString("-")[1]) == nil || Int(mobileTF.text!.componentsSeparatedByString("-")[2]) == nil {
                        displayAlertWithTitle("Incorrect phone number", message: "Enter a valid phone number in the format xxx-xxx-xxxx")
                        
                    }
                    else {
//                    var passwordCheckQuery = PFQuery(className: "User")
//                    passwordCheckQuery.whereKey("username", equalTo: PFUser.currentUser()!.username!)
//                    do{
//                    var objects = try passwordCheckQuery.findObjects()
//                    for object in objects {
//                        print("Hello in user password")
//                        print(object)
//                        
//                    }
//                    }
//                    catch {
//                        
//                    }
                    var volunteer = PFQuery(className: "Volunteer")
                    //print(PFUser.currentUser()!.username!)
                    volunteer.whereKey("userName", equalTo: PFUser.currentUser()!.username!)
                    do{
                        var obj = try volunteer.findObjects()
                       for object in obj {
                            //print(obj)
                            object["password"] = passwordTF.text!
                            object["address"] = addressTF.text!
                            object["profession"] = professionTF.text!
                            object["cert"] = certTF.text!
                            object["city"] = cityTF.text!
                            object["state"] = stateTF.text!
                            object["mobileNumber"] = mobileTF.text!
                            do {
                                try object.save()
                            }
                            catch {
                                print("obj not saved")
                            }
                        }
                        
                        

                    }
                    catch{
                        print("Volunteer not found")
                    }
                    
                }
                }
                
            }
        }
    }
    
    func displayAlertWithTitle(title:String, message:String){
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
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
