//
//  ViewController.swift
//  StackViews
//
//  Created by Kim Topley on 9/27/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    private static let imageCount = 6;
    private var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        showImage(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showImage(index: Int) {
        label.text = "Image \(index)"
        imageView.image = UIImage(named: "image\(index)")
    }

    @IBAction func onNextButtonPressed(sender: AnyObject) {
        index = (index + 1) % ViewController.imageCount
        showImage(index)
    }
    
    @IBAction func onPreviousButtonPressed(sender: AnyObject) {
        index = index == 0 ? ViewController.imageCount - 1 : --index
        showImage(index)
    }
    
    @IBAction func onResetButtonPressed(sender: AnyObject) {
        showImage(0)
    }
}

