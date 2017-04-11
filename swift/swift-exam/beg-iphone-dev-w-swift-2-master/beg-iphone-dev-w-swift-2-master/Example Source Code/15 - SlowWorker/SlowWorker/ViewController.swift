//
//  ViewController.swift
//  SlowWorker
//
//  Created by Kim Topley on 10/31/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resultsTextView: UITextView!
    @IBOutlet var spinner : UIActivityIndicatorView!
    
    func fetchSomethingFromServer() -> String {
        NSThread.sleepForTimeInterval(1)
        return "Hi there"
    }
    
    func processData(data: String) -> String {
        NSThread.sleepForTimeInterval(2)
        return data.uppercaseString
    }
    
    func calculateFirstResult(data: String) -> String {
        NSThread.sleepForTimeInterval(3)
        return "Number of chars: \(data.characters.count)"
    }
    
    func calculateSecondResult(data: String) -> String {
        NSThread.sleepForTimeInterval(4)
        return data.stringByReplacingOccurrencesOfString("E", withString: "e")
    }
    
    @IBAction func doWork(sender: AnyObject) {
        let startTime = NSDate()
        self.resultsTextView.text = ""
        startButton.enabled = false
        spinner.startAnimating()
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            let fetchedData = self.fetchSomethingFromServer()
            let processedData = self.processData(fetchedData)
            var firstResult: String!
            var secondResult: String!
            let group = dispatch_group_create()
        
            dispatch_group_async(group, queue) {
                firstResult = self.calculateFirstResult(processedData)
            }
            dispatch_group_async(group, queue) {
                secondResult = self.calculateSecondResult(processedData)
            }
        
            dispatch_group_notify(group, queue) {
                let resultsSummary = "First: [\(firstResult)]\nSecond: [\(secondResult)]"
                dispatch_async(dispatch_get_main_queue()) {
                    self.resultsTextView.text = resultsSummary
                    self.startButton.enabled = true
                    self.spinner.stopAnimating()
                }
                let endTime = NSDate()
                print("Completed in \(endTime.timeIntervalSinceDate(startTime)) seconds")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

