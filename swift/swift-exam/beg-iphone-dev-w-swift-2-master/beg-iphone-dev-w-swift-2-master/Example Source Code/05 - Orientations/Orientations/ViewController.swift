//
//  ViewController.swift
//  Orientations
//
//  Created by Kim Topley on 9/1/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: (UIInterfaceOrientationMask.Portrait.rawValue
                             | UIInterfaceOrientationMask.LandscapeLeft.rawValue))
    }
}

