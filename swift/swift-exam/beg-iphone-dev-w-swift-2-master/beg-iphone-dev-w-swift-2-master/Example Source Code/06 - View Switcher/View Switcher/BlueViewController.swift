//
//  BlueViewController.swift
//  View Switcher
//
//  Created by Kim Topley on 9/5/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class BlueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func blueButtonPressed(sender: UIButton) {
        let alert = UIAlertController(title: "Blue View Button Pressed",
                message: "You pressed the button on the blue view",
                preferredStyle: .Alert)
        let action = UIAlertAction(title: "Yep, I did", style: .Default,
                                   handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
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
