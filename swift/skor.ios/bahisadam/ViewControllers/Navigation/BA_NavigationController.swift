//
//  BA_NavigationController.swift
//  bahisadam
//
//  Created by ilker özcan on 23/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import MBProgressHUD
import BahisadamLive

public class BA_NavigationController: UINavigationController, BA_MatchDetailContainerDelegate {


	private var currentLoadedWebView: BA_WebViewController?
	private var lastWebviewUrl: String?
	
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.currentLoadedWebView = self.storyboard?.instantiateViewController(withIdentifier: "BA_WebViewController") as? BA_WebViewController
		
		if(self.currentLoadedWebView != nil) {
			
			self.currentLoadedWebView!.loadWebview()
		}
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override public func viewWillAppear(_ animated: Bool) {
		
		NotificationCenter.default.addObserver(self, selector: #selector(openRootViewController(sender:)), name: BA_AppConstants.OpenRootVCNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(openWebVCFromWidget(sender:)), name: BA_AppConstants.OpenWebVCNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMatch(notification:)), name: BA_AppConstants.OpenMatchNotification, object: nil)
        
		super.viewWillAppear(animated)
        
	}
	
	override public func viewWillDisappear(_ animated: Bool) {
		
		NotificationCenter.default.removeObserver(self, name: BA_AppConstants.OpenRootVCNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: BA_AppConstants.OpenWebVCNotification, object: nil)
		super.viewWillDisappear(animated)
	}
	
	override public func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
		
		#if !DISABLE_TUTORIAL
		if(!UserDefaults.standard.bool(forKey: "com.bahisadam.bahisadam.tutorialViewDisplayed")) {
			
			let tutorialStoryboard = UIStoryboard(name: "BA_TutorialView", bundle: nil)
			if let tutorialViewController = tutorialStoryboard.instantiateViewController(withIdentifier: "BA_tutorialViewController") as? BA_TutorialViewController {
				
				UserDefaults.standard.set(true, forKey: "com.bahisadam.bahisadam.tutorialViewDisplayed")
				let _ = UserDefaults.standard.synchronize()
				tutorialViewController.currentStoryboard = tutorialStoryboard
				tutorialViewController.navigationView = self.view
				tutorialViewController.BA_presentTutorialViewController(viewControllerToPresent: tutorialViewController, navigationViewController: self)
				
			}
		}
		#endif
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
	*/
	
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		
		if let segueId = segue.identifier {
			
			if(segueId == "showWebviewVC" && self.currentLoadedWebView != nil) {
				
				if let webViewVC = segue.destination as? BA_WebContainerViewController {
					
					webViewVC.embedWebview(webViewRef: self.currentLoadedWebView!, url: self.lastWebviewUrl!, displayTabBar: true)
				}
			}
		}
    }
	
	func popToTabBarViewController(tabBarItem: Int) {
		
		let _ = self.popViewController(animated: false)
		
		if let tabBarVC = self.viewControllers[0] as? BA_TabBarViewController {
			
			tabBarVC.selectedIndex = tabBarItem
		}
	}

	func openWebView(withUrl url: String) {
		
		self.lastWebviewUrl = url
		self.performSegue(withIdentifier: "showWebviewVC", sender: self)
	}
	
	func getLoadedWebview() -> BA_WebViewController? {
		
		return self.currentLoadedWebView
	}
	
	func openRootViewController(sender: NSNotification?) {
		
		if let senderData = sender {
			
			if let userInfo = senderData.userInfo {
				
				if let tabItem = userInfo["selectedTab"] as? Int {
					
					self.popToTabBarViewController(tabBarItem: tabItem)
				}
			}
		}
	}
	
	// TODO: Update this
	func openWebVCFromWidget(sender: NSNotification?) {
		
		if let senderData = sender {
			
			if let userInfo = senderData.userInfo {
				
				let matchYear = userInfo["matchYear"] as! Int
				let matchId = userInfo["matchId"] as! String
				let urlString = String(format: BA_Server.MatchApi, matchYear, matchId)
				openWebView(withUrl: urlString)
			}
		}
	}
    
    func openMatch(notification: Notification) {
        if let userInfo = notification.userInfo {
            
            let matchId = userInfo["matchId"] as! String
            var type = BA_MatchDetailesPresentationType.stats
            
            if let typeString = userInfo["type"] as? String, typeString == "lineup" {
                type = .lineup
            }
            
            openMatchDetailIndex(matchId, presentationType: type)
        }
    }
	
	func openMatchDetailIndex(_ matchId: String, presentationType: BA_MatchDetailesPresentationType) {
		
		let matchDetailStoryboard = UIStoryboard(name: "BA_MatchDetail", bundle: nil)
		if let matchDetailVC = matchDetailStoryboard.instantiateViewController(withIdentifier: "BA_MatchDetailContainerViewController") as? BA_MatchDetailContainerViewController {
			
			matchDetailVC.delegate = self
			matchDetailVC.matchId = matchId
            matchDetailVC.presentationType = presentationType

			self.IO_presentViewControllerWithCustomAnimation(matchDetailVC)
		}
	}
	
	func BA_MatchDetailDismiss(tabBarItemNumber: Int) {
		
		if let tabBarVC = self.viewControllers[0] as? BA_TabBarViewController {
			
			tabBarVC.selectedIndex = tabBarItemNumber
		}
	}
	
	// TODO: will be deleted
	func BA_MatchDetailDismiss(withUrl: String) {
		
		self.openWebView(withUrl: withUrl)
	}
}
