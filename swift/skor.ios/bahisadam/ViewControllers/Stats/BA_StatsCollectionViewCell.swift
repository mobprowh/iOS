//
//  BA_StatsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 03/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_StatsCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var leagueNameButton: UIButton!
	@IBOutlet var leagueImage: UIImageView!
	
	private var leagueId: Int!
	private var delegate: BA_StatsDelegate?
	
	func setupCell(leagueName: String, leagueId: Int, imageUrl: String, delegate: BA_StatsDelegate?) {
		
		self.leagueId = leagueId
		self.delegate = delegate
		self.leagueNameButton.setTitle(leagueName, for: UIControlState.normal)
		UIImage.getWebImage(imageUrl: imageUrl) { (responseImage) in
			
			self.leagueImage.image = responseImage
		}
	}
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	@IBAction func btnLeagueDetailTapped(sender: UIButton) {
		
		if(self.delegate != nil) {
			
			self.delegate?.leagueTapped(leagueId: self.leagueId)
		}
	}
	
}
