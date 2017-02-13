//
//  RespondViewController.swift
//  EmergencyDisasterManagement
//
//  Created by admin on 2/7/17.
//  Copyright © 2017 Anurag Veerapaneni. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation
class RespondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let impactLevel:[String] = ["Low", "Medium","High"]
    let changeColor = "Black,Red,Yellow,Green"
    var victimNumbers:[String] = []
    var levelOfImpact:String = ""
    var location:[Double] = []

   // var range = (main_string as NSString).rangeOfString(string_to_color)
    
    @IBOutlet weak var numberOfVictims: UITextField!
    
    @IBOutlet weak var commentsTF: UITextView!
    @IBAction func reportDisaster(sender: AnyObject){
        victimNumbers = (numberOfVictims.text?.componentsSeparatedByString(","))!
        let username = "\((PFUser.currentUser()?.username)!)"
        print(username)
        let newDisaster = Disaster(userName: username, blackVictims: Int(victimNumbers[0])!, redVictims: Int(victimNumbers[1])!, yellowVictims: Int(victimNumbers[2])!, greenVictims: Int(victimNumbers[3])!, levelOfImpact: levelOfImpact, comments: commentsTF.text)
        newDisaster.location = location
        newDisaster.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                print("Successfully saved Rating for room No:")
            } else {
                
                if let error = error {
                    print("Something terrible happened. Something like \(error.localizedDescription)")
                }
            }
        })
    }

    //Function to fetch user's current location
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]){
        print("hello")
        let location1 = locations.last
        let locationValue = CLLocationCoordinate2D(latitude: (location1?.coordinate.latitude)!, longitude: (location1?.coordinate.longitude)!)
        print((location1?.coordinate.latitude)!)
        location.append(locationValue.latitude)
        location.append(locationValue.longitude)
    }
  
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func allowMaps(sender: AnyObject) {
        //locationManager()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func displayAlertBTN(sender: AnyObject) {
         displayAlertWithTitle("", message: "Please enter the numbers of victims in the above order")
    }
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return impactLevel.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return impactLevel[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        levelOfImpact = impactLevel[row]
        
    }
    // Function that displays an Alert Message with the passed in title and message
    func displayAlertWithTitle(title:String, message:String){
        
        let attributedString1:NSMutableAttributedString = NSMutableAttributedString(string:  changeColor , attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(15), //your font here
            NSForegroundColorAttributeName : UIColor.blackColor()
            ])
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: 6,length: 3))
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.yellowColor(), range: NSRange(location: 10,length: 6))
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSRange(location: 17,length: 5))

        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.setValue(attributedString1, forKey: "attributedTitle")
        

        let defaultAction:UIAlertAction =  UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(defaultAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
