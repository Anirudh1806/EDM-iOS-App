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
class Disaster:PFObject {
    @NSManaged var userName:String
    @NSManaged var blackVictims:Int
    @NSManaged var redVictims:Int
    @NSManaged var yellowVictims:Int
    @NSManaged var greenVictims:Int
    @NSManaged var location:[Double]!
    @NSManaged var levelOfImpact:String!
    @NSManaged var comments:String!
    @NSManaged var image:PFFile!

    
    init(userName:String,blackVictims:Int,redVictims:Int,yellowVictims:Int,greenVictims:Int,levelOfImpact:String,comments:String) {
        super.init()
        self.userName = userName
        self.blackVictims = blackVictims
        self.redVictims = redVictims
        self.yellowVictims = yellowVictims
        self.greenVictims = greenVictims
        self.location = []
        self.levelOfImpact = levelOfImpact
        self.comments = comments
    }
    
    override init() {
        super.init()
    }
    
    override class func query() -> PFQuery? {
        let query = PFQuery(className: Disaster.parseClassName())
        query.includeKey("user")
        return query
    }
}
extension Disaster : PFSubclassing {
    
    class func parseClassName() -> String {
        return "Disaster"
    }
}