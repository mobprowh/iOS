//
//  BA_MatchStatsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 04/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchStatsCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var homeTeamFoul: UILabel!
	@IBOutlet var homeTeamShot: UILabel!
	@IBOutlet var homeTeamShotOnTarget: UILabel!
	@IBOutlet var homeTeamMissedShot: UILabel!
	@IBOutlet var homeTeamRescue: UILabel!
	@IBOutlet var homeTeamFreeKick: UILabel!
	@IBOutlet var homeTeamCorner: UILabel!
	@IBOutlet var homeTeamOffside: UILabel!
	
	@IBOutlet var awayTeamFoul: UILabel!
	@IBOutlet var awayTeamShot: UILabel!
	@IBOutlet var awayTeamShotOnTarget: UILabel!
	@IBOutlet var awayTeamMissedShot: UILabel!
	@IBOutlet var awayTeamRescue: UILabel!
	@IBOutlet var awayTeamFreeKick: UILabel!
	@IBOutlet var awayTeamCorner: UILabel!
	@IBOutlet var awayTeamOffside: UILabel!
    
    @IBOutlet var barContainers: [UIView]!
    
    @IBOutlet weak var homeFaulConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeShotsConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeShotsOnTargetConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeMissedOutShotsConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeRescuesConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeFreeKickConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeCornerConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeOffsideConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var awayFaulConstraint: NSLayoutConstraint!
    @IBOutlet weak var awayShotsConstraint: NSLayoutConstraint!
    @IBOutlet weak var awayShotsOnTargetConstraint: NSLayoutConstraint!
    @IBOutlet weak var awayMissedOutShotsConstraint: NSLayoutConstraint!
    @IBOutlet weak var awayRescuesConstraint: NSLayoutConstraint!
    @IBOutlet weak var awayFreeKickConstraint: NSLayoutConstraint!
    @IBOutlet weak var awayCornerConstraint: NSLayoutConstraint!
    @IBOutlet weak var awayOffsideConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for view in barContainers {
            view.layer.shadowColor = UIColor.gray.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowRadius = 0.5
            view.layer.masksToBounds = false
        }
    }
	
	func setupCell(matchDetailData: UnsafeMutablePointer<BA_MatchDetailData>?) {
		
        var fouls: Float = 0
        var shots: Float = 0
        var shotsOn: Float = 0
        var shotsOut: Float = 0
        var rescues: Float = 0
        var freeKicks: Float = 0
        var corners: Float = 0
        var offsides: Float = 0
        
		if let homeTeamAverageStats = matchDetailData?.pointee.homeTeamMatchStats {
			
            fouls += homeTeamAverageStats.foul
            shots += homeTeamAverageStats.shot
            shotsOn += homeTeamAverageStats.shotOnTarget
            shotsOut += homeTeamAverageStats.missedShot
            rescues += homeTeamAverageStats.rescue
            freeKicks += homeTeamAverageStats.freeKick
            corners += homeTeamAverageStats.corner
            offsides += homeTeamAverageStats.offSide
            
			self.homeTeamFoul.text = String(format: "%.0f", homeTeamAverageStats.foul)
			self.homeTeamShot.text = String(format: "%.0f", homeTeamAverageStats.shot)
			self.homeTeamShotOnTarget.text = String(format: "%.0f", homeTeamAverageStats.shotOnTarget)
			self.homeTeamMissedShot.text = String(format: "%.0f", homeTeamAverageStats.missedShot)
			self.homeTeamRescue.text = String(format: "%.0f", homeTeamAverageStats.rescue)
			self.homeTeamFreeKick.text = String(format: "%.0f", homeTeamAverageStats.freeKick)
			self.homeTeamCorner.text = String(format: "%.0f", homeTeamAverageStats.corner)
			self.homeTeamOffside.text = String(format: "%.0f", homeTeamAverageStats.offSide)
		}
		
		if let awayTeamAverageStats = matchDetailData?.pointee.awayTeamMatchStats {
			
            fouls += awayTeamAverageStats.foul
            shots += awayTeamAverageStats.shot
            shotsOn += awayTeamAverageStats.shotOnTarget
            shotsOut += awayTeamAverageStats.missedShot
            rescues += awayTeamAverageStats.rescue
            freeKicks += awayTeamAverageStats.freeKick
            corners += awayTeamAverageStats.corner
            offsides += awayTeamAverageStats.offSide
            
			self.awayTeamFoul.text = String(format: "%.0f", awayTeamAverageStats.foul)
			self.awayTeamShot.text = String(format: "%.0f", awayTeamAverageStats.shot)
			self.awayTeamShotOnTarget.text = String(format: "%.0f", awayTeamAverageStats.shotOnTarget)
			self.awayTeamMissedShot.text = String(format: "%.0f", awayTeamAverageStats.missedShot)
			self.awayTeamRescue.text = String(format: "%.0f", awayTeamAverageStats.rescue)
			self.awayTeamFreeKick.text = String(format: "%.0f", awayTeamAverageStats.freeKick)
			self.awayTeamCorner.text = String(format: "%.0f", awayTeamAverageStats.corner)
			self.awayTeamOffside.text = String(format: "%.0f", awayTeamAverageStats.offSide)
		}
        
        
        if let awayTeamAverageStats = matchDetailData?.pointee.awayTeamMatchStats {
            
            self.awayFaulConstraint = self.awayFaulConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.foul / fouls))
            self.awayShotsConstraint = self.awayShotsConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.shot / shots))
            self.awayShotsOnTargetConstraint = self.awayShotsOnTargetConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.shotOnTarget / shotsOn))
            self.awayMissedOutShotsConstraint = self.awayMissedOutShotsConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.missedShot / shotsOut))
            self.awayRescuesConstraint = self.awayRescuesConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.rescue / rescues))
            self.awayFreeKickConstraint = self.awayFreeKickConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.foul / fouls))
            self.awayCornerConstraint = self.awayCornerConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.corner / corners))
            self.awayOffsideConstraint = self.awayOffsideConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.offSide / offsides))
        }
        
        if let homeTeamAverageStats = matchDetailData?.pointee.homeTeamMatchStats {
            
            self.homeFaulConstraint = self.homeFaulConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.foul / fouls))
            self.homeShotsConstraint = self.homeShotsConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.shot / shots))
            self.homeShotsOnTargetConstraint = self.homeShotsOnTargetConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.shotOnTarget / shotsOn))
            self.homeMissedOutShotsConstraint = self.homeMissedOutShotsConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.missedShot / shotsOut))
            self.homeRescuesConstraint = self.homeRescuesConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.rescue / rescues))
            self.homeFreeKickConstraint = self.homeFreeKickConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.foul / fouls))
            self.homeCornerConstraint = self.homeCornerConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.corner / corners))
            self.homeOffsideConstraint = self.homeOffsideConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.offSide / offsides))
        }
    }
}
