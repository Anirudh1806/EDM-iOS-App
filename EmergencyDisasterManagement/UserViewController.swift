//
//  UserViewController.swift
//  EmergencyDisasterManagement
//
//  Created by admin on 1/29/17.
//  Copyright © 2017 Anurag Veerapaneni. All rights reserved.
//

import UIKit
import Parse
import Bolts
class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userFullNameLBL: UILabel!
    @IBOutlet weak var userProfileIV: UIImageView!

    
    @IBAction func logOutBTN(sender: AnyObject) {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        print(timestamp)
        //let time = LoginViewController.timestamp
        let user =  UserDetails()
        user.sessionLogout = timestamp
        user.saveInBackgroundWithBlock({(success,error)->Void in
            if error != nil {
                print("Something has gone wrong saving in background: \(error)")
            } else {
                print("Success while saving")
                
            }
        })
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = hexStringToUIColor("#F0FFF0")
        self.view.backgroundColor = backgroundColor
        
//        var imageView = UIImageView(frame: CGRectMake(100, 150, 75, 150)); // set as you want
//        var image = UIImage(named: "DefaultImage");
//        imageView.image = image;
//        self.view.addSubview(imageView);
        
        // Do any additional setup after loading the view.
//        self.userProfileIV.frame = CGRectMake(100, 150, 150, 150)
//        self.userProfileIV.layer.cornerRadius = self.userProfileIV.frame.size.height / 2
//        self.userProfileIV.clipsToBounds = true
//        self.userProfileIV.layer.borderWidth = 3
//        self.userProfileIV.layer.borderColor = UIColor.whiteColor().CGColor
//        self.userProfileIV.userInteractionEnabled = true
        self.userProfileIV.image = UIImage(named:"Gender Neutral User Filled-100.png" )
        let user = PFUser.currentUser()
        if let userImageFile = user!["image"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        self.userProfileIV.image = UIImage(data:imageData)
                    }
                } else {
                    print("Something has happened: \(error)")
                }
            }
        } else {
            //This part is to default image when the user doesnot select any.
            let image = UIImage(named: "DefaultImage")
            let imageData = UIImagePNGRepresentation(image!)
            let imageFile = PFFile(name: user!.username, data: imageData!)
            self.userProfileIV.image = image
            user!["image"] = imageFile
            user!.saveInBackgroundWithBlock({(success,error)->Void in
                if error != nil {
                    print("Something has gone wrong saving in background: \(error)")
                } else {
                    print("Success while saving")
                }
            })
        }
        // Here we are setting the user full name to the current user's username.
        userFullNameLBL.text = PFUser.currentUser()?.username
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    //This function will allow user to access gallery and upload a picture
    @IBAction func profilePictureTapped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    // This function tell what should be done once the user is done picking an image. This basically get the image and saves it in the backend to be retrieved later.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageData = UIImagePNGRepresentation(image!)
        let imageFile = PFFile(name: PFUser.currentUser()?.username!, data: imageData!)
        PFUser.currentUser()?["image"] = imageFile
        PFUser.currentUser()?.saveInBackgroundWithBlock({(success,error) in
            if error != nil {
                print("Something has gone wrong saving in background in imagePickerController(): \(error)")
            } else {
                print("Success while saving")
            }
            
        })
        
        
        userProfileIV.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
