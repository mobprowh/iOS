//
//  BA_ProgressHudView.swift
//  bahisadam
//
//  Created by ilker özcan on 11/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_ProgressHudView: UIView {

	private static let hudViewWidth: CGFloat = 384
	private static let hudViewHeight: CGFloat = 216
	
	@IBOutlet var indicator: UIActivityIndicatorView!
	
	private static var huds = [BA_ProgressHudView]()
	
	/*
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
	// Drawing code
	}
	*/

	func startAnimating() {
		
		indicator.startAnimating()
	}
	
	class func ShowHud(forView: UIView) {
		
		
		if let nibViews = Bundle.main.loadNibNamed("BA_ProgressHudView", owner: nil, options: nil) {
			
			var hudVC: BA_ProgressHudView?
			for hudView in nibViews {
				
				if let baProgressHudView = hudView as? BA_ProgressHudView {
					
					hudVC = baProgressHudView
					break
				}
			}
			
			guard hudVC != nil else {
				return
			}
			
			let hudXPos = (forView.frame.size.width / 2.0) - (BA_ProgressHudView.hudViewWidth / 2)
			let hudYPos = (forView.frame.size.height / 2.0) - (BA_ProgressHudView.hudViewHeight / 2)
			hudVC!.frame = CGRect(x: hudXPos, y: hudYPos, width: hudViewWidth, height: hudViewHeight)
			
			UIApplication.shared.beginIgnoringInteractionEvents()
			BA_ProgressHudView.huds.append(hudVC!)
			
			forView.addSubview(hudVC!)
			hudVC!.startAnimating()
		}
	}
	
	class func removeAllHuds() {
		
		for hud in BA_ProgressHudView.huds {
			
			hud.removeFromSuperview()
		}
		
		BA_ProgressHudView.huds.removeAll()
		UIApplication.shared.endIgnoringInteractionEvents()
	}
	
}
