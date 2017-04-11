//
//  BA_LiveTableViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 25/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

protocol BA_LiveTableViewCellDelegate {
	
    func leagueDetailTapped(leagueId: Int)
	func liveTableViewCell(matchTapped matchId: String, matchYear: String)
}

class BA_LiveTableViewCell: UITableViewCell {

    @IBOutlet var team1Name: UILabel!
    @IBOutlet var team2Name: UILabel!
    @IBOutlet var halfTimeScoreLabel: UILabel!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var homeTeamGoals: UILabel!
    @IBOutlet var awayTeamGoals: UILabel!
    @IBOutlet weak var team1FormView: BA_TeamForm!
    @IBOutlet weak var team2FormView: BA_TeamForm!
    @IBOutlet weak var team1Logo: UIImageView!
    @IBOutlet weak var team2Logo: UIImageView!
    @IBOutlet var timeContainer: UIView!
    
    private var delegate: BA_LiveTableViewCellDelegate?
    private var matchId = ""
    private var matchYear = 0
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    fileprivate let halfTimeScoreTextFormat = "IY %d:%d"
    fileprivate let currentMatchTimeFormat = "%d'"
    
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
    
    func setupView(matchData: BA_Matc, delegate: BA_LiveTableViewCellDelegate) {
        
        self.team1Name.text = matchData.homeTeam.teamName
        self.team2Name.text = matchData.awayTeam.teamName
        
        let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
        if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
            self.team1Logo.isHidden = !isLogo
            self.team2Logo.isHidden = !isLogo
            self.team1FormView.isHidden = isLogo
            self.team2FormView.isHidden = isLogo
            
            if isLogo {
                UIImage.getWebImage(imageUrl: matchData.homeTeam.teamLogoURLString) { (responseImage) in
                    
                    self.team1Logo.image = responseImage
                }
                UIImage.getWebImage(imageUrl: matchData.awayTeam.teamLogoURLString) { (responseImage) in
                    
                    self.team2Logo.image = responseImage
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
        
        self.homeTeamGoals.text = "\(matchData.homeGoals)"
        self.awayTeamGoals.text = "\(matchData.awayGoals)"
        
        var minutes = matchData.currentMinutes
        if matchData.currentLiveMinutes != nil, let liveMinutes = Int(matchData.currentLiveMinutes!) {
            minutes = liveMinutes
        }
        
        let minutesText = String(format: self.currentMatchTimeFormat, minutes)
        self.currentTimeLabel.text = minutesText
        
        if minutes < 46 {
            self.halfTimeScoreLabel.isHidden = true
        } else {
            self.halfTimeScoreLabel.isHidden = false
            let halfTimeScoreText = String(format: self.halfTimeScoreTextFormat, matchData.halfTimeHomeGoals, matchData.halfTimeAwayGoals)
            self.halfTimeScoreLabel.text = halfTimeScoreText
        }
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapGestureTapped(sender:)))
        self.contentView.addGestureRecognizer(self.tapGestureRecognizer!)
    }
	
	/**
	* @TODO: update delegate method
	*/
	public func cellTapGestureTapped(sender: UITapGestureRecognizer?) -> Void {
		
		guard self.delegate != nil else {
			return
		}
	
        self.delegate?.liveTableViewCell(matchTapped: self.matchId, matchYear: "\(self.matchYear)")
	}
}
