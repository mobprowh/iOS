//
//  BA_LiveHeaderCollectionReusableView.swift
//  bahisadam
//
//  Created by ilker özcan on 12/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import TVBahisadamLive

class BA_LiveHeaderCollectionReusableView: UICollectionReusableView {
	
	@IBOutlet var sectionContentView: UIView!
	@IBOutlet var leagueNameLabel: UILabel!
	@IBOutlet var leagueImage: UIImageView!
	
	var leagueNameVal: String = ""
	var leagueImageVal: String = ""
	
	func setupHeader(leagueName: String, leagueImageURL: String) {
		
		self.leagueNameVal = leagueName
		self.leagueImageVal = leagueImageURL
		self.leagueNameLabel.text = leagueName
		UIImage.getWebImage(imageUrl: self.leagueImageVal) { (responseImage) in
			
			self.leagueImage.image = responseImage
		}
	}
	
	func setupBorderMask() {
		
		self.layoutIfNeeded()
		let path = UIBezierPath(roundedRect:self.sectionContentView.bounds,
		                        byRoundingCorners:[.topLeft, .topRight],
		                        cornerRadii: CGSize(width: 16, height:  16))
		
		let maskLayer = CAShapeLayer()
		
		maskLayer.path = path.cgPath
		self.sectionContentView.layer.mask = maskLayer
	}
}
