//
//  ViewController.swift
//  TouchExplorer
//
//  Created by Kim Topley on 11/11/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tapsLabel: UILabel!
    @IBOutlet var touchesLabel: UILabel!
    @IBOutlet var forceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    private func updateLabelsFromTouches(touch: UITouch?, allTouches: Set<UITouch>?) {
        let numTaps = touch?.tapCount ?? 0
        let tapsMessage = "\(numTaps) taps detected"
        tapsLabel.text = tapsMessage
        
        let numTouches = allTouches?.count ?? 0
        let touchMsg = "\(numTouches) touches detected"
        touchesLabel.text = touchMsg
        
        if traitCollection.forceTouchCapability == .Available {
            forceLabel.text = "Force: \(touch?.force ?? 0)\nMax force: \(touch?.maximumPossibleForce ?? 0)"
        } else {
            forceLabel.text = "3D Touch not available"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        messageLabel.text = "Touches Began"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches())
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        messageLabel.text = "Touches Cancelled"
        updateLabelsFromTouches(touches?.first, allTouches: event?.allTouches())
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        messageLabel.text = "Touches Ended"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches())
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        messageLabel.text = "Drag Detected"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches())
    }
}

