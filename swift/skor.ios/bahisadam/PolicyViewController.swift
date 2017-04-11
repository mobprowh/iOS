//
//  PolicyViewController.swift
//  bahisadam
//
//  Created by anton on 3/10/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

class PolicyViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let policyURL = URL(string: BA_Server.PrivacyPolicy)
        let policyURLRequest = URLRequest(url: policyURL!)
        webView.loadRequest(policyURLRequest)
        
        //Navigation
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
