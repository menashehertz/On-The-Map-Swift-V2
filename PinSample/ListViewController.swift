//
//  ListViewController.swift
//  PinSample
//
//  Created by Steven Hertz on 7/31/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

  @IBOutlet weak var passedLabel: UILabel!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .Add,
        target: self,
        action: "performAdd:")


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
