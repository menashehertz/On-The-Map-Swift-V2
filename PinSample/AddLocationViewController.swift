//
//  DoubleScreenViewController.swift
//  LearnMap
//
//  Created by Steven Hertz on 8/7/15.
//  Copyright (c) 2015 Steven Hertz. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // TODO:
    /*
    Things still needed to be done:
    - verification that the website entered is not blank and is legitimate
    - process the nserror from converting the location to map coordinates
    - by the animate dim the screen
    */
    
    var coords: CLLocationCoordinate2D!
    let studentData = UdacityUser.oneSession
    

    /* Screen Outlets */
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var screenView1: UIView!
    @IBOutlet weak var screenView2: UIView!
    @IBOutlet weak var linkText: UITextField!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var topThird: UIView!
    

    /* Screen Actions */
    @IBAction func findLocation(sender: AnyObject) {
        /* when I comment out processLocationController() (right below it),  I see the activity indicator animating
        * so I think it is working
        */
        activityInd.startAnimating()
        processLocationController()
    }
    @IBAction func submit(sender: AnyObject) {
        postLocation()
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /* Functions */
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func processLocationController(){
        AllMapLocations.oneSession.convertAddressToMapLocation(address.text!) { (success, errorString, locationCoord) in
            if success {
                self.populateMapWithLocation(locationCoord!)
                self.coords = locationCoord!
                self.moveToSecondScreen()
            } else {
                print("from get location" + errorString)
                self.displayError("Error converting a location to a map coordinate")
            }
        }
        
        activityInd.stopAnimating()
    }
    
    
    // Populates the map with pin spot
    func populateMapWithLocation(coords: CLLocationCoordinate2D) {

        // Setup what is showing in the map
        let span = MKCoordinateSpanMake(0.0002, 0.0002)
        let region = MKCoordinateRegionMake(coords, span)
        map.setRegion(region, animated: true)
        
        // Setup the annotation with location and the title and other info
        let annotation = MKPointAnnotation()
        annotation.coordinate = coords
        annotation.title = studentData.firstName + " " + studentData.lastName
        
        // Add it to the map
        map.addAnnotation(annotation)
    }
    
    
    func postLocation(){
        // Put map location into the parse database
        AllMapLocations.oneSession.postLocation(coords, address: address.text!, linkText: linkText.text!) { (success, errorString) in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayError(errorString)
            }
        }

    }
    
    
    func displayError(errorString: String) {
        print("it is an error " + errorString)
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {(paramAction:UIAlertAction) in print("The Done button was tapped - " + paramAction.title!)})
            
            alertController.addAction(action)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    func moveToSecondScreen() {
        dispatch_async(dispatch_get_main_queue()) {
            self.screenView1.hidden = true
            self.screenView2.hidden = false
        }
    }
    
    func moveToFirstScreen() {
        dispatch_async(dispatch_get_main_queue()) {
            self.screenView1.hidden = false
            self.screenView2.hidden = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityInd.hidesWhenStopped = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
