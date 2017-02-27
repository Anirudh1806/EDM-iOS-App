//
//  UserDetails.swift
//  EmergencyDisasterManagement
//
//  Created by admin on 2/19/17.
//  Copyright © 2017 Anurag Veerapaneni. All rights reserved.
//


import Foundation
import Parse
import Bolts
class UserDetails:PFObject {
    @NSManaged var userName:String
    @NSManaged var sesionLogin:String
    @NSManaged var sessionLogout:String

    init(userName:String) {
        super.init()
        self.userName = userName
        self.sesionLogin = ""
        self.sessionLogout = ""
    }
    
    override init() {
        super.init()
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: UserDetails.parseClassName())
        query.includeKey("user")
        return query
    }
}
extension UserDetails : PFSubclassing {
    
    class func parseClassName() -> String {
        return "UserDetails"
    }
    
}