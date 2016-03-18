//
//  UdacityUser.swift
//  PinSample
//
//  Created by Steven Hertz on 8/25/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import Foundation

struct Account {
    let registered: Bool
    let key: String
}

struct Session {
    let id: String
    let expiration: String
}

class UdacityUser {
    static let oneSession = UdacityUser()

    var account: Account
    var session: Session
    var firstName: String
    var lastName: String
    
    init(dict :[String:[String:AnyObject]] ) {
        self.account = Account(registered: dict["account"]!["registered"] as! Bool, key: dict["account"]!["key"] as! String)
        self.session = Session(id: dict["session"]!["id"] as! String, expiration: dict["session"]!["expiration"]  as! String)
        self.firstName = ""
        self.lastName = ""
    }

    func populatewithDict(dict :[String:[String:AnyObject]] ) {
        UdacityUser.oneSession.account = Account(registered: dict["account"]!["registered"] as! Bool, key: dict["account"]!["key"] as! String)
        UdacityUser.oneSession.session = Session(id: dict["session"]!["id"] as! String, expiration: dict["session"]!["expiration"]  as! String)
        UdacityUser.oneSession.firstName = ""
        UdacityUser.oneSession.lastName = ""
       
    }

    init() {
        self.account = Account(registered: false, key: "")
        self.session = Session(id: "", expiration: "" )
        self.firstName = ""
        self.lastName = ""
    }
    //    init(registered: Bool, key: String, id: String, expiration: String ) {
    //        self.account = Account(registered: registered, key: key)
    //        self.session = Session(id: id, expiration: expiration)
    //    }
}
