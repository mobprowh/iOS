//
//  SecondViewController.swift
//  Bridge Control
//
//  Created by Kim Topley on 10/18/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet var engineSwitch:UISwitch!
    @IBOutlet var warpFactorSlider:UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func applicationWillEnterForeground(_ notification:Notification) {
        let defaults = UserDefaults.standard
        defaults.synchronize()
        refreshFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEngineSwitchTapped(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(engineSwitch.isOn, forKey: warpDriveKey)
        defaults.synchronize()
    }
    
    @IBAction func onWarpSliderDragged(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(warpFactorSlider.value, forKey: warpFactorKey)
        defaults.synchronize()
    }
    
    @IBAction func onSettingsButtonTapped(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshFields()
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self,
                selector: #selector(UIApplicationDelegate.applicationWillEnterForeground(_:)),
                name: NSNotification.Name.UIApplicationWillEnterForeground,
                object: app)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
   
    func refreshFields() {
        let defaults = UserDefaults.standard
        engineSwitch.isOn = defaults.bool(forKey: warpDriveKey)
        warpFactorSlider.value = defaults.float(forKey: warpFactorKey)
    }
}

