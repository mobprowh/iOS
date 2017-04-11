//
//  BA_LiveWidgetCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 09/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_LiveWidgetDelegate {
	
	func openMatchDetail(matchYear: Int, matchId: String)
}

class BA_LiveWidgetCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var team1: UIButton!
	@IBOutlet var scoreData: UIButton!
	@IBOutlet var team2: UIButton!
	
	private var matchYear: Int!
	private var matchId: String!
	private var delegate: BA_LiveWidgetDelegate?
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	func setupCell(team1Name: String, team2Name: String, score: String, matchYear: Int, matchId: String, delegate: BA_LiveWidgetDelegate) {
		
		self.team1.setTitle(team1Name, for: UIControlState.normal)
		self.scoreData.setTitle(score, for: UIControlState.normal)
		self.team2.setTitle(team2Name, for: UIControlState.normal)
		self.matchYear = matchYear
		self.matchId = matchId
		self.delegate = delegate
	}
	
	@IBAction func openMatchDetail(sender: UIButton) {
		
		guard self.delegate != nil else {
			return
		}
		
		delegate!.openMatchDetail(matchYear: self.matchYear, matchId: self.matchId)
	}
}
