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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.userProfileIV.layer.cornerRadius = self.userProfileIV.frame.size.height / 2
        self.userProfileIV.clipsToBounds = true
        
        self.userProfileIV.layer.borderWidth = 3
        self.userProfileIV.layer.borderColor = UIColor.whiteColor().CGColor
        self.userProfileIV.userInteractionEnabled = true
        let user = PFUser.currentUser()!
        if let userImageFile = user["image"] as? PFFile {
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
            let image = UIImage(named: "DefaultImage")
            let imageData = UIImagePNGRepresentation(image!)
            let imageFile = PFFile(name: user.username, data: imageData!)
            
            self.userProfileIV.image = image
            
            user["image"] = imageFile
            
            user.saveInBackgroundWithBlock({(success,error)->Void in
                
                if error != nil {
                    print("Something has gone wrong saving in background: \(error)")
                } else {
                    print("Success while saving")
                }
                
            })
        }
        
        // Here we are setting the user full name to the current user's username.
        userFullNameLBL.text = PFUser.currentUser()?.username
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
