//
//  BA_StatsCollectionReusableView.swift
//  bahisadam
//
//  Created by ilker özcan on 03/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_StatsCollectionReusableView: UICollectionReusableView {
	
	@IBOutlet var sectionContentView: UIView!
	//@IBOutlet var countryNameLabel: UILabel!
	@IBOutlet var countryNameButton: UIButton!
	@IBOutlet var countryImage: UIImageView!
	
	private var countryId: Int = 0
	private var delegate: BA_StatsDelegate?
	
	func setupHeader(countryName: String, countryCode: String, countryId: Int, delegate: BA_StatsDelegate?) {
		
		//self.countryNameLabel.text = countryName
		self.countryNameButton.setTitle(countryName, for: UIControlState.normal)
		self.countryImage.image = nil
		self.countryId = countryId
		self.delegate = delegate
		
		let countryFlagName = "BA_" + countryCode.lowercased()
		self.countryImage.image = UIImage(named: countryFlagName)
	}
	
	func setupMask() {
		
		self.layoutIfNeeded()
		let path = UIBezierPath(roundedRect:(self.sectionContentView.bounds),
		                        byRoundingCorners:[.topRight, .topLeft],
		                        cornerRadii: CGSize(width: 8, height:  8))
		
		let maskLayer = CAShapeLayer()
		
		maskLayer.path = path.cgPath
		self.sectionContentView.layer.mask = maskLayer
	}
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	@IBAction func btnExpandCountryTapped(sender: UIButton) {
		
		if(self.delegate != nil) {
			self.delegate?.expandCountry(countryId: self.countryId)
		}
	}
	
}
