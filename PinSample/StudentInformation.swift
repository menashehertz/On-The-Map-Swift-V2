//
//  StudentInformation.swift
//  PinSample
//
//  Created by Steven Hertz on 8/28/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation


import Foundation

struct StudentInformation {
    
    var firstName : String
    var lastName : String
    var latitude : Double
    var longitude : Double
    var mediaURL : String
    var mapString : String
    var objectId : String
    var uniqueKey : String
    var createdAt : String
    var updatedAt : String
    
    init(mapDict: [String : AnyObject]) {
        self.firstName = mapDict["firstName"] as! String
        self.lastName = mapDict["lastName"] as! String
        self.latitude = mapDict["latitude"] as! Double
        self.longitude = mapDict["longitude"] as! Double
        self.mediaURL = mapDict["mediaURL"] as! String
        self.mapString = mapDict["mapString"] as! String
        self.objectId = mapDict["objectId"] as! String
        self.uniqueKey = mapDict["uniqueKey"] as! String
        self.createdAt = mapDict["createdAt"] as! String
        self.updatedAt = mapDict["updatedAt"] as! String
    }
}

