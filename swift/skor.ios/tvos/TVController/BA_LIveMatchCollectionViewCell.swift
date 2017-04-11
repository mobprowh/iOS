//
//  BA_LIveMatchCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 12/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import TVBahisadamLive

class BA_LIveMatchCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var team1Name: UILabel!
	@IBOutlet var team2Name: UILabel!
	@IBOutlet var homeGoals: UILabel!
	@IBOutlet var awayGoals: UILabel!
	@IBOutlet var currentTimeLabel: UILabel!
	@IBOutlet var isPlayingView: UIView!
	@IBOutlet var rightBorderView: UIView!
	
	override func layoutIfNeeded() {
		
		super.layoutIfNeeded()
		let playingViewRadius = self.isPlayingView.frame.size.width / 2
		self.isPlayingView.layer.cornerRadius = playingViewRadius
		self.isPlayingView.layer.masksToBounds = true
	}
	
	func setupView(matchData: BA_Matc, rightBorderStatus: Bool) {
		
		self.team1Name.text = matchData.homeTeam.teamName
		self.team2Name.text = matchData.awayTeam.teamName
		self.homeGoals.text = "\(matchData.homeGoals)"
		self.awayGoals.text = "\(matchData.awayGoals)"
		
		if(matchData.matchType == .Playing) {
			
			self.isPlayingView.isHidden = false
			self.currentTimeLabel.text = "\(matchData.currentLiveMinutes!)'"
		}else{
			self.isPlayingView.isHidden = true
			
			if(matchData.currentLiveMinutes == "Des") {
				
				self.currentTimeLabel.text = "I.Y."
			}else{
				
				self.currentTimeLabel.text = "M.S."
			}
		}
		
		self.rightBorderView.isHidden = !rightBorderStatus
		self.layoutIfNeeded()
	}
}
