//
//  AllMapLocations.swift
//  PinSample
//
//  Created by Steven Hertz on 7/31/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class AllMapLocations {

    static let oneSession = AllMapLocations()

    let studentData = UdacityUser.oneSession

    var resultMapLocations = [[String : AnyObject]]()
    var studentInformationCollection = [StudentInformation]()

    /* Literals needed to get the parse map locations */
    let baseParseURLSecureStringLit = "https://api.parse.com/1/classes/StudentLocation"
 
    /* Literals for thr header field */
    let XParseApplicationIdVal = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let XParseApplicationIdLit = "X-Parse-Application-Id"
    let XParseRESTAPIKeyVal = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    let XParseRESTAPIKeyLit = "X-Parse-REST-API-Key"
    
    
    /*  Functions to work with parse data  */
    
    // Post an entry into the Parse map locarions database
    func postLocation(cords: CLLocationCoordinate2D, address: String, linkText: String, completionHandler: (success: Bool, errorString: String) -> Void){

        // prepare the data
        let lat: Double = cords.latitude
        let longi : Double = cords.longitude

        // Prepare the request
        let request = NSMutableURLRequest(URL: NSURL(string: baseParseURLSecureStringLit)!)
        request.addValue(XParseApplicationIdVal, forHTTPHeaderField: XParseApplicationIdLit)
        request.addValue(XParseRESTAPIKeyVal, forHTTPHeaderField: XParseRESTAPIKeyLit)

        // Additional step because it is a post method
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"menashehertz@gmail.com\", \"firstName\": \"\(studentData.firstName)\", \"lastName\": \"\(studentData.lastName)\",\"mapString\": \"\(address)\", \"mediaURL\": \"\(linkText)\" ,\"latitude\": \(cords.latitude as Double), \"longitude\": \(cords.longitude as Double) }".dataUsingEncoding(NSUTF8StringEncoding)
        //request.HTTPBody = "{\"uniqueKey\": \"menashehertz@gmail.com\", \"firstName\": \"Sam\", \"lastName\": \"Ashe2\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": \(lat), \"longitude\": -122.083851}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                print("it was an error")
                completionHandler(success: false, errorString: "There was an error posting the location")
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            completionHandler(success: true, errorString: "No error")

        }
        task.resume()
    }
    
    //  Get all map Locations from the Parse database
    func getAllMapLocationsNew(completionHandler: (success: Bool, errorString: String) -> Void)  {
        
        // Prepare the request
        let request = NSMutableURLRequest(URL: NSURL(string: baseParseURLSecureStringLit)!)
        request.addValue(XParseApplicationIdVal, forHTTPHeaderField: XParseApplicationIdLit)
        request.addValue(XParseRESTAPIKeyVal, forHTTPHeaderField: XParseRESTAPIKeyLit)
        let session = NSURLSession.sharedSession()
        
        // Do the request
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, errorString: "Error getting Parse data")
            } else {
                var parsingError: NSError? = nil
                let parsedResult = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                if parsingError != nil {
                    completionHandler(success: false, errorString: "did not parse the json" )
                } else {
                    // TODO: - The whole dictionary is being saved, should it be split up now? put in error processing with completion handler
                    if let dict = parsedResult["results"] as? [NSDictionary] {
                        self.resultMapLocations = dict as! [[String : AnyObject]]
                        // let xx : String
                        for dictEach in dict {
                            if let lastName = dictEach.objectForKey("lastName") as? String {
                            }
                        }
                        completionHandler(success: true, errorString: "No Error From the Load")
                    }
                }
                //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
        }
        task.resume()
    }
    
    // takes a text location and converts it to a geoLocation
    func convertAddressToMapLocation(addressText: String, completionHandler: (success: Bool, errorString: String, locationCoord: CLLocationCoordinate2D?) -> Void ) {
        let destination = addressText
        CLGeocoder().geocodeAddressString(destination, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) in
            if error != nil{
                completionHandler(success: false, errorString: "need to convert error", locationCoord: nil)
                print("error")
                /* Handle the error here perhaps by displaying an alert */
            } else {
                /* Convert the CoreLocation destination placemark to a MapKit placemark */
                
                let placemark = placemarks![0] as! CLPlacemark
                
                completionHandler(success: true, errorString: "No Error", locationCoord: placemark.location!.coordinate)
            }
        })
    }

    // take the dictionary and load it into array of StudentInfo structs
    func loadUpStudentInformationFromDict(studentInfoDict:[[String : AnyObject]]) {
        for dictRow in studentInfoDict {
            let xx = dictRow["lastName"] as! String
            let myStudentInformation = StudentInformation(mapDict: dictRow)
            studentInformationCollection.append(myStudentInformation)
        }
        
        studentInformationCollection.sortInPlace { $0.updatedAt > $1.updatedAt }

//        studentInformationCollection.sort {
//            item1, item2 in
//            let date1 = item1.createdAt as String
//            let date2 = item2.createdAt as String
//            return date1 > date2
//        }
    }
}



