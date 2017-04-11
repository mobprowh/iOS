//
//  DetailViewController.swift
//  TinyPix
//
//  Created by andrey on 2/19/17.
//  Copyright © 2017 andrey. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var pixView: TinyPixView!


    func configureView() {
        /*/ Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
 */
        
        if detailItem != nil && isViewLoaded {
            pixView.document = detailItem! as! TinyPixDocument
            pixView.setNeedsDisplay()
        }
    }
    
    private func updateTintColor() {
        let prefs = UserDefaults.standard
        let selectedColorIndex = prefs.integer(forKey: "selectedColorIndex")
        let tintColor = TinyPixUtils.getTintColorForIndex(index: selectedColorIndex)
        pixView.tintColor = tintColor
        pixView.setNeedsDisplay()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        updateTintColor()
        NotificationCenter.default.addObserver(self,
                                               selector: Selector(("onSettingsChanged:")),
                                               name: UserDefaults.didChangeNotification , object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let doc = detailItem as? UIDocument {
            doc.close(completionHandler: nil)
        }
    }
    
    func onSettingsChanged(notification: NSNotification) {
        updateTintColor()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

