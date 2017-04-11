//
//  BA_MatchListCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 04/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive
import FontAwesome_swift

class BA_MatchListCollectionViewCell: UICollectionViewCell {
 
	@IBOutlet var team1Name: UILabel!
	@IBOutlet var team2Name: UILabel!
	@IBOutlet var halfTimeScoreLabel: UILabel!
	@IBOutlet var currentTimeLabel: UILabel!
	@IBOutlet var homeTeamGoals: UILabel!
	@IBOutlet var awayTeamGoals: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet weak var kickoffTimeLabel: UILabel!
    @IBOutlet weak var team1FormView: BA_TeamForm!
    @IBOutlet weak var team2FormView: BA_TeamForm!
    @IBOutlet var timeContainer: UIView!
    @IBOutlet weak var team1Logo: UIImageView!
    @IBOutlet weak var team2Logo: UIImageView!
	
	private var delegate: BA_MatchTableDelegate?
	private var matchId = ""
    private var isFavourite = false
	private var matchYear = 0
	private var tapGestureRecognizer: UITapGestureRecognizer?
	private var matchType: BA_Matc.MATCH_TYPES?
	
	fileprivate let halfTimeScoreTextFormat = "IY %d:%d"
	fileprivate let currentMatchTimeFormat = "%d'" //"%d dk.\nDetay\n﹀"
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.reuseIdentifier == "matchCellPlaying" {
            let maskPath = UIBezierPath.init(roundedRect: self.timeContainer.bounds, byRoundingCorners: [.bottomRight, .topRight], cornerRadii: CGSize(width: 2, height: 2))
            let shape = CAShapeLayer()
            shape.frame = self.timeContainer.bounds
            shape.path = maskPath.cgPath
            self.timeContainer.layer.mask = shape
        }
    }
    
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	func setupView(matchData: BA_Matc, delegate: BA_MatchTableDelegate) {
		
		self.team1Name.text = matchData.homeTeam.teamName
		self.team2Name.text = matchData.awayTeam.teamName
        
        let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
        if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
            self.team1Logo.isHidden = !isLogo
            self.team2Logo.isHidden = !isLogo
            self.team1FormView.isHidden = isLogo
            self.team2FormView.isHidden = isLogo
            
//            self.team1Logo.image = nil
//            self.team2Logo.image = nil
            
            if isLogo {
                UIImage.getWebImage(imageUrl: matchData.homeTeam.teamLogoURLString) { (responseImage) in
                    
                    if responseImage != nil {
                        self.team1Logo.image = responseImage
                    }
                }
                UIImage.getWebImage(imageUrl: matchData.awayTeam.teamLogoURLString) { (responseImage) in
                    
                    if responseImage != nil {
                        self.team2Logo.image = responseImage
                    }
                }
            }
            
        } else {
            self.team1Logo.isHidden = true
            self.team2Logo.isHidden = true
            self.team1FormView.isHidden = false
            self.team2FormView.isHidden = false
        }
        
        self.team1FormView.setTeamFormColors(leftFormColor: matchData.homeTeam.color1, rightFormColor: matchData.homeTeam.color2)
        self.team2FormView.setTeamFormColors(leftFormColor: matchData.awayTeam.color1, rightFormColor: matchData.awayTeam.color2)
        
		self.delegate = delegate
		self.matchId = matchData.matchId
		self.matchYear = matchData.matchYear
		self.matchType = matchData.matchType
		
		if(matchData.matchType == .NotPlayed) {
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "HH':'mm"
			self.kickoffTimeLabel.text = dateFormatter.string(from: matchData.matchDate!)
			
		}else if(matchData.matchType == .Played) {
			
			self.homeTeamGoals.text = "\(matchData.homeGoals)"
			self.awayTeamGoals.text = "\(matchData.awayGoals)"
			
			let halfTimeScoreText = String(format: self.halfTimeScoreTextFormat, matchData.halfTimeHomeGoals, matchData.halfTimeAwayGoals)
            self.halfTimeScoreLabel.text = halfTimeScoreText
			
		}else if(matchData.matchType == .Playing) {
			
			self.homeTeamGoals.text = "\(matchData.homeGoals)"
			self.awayTeamGoals.text = "\(matchData.awayGoals)"
			let minutesText = String(format: self.currentMatchTimeFormat, matchData.currentMinutes)
            self.currentTimeLabel.text = minutesText
			
            if matchData.currentMinutes < 46 {
                self.halfTimeScoreLabel.isHidden = true
            } else {
                self.halfTimeScoreLabel.isHidden = false
                let halfTimeScoreText = String(format: self.halfTimeScoreTextFormat, matchData.halfTimeHomeGoals, matchData.halfTimeAwayGoals)
                self.halfTimeScoreLabel.text = halfTimeScoreText
            }
		}
        
		self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureTriggered(_:)))
		self.contentView.addGestureRecognizer(self.tapGestureRecognizer!)
        
        if BA_AppDelegate.Ba_LoginData != nil {
            if let favourite = BA_AppDelegate.Ba_LoginData!.favorites?.contains(matchData.matchId) {
                isFavourite = favourite
            } else {
                isFavourite = false
            }
        }
        
        favoriteButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
//        favoriteButton.tintColor = UIColor.init(colorLiteralRed: 50.0/255.0, green: 184.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        updateFavoriteButton()
	}
    
    func updateFavoriteButton() {
        let title = isFavourite ? String.fontAwesomeIcon(name: .star) : String.fontAwesomeIcon(name: .starO)
        let color = isFavourite ? UIColor.init(colorLiteralRed: 30.0/255.0, green: 89.0/255.0, blue: 106.0/255.0, alpha: 1.0) : UIColor.init(colorLiteralRed: 107.0/255.0, green: 114.0/255.0, blue: 123.0/255.0, alpha: 1.0)
        favoriteButton.setTitle(title, for: .normal)
        favoriteButton.setTitleColor(color, for: .normal)
    }
	
	@IBAction func btnDetailTapped(_ sender: UIButton) {
		
		if(self.delegate != nil) {
			
			delegate?.matchDetailTapped(matchId: self.matchId, matchType: self.matchType!)
		}
	}
	
	@objc private func tapGestureTriggered(_ sender: UITapGestureRecognizer) {
		
		if(self.delegate != nil) {
			
			delegate?.matchDetailTapped(matchId: self.matchId, matchType: self.matchType!)
		}
	}
    
    @IBAction func btnFavoriteTapped(_ sender: UIButton) {
        if delegate != nil {
//            isFavourite = !isFavourite
//            updateFavoriteButton()
//            delegate?.favoritesTapped(matchId: matchId, isFavorite: isFavourite)
            delegate?.favoritesTapped(cell: self, matchId: matchId, isFavorite: isFavourite)
        }
    }
}
