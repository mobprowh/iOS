//
//  ViewController.swift
//  Ball
//
//  Created by Kim Topley on 11/20/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    private static let updateInterval = 1.0/60.0
    private let motionManager = CMMotionManager()
    private let queue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        motionManager.startDeviceMotionUpdatesToQueue(queue) {
                (motionData: CMDeviceMotion?, error: NSError?) -> Void in
            let ballView = self.view as! BallView
            ballView.acceleration = motionData!.gravity
            dispatch_async(dispatch_get_main_queue()) {
                ballView.update()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

