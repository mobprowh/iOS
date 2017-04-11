//
//  ViewController.swift
//  Persistence
//
//  Created by Kim Topley on 10/24/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var lineFields:[UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileURL = self.dataFileURL()
        if (FileManager.default.fileExists(atPath: fileURL.path)) {
            if let array = NSArray(contentsOf: fileURL) as? [String] {
                for i in 0 ..< array.count {
                    lineFields[i].text = array[i]
                }
            }
        }
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self,
            selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)),
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: app)
    }
    
    func applicationWillResignActive(_ notification:Notification) {
        let fileURL = self.dataFileURL()
        let array = (self.lineFields as NSArray).value(forKey: "text") as! NSArray
        array.write(to: fileURL, atomically: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dataFileURL() -> URL {
        let urls = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        return urls.first!.appendingPathComponent("data.plist")
    }
}

