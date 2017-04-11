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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let vertical = UISwipeGestureRecognizer(target: self, action: "reportVerticalSwipe:")
        vertical.direction = [.Up, .Down]
        view.addGestureRecognizer(vertical)
        
        let horizontal = UISwipeGestureRecognizer(target: self, action: "reportHorizontalSwipe:")
        horizontal.direction = [.Left, .Right]
        view.addGestureRecognizer(horizontal)
    }
    
    func reportHorizontalSwipe(recognizer:UIGestureRecognizer) {
        label.text = "Horizontal swipe detected"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)),
                            dispatch_get_main_queue()) {
            self.label.text = ""
        }
    }

    func reportVerticalSwipe(recognizer:UIGestureRecognizer) {
        label.text = "Vertical swipe detected"
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)),
            dispatch_get_main_queue()) {
            self.label.text = ""
        }
    }
}

