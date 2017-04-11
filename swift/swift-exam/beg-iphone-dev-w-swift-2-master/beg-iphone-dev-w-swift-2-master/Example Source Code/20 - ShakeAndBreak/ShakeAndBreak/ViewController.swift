//
//  ViewController.swift
//  ShakeAndBreak
//
//  Created by Kim Topley on 11/20/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    private var fixed: UIImage!
    private var broken: UIImage!
    private var brokenScreenShowing = false
    private var crashPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let url = NSBundle.mainBundle().URLForResource("glass", withExtension:"wav") {
            do {
                crashPlayer = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: AVFileTypeWAVE)
            } catch let error as NSError {
                print("Audio error! \(error.localizedDescription)")
            }
        }
        
        fixed = UIImage(named: "Home")
        broken = UIImage(named: "HomeBroken")
        imageView.image = fixed
    }

    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if !brokenScreenShowing && motion == .MotionShake {
            imageView.image = broken;
            crashPlayer?.play()
            brokenScreenShowing = true;
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        imageView.image = fixed
        brokenScreenShowing = false
    }

}

