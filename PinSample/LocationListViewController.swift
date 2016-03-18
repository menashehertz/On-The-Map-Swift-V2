//
//  LocationListViewController.swift
//  PinSample
//
//  Created by Steven Hertz on 8/2/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class LocationListViewController: UITableViewController {
    
    var myHelpers = Helpers()
    var myLogin = UdacityLogin.oneSession
    
    // let locations = AllMapLocations.oneSession.resultMapLocations
    let locations = AllMapLocations.oneSession.studentInformationCollection
    
    
    @IBOutlet var studentList: UITableView!
    
    func performAdd(sender: UIBarButtonItem){
        print("Add method got called")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // programaticly put title and buttons on the nav bar
        myHelpers.loadNavBar(self.storyboard!, myViewController: self)
        
        // take dictionary array and make an array of studentInformation structs
        if AllMapLocations.oneSession.studentInformationCollection.isEmpty {
            AllMapLocations.oneSession.loadUpStudentInformationFromDict(AllMapLocations.oneSession.resultMapLocations)
        }        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllMapLocations.oneSession.resultMapLocations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) 
        let studentInfo = AllMapLocations.oneSession.studentInformationCollection[indexPath.row]
        cell.textLabel?.text = "\(studentInfo.firstName) \(studentInfo.lastName)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentInfo = AllMapLocations.oneSession.studentInformationCollection[indexPath.row]
        // let myMapLocation = MapLocation(mapDict: dictRow as [String : AnyObject])
        UIApplication.sharedApplication().openURL(NSURL(string: studentInfo.mediaURL)!)
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

    func performLeave() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func performAdd(){
        myHelpers.performGo(self.storyboard!, viewController: self)
    }
    
    func performRefresh(){
        print("Refresh new method got called")

        AllMapLocations.oneSession.getAllMapLocationsNew()  { (success, errorString) in
            if success {
                AllMapLocations.oneSession.studentInformationCollection.removeAll(keepCapacity: false)
                AllMapLocations.oneSession.loadUpStudentInformationFromDict(AllMapLocations.oneSession.resultMapLocations)
                self.studentList.reloadData()
            } else {
               self.displayError(errorString)
            }
        }
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
