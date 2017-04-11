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
        
        for var touchCount = 1; touchCount <= 5; touchCount++ {
            let vertical = UISwipeGestureRecognizer(target: self, action: "reportVerticalSwipe:")
            vertical.direction = [.Up, .Down]
            vertical.numberOfTouchesRequired = touchCount
            view.addGestureRecognizer(vertical)
        
            let horizontal = UISwipeGestureRecognizer(target: self, action: "reportHorizontalSwipe:")
            horizontal.direction = [.Left, .Right]
            horizontal.numberOfTouchesRequired = touchCount
            view.addGestureRecognizer(horizontal)
        }
    }
    
    func descriptionForTouchCount(touchCount:Int) -> String {
        switch touchCount {
        case 1:
            return "Single"
        case 2:
            return "Double"
        case 3:
            return "Triple"
        case 4:
            return "Quadruple"
        case 5:
            return "Quintuple"
        default:
            return ""
        }
    }
    
    func reportHorizontalSwipe(recognizer:UIGestureRecognizer) {
        label.text = "Horizontal swipe detected"
        let count = descriptionForTouchCount(recognizer.numberOfTouches())
        label.text = "\(count)-finger horizontal swipe detected"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)),
                            dispatch_get_main_queue()) {
            self.label.text = ""
        }
    }

    func reportVerticalSwipe(recognizer:UIGestureRecognizer) {
        label.text = "Vertical swipe detected"
        let count = descriptionForTouchCount(recognizer.numberOfTouches())
        label.text = "\(count)-finger vertical swipe detected"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)),
            dispatch_get_main_queue()) {
            self.label.text = ""
        }
    }
}

