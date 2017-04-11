//
//  ViewController.swift
//  Button Fun
//
//  Created by Kim Topley on 8/15/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func buttonPressed(sender: UIButton) {
        let title = sender.titleForState(.Normal)!
        let text = "\(title) button pressed"
        let styledText = NSMutableAttributedString(string: text)
        let attributes = [
            NSFontAttributeName:
            UIFont.boldSystemFontOfSize(statusLabel.font.pointSize)
        ]
        let nameRange = (text as NSString).rangeOfString(title)
        styledText.setAttributes(attributes, range: nameRange)
        
        statusLabel.attributedText = styledText
    }
}

