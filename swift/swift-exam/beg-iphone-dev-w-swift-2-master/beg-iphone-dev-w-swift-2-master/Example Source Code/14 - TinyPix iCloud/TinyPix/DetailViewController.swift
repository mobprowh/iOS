//
//  DetailViewController.swift
//  TinyPix
//
//  Created by Kim Topley on 10/28/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var pixView: TinyPixView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if detailItem != nil && isViewLoaded() {
            pixView.document = detailItem! as! TinyPixDocument
            pixView.setNeedsDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        updateTintColor()
        NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "onSettingsChanged:",
                name: NSUserDefaultsDidChangeNotification , object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let doc = detailItem as? UIDocument {
            doc.closeWithCompletionHandler(nil)
        }
    }
    
    private func updateTintColor() {
        let prefs = NSUserDefaults.standardUserDefaults()
        let selectedColorIndex = prefs.integerForKey("selectedColorIndex")
        let tintColor = TinyPixUtils.getTintColorForIndex(selectedColorIndex)
        pixView.tintColor = tintColor
        pixView.setNeedsDisplay()
    }

    func onSettingsChanged(notification: NSNotification) {
        updateTintColor()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self,
                    name: NSUserDefaultsDidChangeNotification, object: nil)
    }

}

