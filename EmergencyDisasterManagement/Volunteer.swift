//
//  File.swift
//  EmergencyDisasterManagement
//
//  Created by admin on 2/7/17.
//  Copyright © 2017 Anurag Veerapaneni. All rights reserved.
//

import Foundation
import Parse
import Bolts
class Volunteer : PFObject{
    @NSManaged var userName:String
    @NSManaged var password: String
    @NSManaged var emailID: String
    @NSManaged var dob:String
    @NSManaged var address:String
    @NSManaged var city:String
    @NSManaged var mobileNumber:String
    @NSManaged var state:String
    @NSManaged var cert:String
    @NSManaged var profession:String
    
    
    

    
    init(userName:String,password:String,emailID:String,dob:String,address:String,city:String,mobileNumber:String,state:String,cert:String,profession:String) {
        super.init()
        self.userName = userName
        self.password = password
        self.emailID = emailID
        self.dob = dob
        self.address = address
        self.city = city
        self.mobileNumber = mobileNumber
        self.state = state
        self.cert = cert
        self.profession = profession
    }
    
    override init() {
        super.init()
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Volunteer.parseClassName())
        query.includeKey("user")
        return query
    }
}

extension Volunteer : PFSubclassing {
    
    class func parseClassName() -> String {
        return "Volunteer"
    }
}