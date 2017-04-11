//
//  BA_StatsViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 04/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

class BA_StatsViewController: UIViewController {
	
	private let detailPageApi = BA_Server.StatsDetail
	
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		
		self.tabBarController?.navigationItem.title = "İstatistikler"
		super.viewWillAppear(animated)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
	*/

	func openWebView(leagueId: Int) {
		
		if let baNavController =  self.tabBarController?.navigationController as? BA_NavigationController {
			
			let leagueDetailUrl = String(format: detailPageApi, leagueId)
			baNavController.openWebView(withUrl: leagueDetailUrl)
		}
	}
}
