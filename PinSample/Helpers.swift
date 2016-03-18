//
//  Helpers.swift
//  PinSample
//
//  Created by Steven Hertz on 8/6/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit
class Helpers: NSObject {
    func performGo(storyBoard: UIStoryboard, viewController: UIViewController){
        let vc: AddLocationViewController = storyBoard.instantiateViewControllerWithIdentifier("addLocation") as! AddLocationViewController
        viewController.presentViewController(vc, animated: true, completion: nil)
    }
    func addButtons(storyBoard: UIStoryboard, viewController: UIViewController){
        let vc: AddLocationViewController = storyBoard.instantiateViewControllerWithIdentifier("addLocation") as! AddLocationViewController
        viewController.presentViewController(vc, animated: true, completion: nil)
    }
    func loadNavBar(myStoryBoard : UIStoryboard, myViewController : UIViewController)  {
        // do the right buttons
        let firstButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: myViewController, action: "performRefresh")
        let btnImg = UIImage(named: "pin.pdf")
        let secondButton = UIBarButtonItem(image: btnImg, style: .Plain, target: myViewController, action: "performAdd")
        myViewController.navigationItem.rightBarButtonItems = [firstButton, secondButton]
        // do the left button
        myViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: myViewController, action: "performLeave")
        // do the title
        myViewController.navigationItem.title = "On the Map"
    }
}

