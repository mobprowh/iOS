//
//  BA_WebContainerViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 04/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

class BA_WebContainerViewController: UIViewController, BA_FakeTabBarViewDelegate {
	
	@IBOutlet var webContainerView: UIView!
	@IBOutlet var currentTabBar: BA_FakeTabBarView!
	@IBOutlet var currentTabBarBottomConstraints: NSLayoutConstraint!
	
    
	private var containerViewController: BA_WebViewController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userStateChanged(notification:)), name: NSNotification.Name(rawValue: "UserStateChanged"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		currentTabBar.delegate = self
        
        if let loginData = BA_AppDelegate.Ba_LoginData {
            if loginData.IsDeviceLogin {
                currentTabBar.setupLoggedIn()
            }
        }
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		
		self.containerViewController?.willMove(toParentViewController: nil)
		self.containerViewController?.removeFromParentViewController()
		self.containerViewController?.view.removeFromSuperview()
		self.containerViewController = nil
		currentTabBar.delegate = nil
		
		super.viewDidDisappear(animated)
	}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - notification
    func userStateChanged(notification: Notification) {
        if let loginData = BA_AppDelegate.Ba_LoginData {
            if loginData.IsDeviceLogin {
                currentTabBar.setupLoggedIn()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	func embedWebview(webViewRef: BA_WebViewController, url: String, displayTabBar: Bool) {
		
		if(self.isViewLoaded) {
			
			self.showHideTabBar(show: displayTabBar)
			webViewRef.willMove(toParentViewController: self)
			self.webContainerView.addSubview(webViewRef.view)
			self.addChildViewController(webViewRef)
			webViewRef.didMove(toParentViewController: self)
		
			// keep reference of viewController which may be useful when you need to remove it from container view, lets consider you have a property name as containerViewController
			self.containerViewController = webViewRef
			webViewRef.view.frame = self.view.frame
			webViewRef.view.layoutIfNeeded()
			loadUrl(url: url)
		}else{
			
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(25), execute: {
				
				self.embedWebview(webViewRef: webViewRef, url: url, displayTabBar: displayTabBar)
			})
		}
	}
	
	private func showHideTabBar(show: Bool) {
		
		
		if(show) {
			
			if(currentTabBarBottomConstraints.constant != 0) {
				
				currentTabBarBottomConstraints.constant = 0
				self.webContainerView.layoutIfNeeded()
			}
		}else{
			
			let tabBarHeight = self.currentTabBar.frame.size.height
			
			if(currentTabBarBottomConstraints.constant != -tabBarHeight) {
				
				currentTabBarBottomConstraints.constant = -tabBarHeight
				self.webContainerView.layoutIfNeeded()
			}
		}
	}
	
	private func loadUrl(url: String) {
		
		guard self.containerViewController != nil else {
			return
		}
		
		self.containerViewController?.loadUrl(url: url)
	}
	
	func fakeTabBarItemSelected(tabBarItemNumber: Int) {
		
		if let navController = self.navigationController as? BA_NavigationController {
			
			navController.popToTabBarViewController(tabBarItem: tabBarItemNumber)
		}
	}
	
	@IBAction func btnBackTapped(_ sender: UIBarButtonItem) {
		
		guard self.containerViewController != nil else {
			return
		}
		
		if(!self.containerViewController!.goBack()) {
			
			let _ = self.navigationController?.popViewController(animated: true)
		}
	}
}
