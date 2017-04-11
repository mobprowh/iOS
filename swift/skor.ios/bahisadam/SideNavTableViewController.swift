//
//  SideNavTableViewController.swift
//  bahisadam
//
//  Created by anton on 3/9/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import UIKit

class SideNavTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if let segueId = segue.identifier {
            
            if (segueId == "sg_ba_news_popup") {
                
                if let popoverViewController = segue.destination as? BA_NewsViewTableViewController {
                    
                    popoverViewController.modalPresentationStyle = .popover
                    popoverViewController.popoverPresentationController!.delegate = self
                    
                }
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    

}
