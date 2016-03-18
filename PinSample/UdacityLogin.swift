//
//  UdacityLogin.swift
//  PinSample
//
//  Created by Steven Hertz on 7/28/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import Foundation

class UdacityLogin {
    static let oneSession = UdacityLogin()
    
    var myUdacityUser : UdacityUser!
    /* Literals needed to login */
    let baseURLSecureStringLit = "https://www.udacity.com/api/session"
    let rootLoginDictLit = "udacity"
    let userNameLit = "username"
    let passwordLit = "password"
    
    var tester = ""


    /* Main Process Functions */
    
    /*
    Drives the process and does 2 things
    - logs in to Udacity
    - and if succesful gets the location data from Parse
    */
    func loginController(userId: String, passWord: String, completionHandler: (success: Bool, errorString: String) -> Void) {
        
        self.loginToUdacity(userId, passWord: passWord)  { (success, errorString, studentKey) in

            if success {
           
                self.getUdacityStudentData(studentKey) { (success, errorString) in
                
                    if success {

                        AllMapLocations.oneSession.getAllMapLocationsNew() { (success, errorString) in
                        
                            if success {
                                completionHandler(success: true, errorString: "From loginController  " + errorString)
                            } else {
                                completionHandler(success: false, errorString: errorString)
                            }
                        }
                    } else {
                         completionHandler(success: false, errorString: errorString)
                    }
                }
            } else {
                completionHandler(success: false, errorString: errorString)
            }
        }
    }


    
        /*
    Logs in to Udacity
    Takes a closure to will do another step if the login is complete
    */
    func loginToUdacity(userId: String, passWord: String, completionHandler: (success: Bool, errorString: String, studentKey: String) -> Void) {
        
        // a dictionary whos first key "udacity" contains other dictionaries
        var loginStringDictionary = [rootLoginDictLit: [:]]
        
        // populate the values (login Info) of the sub dictionary
        var subDict : [String : String] = [:]
        subDict.updateValue(userId, forKey: userNameLit)
        subDict.updateValue(passWord, forKey: passwordLit)
        
        // update the main dictionary with the sub dictionary
        loginStringDictionary[rootLoginDictLit] = subDict
        
        // convert the swift dictionary to Json
        let theJSONText = convertToJson(loginStringDictionary)!
        
        /* 2. Build the URL */
        let urlString = UdacityLogin.oneSession.baseURLSecureStringLit
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "\(theJSONText)".dataUsingEncoding(NSUTF8StringEncoding)
        
        /* 4. Make the request */
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                completionHandler(success: false, errorString: "Could not connect to Udacity" , studentKey: "")
                print("Could not complete the request \(error)")
            }
            else {
                /* 5. Parse the data */
                let downloadedDataCleaned = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
                print(NSString(data: downloadedDataCleaned, encoding: NSUTF8StringEncoding)!)
                
                var parsingError: NSError? = nil
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(downloadedDataCleaned, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                if let errorParsing = parsingError {
                    print("Could not parse the result: \(errorParsing)")
                }
                else {
                    if let dict = parsedResult["account"] as? [String : AnyObject] {
                        let registered = dict["registered"] as! Bool
                        if registered {
                            UdacityUser.oneSession.populatewithDict(parsedResult as! [String:[String:AnyObject]])
                            completionHandler(success: true, errorString: "No error", studentKey: UdacityUser.oneSession.account.key)
                            self.tester = UdacityUser.oneSession.account.key
                        }
                        else {
                            print("didn't have the key registerd in the dictionary - Not valid credentials")
                            completionHandler(success: false, errorString: "didn't have the key registerd in the dictionary - Not valid credentials" , studentKey: "")
                        }
                    }
                    else {
                        if let errorDict = parsedResult as? [String : AnyObject] {
                            let errorText: AnyObject? = errorDict["error"]
                            print("in dict didn't have the KEY account in the dictionary" )
                            completionHandler(success: false, errorString: errorText! as! String , studentKey: "")
                        } else {
                            print("not in dict didn't have the KEY account in the dictionary" )
                            completionHandler(success: false, errorString: "didn't have the KEY account in the dictionary" , studentKey: "")
                        }
                    }
                } // end of the succesful completion of the parsing
            } // end of the succesful completion of dataTask
        } // end of closure
        
        /* 7. Start the request */
        task.resume()
    }
    
    func getUdacityStudentData(studentKey: String, completionHandler: (success: Bool, errorString: String) -> Void)  {
        let strUrl = "https://www.udacity.com/api/users" + "/" + studentKey
        let request = NSMutableURLRequest(URL: NSURL(string: strUrl )!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                print("error in getting user data")
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            //println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            
            var parsingError: NSError? = nil
            let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
            if let errorParsing = parsingError {
                print("Could not parse the result: \(errorParsing)")
            }
            else {
                if let dict = parsedResult["user"] as? [String : AnyObject] {
                    let lastName = dict["last_name"] as! String
                    UdacityUser.oneSession.lastName = lastName
                    let firstName = dict["first_name"] as! String
                    UdacityUser.oneSession.firstName = firstName
                }
                completionHandler(success: true, errorString: "No error")
            }
        }
        task.resume()
    }

    
    /* Helper Functions */

    /**
    Converts a dictionary to a Json string
    
    - parameter objectToConvert: is a swift dictionary
    - returns: Json string
    */
    func convertToJson(objectToConvert : AnyObject) -> NSString? {
        if NSJSONSerialization.isValidJSONObject(objectToConvert) {
            if let theJSONData = try? NSJSONSerialization.dataWithJSONObject(objectToConvert, options: NSJSONWritingOptions(rawValue: 0)) {
                if let theJSONStr = NSString(data: theJSONData, encoding: NSASCIIStringEncoding) {
                    return theJSONStr
                }
            }
        }
        return "error"
    }

}

