//
//  ViewController.swift
//  Control Fun
//
//  Created by Kim Topley on 8/17/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var leftSwitch: UISwitch!
    @IBOutlet weak var rightSwitch: UISwitch!
    @IBOutlet weak var doSomethingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderLabel.text = "50"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapGestureRecognized(sender: AnyObject) {
        nameField.resignFirstResponder()
        numberField.resignFirstResponder()
    }
    
    @IBAction func onSliderChanged(sender: UISlider) {
        sliderLabel.text = "\(lroundf(sender.value))"
    }

    @IBAction func onSwitchChanged(sender: UISwitch) {
        let setting = sender.on
        leftSwitch.setOn(setting, animated: true)
        rightSwitch.setOn(setting, animated: true)
    }

    @IBAction func toggleControls(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { // "Switches" is selected
            leftSwitch.hidden = false
            rightSwitch.hidden = false
            doSomethingButton.hidden = true
        } else {
            leftSwitch.hidden = true
            rightSwitch.hidden = true
            doSomethingButton.hidden = false
        }
    }
    
    @IBAction func onButtonPressed(sender: UIButton) {
        let controller = UIAlertController(title: "Are You Sure?",
            message:nil, preferredStyle: .ActionSheet)
        
        let yesAction = UIAlertAction(title: "Yes, I'm sure!",
                        style: .Destructive, handler: { action in
            let msg = self.nameField.text!.isEmpty
                        ? "You can breathe easy, everything went OK."
                        : "You can breathe easy, \(self.nameField.text),"
                            + " everything went OK."
            let controller2 = UIAlertController(
                                title:"Something Was Done",
                                message: msg, preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Phew!",
                                style: .Cancel, handler: nil)
                                controller2.addAction(cancelAction)
            self.presentViewController(controller2, animated: true,
                                       completion: nil)
            })
        
        let noAction = UIAlertAction(title: "No way!",
            style: .Cancel, handler: nil)
        
        controller.addAction(yesAction)
        controller.addAction(noAction)
        
        if let ppc = controller.popoverPresentationController {
            ppc.sourceView = sender
            ppc.sourceRect = sender.bounds
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
}

