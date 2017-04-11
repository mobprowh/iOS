//
//  ViewController.swift
//  Taps
//
//  Created by Kim Topley on 11/15/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var singleLabel:UILabel!
    @IBOutlet var doubleLabel:UILabel!
    @IBOutlet var tripleLabel:UILabel!
    @IBOutlet var quadrupleLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let singleTap = UITapGestureRecognizer(target: self, action: "singleTap")
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: "doubleTap")
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(doubleTap)
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: "tripleTap")
        tripleTap.numberOfTapsRequired = 3
        tripleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tripleTap)
        doubleTap.requireGestureRecognizerToFail(tripleTap)
        
        let quadrupleTap = UITapGestureRecognizer(target: self, action: "quadrupleTap")
        quadrupleTap.numberOfTapsRequired = 4
        quadrupleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(quadrupleTap)
        tripleTap.requireGestureRecognizerToFail(quadrupleTap)
       
    }

    func singleTap() {
        showText("Single Tap Detected", inLabel: singleLabel)
    }
    
    func doubleTap() {
        showText("Double Tap Detected", inLabel: doubleLabel)
    }
    
    func tripleTap() {
        showText("Triple Tap Detected", inLabel: tripleLabel)
    }
    
    func quadrupleTap() {
        showText("Quadruple Tap Detected", inLabel: quadrupleLabel)
    }
    
    private func showText(text: String, inLabel label: UILabel) {
        label.text = text
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)),
            dispatch_get_main_queue()) {
                label.text = ""
        }
    }
}

