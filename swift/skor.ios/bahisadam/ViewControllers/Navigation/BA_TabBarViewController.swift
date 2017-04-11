//
//  BA_TabBarViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 26/09/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive
import FontAwesome_swift

class BA_TabBarViewController: UITabBarController, UIPopoverPresentationControllerDelegate {

	fileprivate let webviewIdx = 5
	private var currentRegion: String = "tr"
    @IBOutlet weak var menuButton: UIBarButtonItem!
	
    
    //var sidevarIdx = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		if let region = IO_Helpers.deviceLocale {
			
			self.currentRegion = region
			if(self.currentRegion == "az") {
				
				if let currentTabBarLastTabImage = self.tabBar.items?[4] {
					
					currentTabBarLastTabImage.image = UIImage(named: "league_logo_az")
					currentTabBarLastTabImage.selectedImage = UIImage(named: "league_logo_az")
				}
			}
		}
        
        NotificationCenter.default.addObserver(self, selector: #selector(BA_TabBarViewController.userStateChanged(notification:)), name: NSNotification.Name(rawValue: "UserStateChanged"), object: nil)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }

    func userStateChanged(notification: Notification) {
        
        // if device logged in we need to change 4th tab
        
        if (BA_AppDelegate.Ba_LoginData?.IsDeviceLogin)! {
            var tabs = viewControllers
            let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BA_MatchesMainViewController") as! BA_MatchesMainViewController
            controller.favoritesState = true
            tabs?[3] = controller
            viewControllers = tabs
            
            // changing tab bar icon and title
            if let item = tabBar.items?[3] {
                let color = UIColor.init(colorLiteralRed: 50.0/255.0, green: 184.0/255.0, blue: 70.0/255.0, alpha: 1.0)
                item.title = "Favorilerim"
                item.image = UIImage.fontAwesomeIcon(name: FontAwesome.starO, textColor: color, size: CGSize(width: 37, height: 37))
                item.selectedImage = UIImage.fontAwesomeIcon(name: FontAwesome.star, textColor: color, size: CGSize(width: 37, height: 37))
            }
        }
    }

	
    // MARK: - Navigation

	

	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		
		if(item.tag == webviewIdx) {
			
			if let baNavController =  self.navigationController as? BA_NavigationController {
				
				if let loadedWebviewRef = baNavController.getLoadedWebview() {
					
					if let webViewVC = self.viewControllers?.last as? BA_WebContainerViewController {
						
						if(currentRegion == "az") {
							
							webViewVC.embedWebview(webViewRef: loadedWebviewRef, url: BA_Server.PointsApi_AZ, displayTabBar: false)
							self.navigationItem.title = "Azerbeycan Premier Lig"
						}else{
							
							webViewVC.embedWebview(webViewRef: loadedWebviewRef, url: BA_Server.PointsApi, displayTabBar: false)
							self.navigationItem.title = "Türkiye Süper Ligi"
						}
					}
				}
			}
		}
	}
	
	
}
