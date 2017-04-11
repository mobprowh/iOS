//
//  ViewController.swift
//  Swipes
//
//  Created by Kim Topley on 11/14/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var label: UILabel!
    private var gestureStartPoint: CGPoint!
    private static let minimumGestureLength = Float(25.0)
    private static let maximumVariance = Float(5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            gestureStartPoint = touch.locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first, gestureStartPoint = self.gestureStartPoint {
            let currentPosition = touch.locationInView(self.view)
            
            let deltaX = fabsf(Float(gestureStartPoint.x - currentPosition.x))
            let deltaY = fabsf(Float(gestureStartPoint.y - currentPosition.y))
            
            if deltaX >= ViewController.minimumGestureLength
                            && deltaY <= ViewController.maximumVariance {
                label.text = "Horizontal swipe detected"
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)),
                            dispatch_get_main_queue()) {
                    self.label.text = ""
                }
            } else if deltaY >= ViewController.minimumGestureLength
                            && deltaX <= ViewController.maximumVariance {
                label.text = "Vertical swipe detected"
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)),
                            dispatch_get_main_queue()) {
                    self.label.text = ""
                }
            }
        }
    }
}

