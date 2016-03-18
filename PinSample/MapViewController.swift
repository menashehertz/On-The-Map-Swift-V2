//
//  ViewController.swift
//  PinSample
//
//  Created by Jason on 3/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import MapKit

/**
* Put the student locations on the map
* 
*/

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var annotations = [MKPointAnnotation]()
    var myLogin = UdacityLogin.oneSession
    var myHelpers = Helpers()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // programaticly put title and buttons on the nav bar
        myHelpers.loadNavBar(self.storyboard!, myViewController: self)
        // loadNavBar()
        
        // take dictionary array and make an array of studentInformation structs
        if AllMapLocations.oneSession.studentInformationCollection.isEmpty {
            AllMapLocations.oneSession.loadUpStudentInformationFromDict(AllMapLocations.oneSession.resultMapLocations)
        }

        // process the studentInformation structs array into points on map
        loadLocations()
    }
    
    
    func loadLocations() {
        
        let studentLocations = AllMapLocations.oneSession.studentInformationCollection
        
        for studentLocation in studentLocations {
            
            let lat = CLLocationDegrees(studentLocation.latitude as Double)
            let long = CLLocationDegrees(studentLocation.longitude as Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = studentLocation.firstName as String
            let last = studentLocation.lastName as String
            let mediaURL = studentLocation.mediaURL as String
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
            // println("adding annotations")
        }
        // When the array is complete, we add the annotations to the map.
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    
    
    
    // MARK: - * * * *  MKMapViewDelegate
    
    
    // Setup the pins on the map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // Responds to taps. It opens the system browser to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
        }
    }
    
    func displayError(errorString: String?) {
        if let errorString = errorString {
            dispatch_async(dispatch_get_main_queue()) {
                let alertController = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
                let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {(paramAction:UIAlertAction) in print("The Done button was tapped - " + paramAction.title!)})
                
                alertController.addAction(action)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }

    
    // MARK: - * * * *   Helper Functions

    func performLeave() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func performAdd(){
        //    dispatch_async(dispatch_get_main_queue()) {
        //      self.mapView.addAnnotations(self.annotations)
        //    }
        //
        //    return
        print("Add new method got called")
        myHelpers.performGo(self.storyboard!, viewController: self)
        
        
        //  var vc: UIViewController = storyboard?.instantiateViewControllerWithIdentifier("doublescreen") as! DoubleScreenViewController
        //  self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func performRefresh(){
        print("Refresh new method got called")

        AllMapLocations.oneSession.getAllMapLocationsNew()  { (success, errorString) in
            if success {
                AllMapLocations.oneSession.loadUpStudentInformationFromDict(AllMapLocations.oneSession.resultMapLocations)
                AllMapLocations.oneSession.studentInformationCollection.removeAll(keepCapacity: false)
                self.mapView.removeAnnotations(self.annotations)
                self.loadLocations()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    
}
