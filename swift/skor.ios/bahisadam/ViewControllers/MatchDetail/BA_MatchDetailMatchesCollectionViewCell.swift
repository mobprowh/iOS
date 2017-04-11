//
//  BA_MatchDetailMatchesCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 30/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

class BA_MatchDetailMatchesCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var homeTeamName: UILabel!
	@IBOutlet var awayTeamName: UILabel!
	
	@IBOutlet var homeTeamFormView: BA_TeamForm!
	@IBOutlet var awayTeamFormView: BA_TeamForm!
    @IBOutlet var homeTeamLogo: UIImageView!
    @IBOutlet var awayTeamLogo: UIImageView!
	
	@IBOutlet var homeTeamGoals: UILabel!
	@IBOutlet var awayTeamGoals: UILabel!
	
	@IBOutlet var matchDate: UILabel!
	
	@IBOutlet var winView: UIView!
	@IBOutlet var looseView: UIView!
	@IBOutlet var drawView: UIView!
	
	private var matchData: BA_Matc!
	private var baseTeam: Int!
	private var baseTeamName: String!
	
	func setupCell(matchData: BA_Matc, baseTeam: Int, baseTeamName: String) {
		
		self.matchData = matchData
		
		self.matchDate.isHidden = true
		
		self.winView.isHidden = true
		self.looseView.isHidden = true
		self.drawView.isHidden = true
		
		self.baseTeam = baseTeam
		self.baseTeamName = baseTeamName
	}
	
	func cellWillDisplay() {
		
		self.homeTeamName.text = matchData.homeTeam.teamName
		self.awayTeamName.text = matchData.awayTeam.teamName
		
		self.homeTeamGoals.text = "\(matchData.homeGoals)"
		self.awayTeamGoals.text = "\(matchData.awayGoals)"
		
        let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
        if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
            self.homeTeamLogo.isHidden = !isLogo
            self.awayTeamLogo.isHidden = !isLogo
            self.homeTeamFormView.isHidden = isLogo
            self.awayTeamFormView.isHidden = isLogo
            
            if isLogo {
                UIImage.getWebImage(imageUrl: matchData.homeTeam.teamLogoURLString) { (responseImage) in
                    
                    self.homeTeamLogo.image = responseImage
                }
                UIImage.getWebImage(imageUrl: matchData.awayTeam.teamLogoURLString) { (responseImage) in
                    
                    self.awayTeamLogo.image = responseImage
                }
            }
            
        } else {
            self.homeTeamLogo.isHidden = true
            self.awayTeamLogo.isHidden = true
            self.homeTeamFormView.isHidden = false
            self.awayTeamFormView.isHidden = false
        }
        
		#if os(iOS)
        self.homeTeamFormView.setTeamFormColors(leftFormColor: matchData.homeTeam.color1, rightFormColor: matchData.homeTeam.color2)
        self.awayTeamFormView.setTeamFormColors(leftFormColor: matchData.awayTeam.color1, rightFormColor: matchData.awayTeam.color2)
		#endif
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
        dateFormatter.locale = Locale(identifier: "tr_TR_POSIX")
        
        if Int(dateFormatter.string(from: Date()))! > Int(dateFormatter.string(from: matchData.matchDate!))! {
            self.matchDate.text = "\(dateFormatter.string(from: matchData.matchDate!))"
        } else {
            dateFormatter.dateFormat = "dd MMMM"
            self.matchDate.text = "\(dateFormatter.string(from: matchData.matchDate!))"
        }
		
		self.matchDate.isHidden = false
		
		let baseTeamHomeGoals: Int
		let baseTeamAwayGoals: Int
		
		if(baseTeamName == matchData.homeTeam.teamName) {
			
			baseTeamHomeGoals = matchData.homeGoals
			baseTeamAwayGoals = matchData.awayGoals
		}else{
			
			baseTeamAwayGoals = matchData.homeGoals
			baseTeamHomeGoals = matchData.awayGoals
		}
		
		if(baseTeam != 1) {
			
			if(baseTeamHomeGoals > baseTeamAwayGoals) {
				
				self.winView.layoutIfNeeded()
				let viewSize = self.winView.bounds.size
				let cornerRadius = viewSize.width / 2
				self.winView.layer.cornerRadius = cornerRadius
				self.winView.layer.masksToBounds = true
				self.winView.isHidden = false
			} else if(baseTeamHomeGoals < baseTeamAwayGoals) {
				
				self.looseView.layoutIfNeeded()
				let viewSize = self.looseView.bounds.size
				let cornerRadius = viewSize.width / 2
				self.looseView.layer.cornerRadius = cornerRadius
				self.looseView.layer.masksToBounds = true
				self.looseView.isHidden = false
			}else{
				
				self.drawView.layoutIfNeeded()
				let viewSize = self.drawView.bounds.size
				let cornerRadius = viewSize.width / 2
				self.drawView.layer.cornerRadius = cornerRadius
				self.drawView.layer.masksToBounds = true
				self.drawView.isHidden = false
			}
		}
	}
}
