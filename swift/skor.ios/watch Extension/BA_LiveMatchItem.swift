//
//  BA_LiveMatchItem.swift
//  bahisadam
//
//  Created by ilker özcan on 10/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import WatchKit
import WKBahisadamLive

class BA_LiveMatchItem: NSObject {

	@IBOutlet var homeTeamName: WKInterfaceLabel!
	@IBOutlet var awayTeamName: WKInterfaceLabel!
	@IBOutlet var homeTeamGoals: WKInterfaceLabel!
	@IBOutlet var awayTeamGoals: WKInterfaceLabel!
	@IBOutlet var matchStatusGroup: WKInterfaceGroup!
	@IBOutlet var matchStatusLabel: WKInterfaceLabel!

	func setupCell(matchData: BA_Matc) {
		
		self.homeTeamName.setText(matchData.homeTeam.teamName)
		self.awayTeamName.setText(matchData.awayTeam.teamName)
		
		self.homeTeamGoals.setText("\(matchData.homeGoals)")
		self.awayTeamGoals.setText("\(matchData.awayGoals)")
		
		if(matchData.matchType == .Playing) {
			
			self.matchStatusGroup.setBackgroundColor(UIColor(red: 54.0/255.0, green: 215.0/255.0, blue: 139.0/255.0, alpha: 1.0))
			self.matchStatusLabel.setText("\(matchData.currentLiveMinutes!)'")
		}else{
			
			self.matchStatusGroup.setBackgroundColor(UIColor.white)
			if(matchData.currentLiveMinutes == "Des") {
				
				self.matchStatusLabel.setText("I.Y.")
			}else{
				
				self.matchStatusLabel.setText("M.S.")
			}
		}
	}
}
