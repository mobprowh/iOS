//
//  BA_MatchDetailLineupsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 21/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

class BA_MatchDetailLineupsCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var teamFormView: BA_TeamForm!
	@IBOutlet var jerseyNumber: UILabel!
	@IBOutlet var playerName: UILabel!
	@IBOutlet var playerPosition: UILabel!
	
	private var teamColor1: UIColor!
	private var teamColor2: UIColor!
	private var playerData: BA_Player!
	
	func setupCell(teamColor1: UIColor, teamColor2: UIColor, playerData: BA_Player) {
		
		self.teamColor1 = teamColor1
		self.teamColor2 = teamColor2
		self.playerData = playerData
	}
	
	func cellWillDisplay() {
		
		self.jerseyNumber.text = "\(self.playerData.jerseyNumber)"
		self.playerName.text = "\(self.playerData.playerName)"
		
		#if os(iOS)
			self.teamFormView.setTeamFormColors(leftFormColor: self.teamColor1, rightFormColor: self.teamColor2)
		#endif
		
		switch(self.playerData.playerPos) {
		case "goalkeeper":
			self.playerPosition.text = "K"
			break
		case "midfielder":
			self.playerPosition.text = "O"
			break
		case "defender":
			self.playerPosition.text = "D"
			break
		case "forward":
			self.playerPosition.text = "F"
			break
		default:
			self.playerPosition.text = ""
			break
		}
	}
}
