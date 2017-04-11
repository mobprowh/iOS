//
//  BA_AverageStatsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 04/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import KDCircularProgress

class BA_AverageStatsCollectionViewCell: UICollectionViewCell {
 
	@IBOutlet var homeTeamName: UILabel!
	@IBOutlet var homeTeamBallControlProgress: KDCircularProgress!
	@IBOutlet var homeTeamBallControl: UILabel!
    @IBOutlet var homeTeamForm: BA_TeamForm!
	@IBOutlet var homeTeamFoul: UILabel!
	@IBOutlet var homeTeamShot: UILabel!
	@IBOutlet var homeTeamShotOnTarget: UILabel!
	@IBOutlet var homeTeamMissedShot: UILabel!
	@IBOutlet var homeTeamRescue: UILabel!
	@IBOutlet var homeTeamFreeKick: UILabel!
	@IBOutlet var homeTeamCorner: UILabel!
	@IBOutlet var homeTeamOffside: UILabel!
    @IBOutlet var homeTeamLogo: UIImageView!
	
	@IBOutlet var awayTeamName: UILabel!
	@IBOutlet var awayTeamBallControlProgress: KDCircularProgress!
	@IBOutlet var awayTeamBallControl: UILabel!
    @IBOutlet var awayTeamForm: BA_TeamForm!
	@IBOutlet var awayTeamFoul: UILabel!
	@IBOutlet var awayTeamShot: UILabel!
	@IBOutlet var awayTeamShotOnTarget: UILabel!
	@IBOutlet var awayTeamMissedShot: UILabel!
	@IBOutlet var awayTeamRescue: UILabel!
	@IBOutlet var awayTeamFreeKick: UILabel!
	@IBOutlet var awayTeamCorner: UILabel!
	@IBOutlet var awayTeamOffside: UILabel!
    @IBOutlet var awayTeamLogo: UIImageView!
    
    @IBOutlet var headerContainer: UIView!
    @IBOutlet var triangleView: UIView!
    
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
        
        self.homeTeamBallControl.layer.cornerRadius = self.homeTeamBallControl.bounds.size.width / 2.0
        self.homeTeamBallControl.layer.masksToBounds = true
        
        self.awayTeamBallControl.layer.cornerRadius = self.awayTeamBallControl.bounds.size.width / 2.0
        self.awayTeamBallControl.layer.masksToBounds = true
        
        
        self.layoutIfNeeded()
        self.headerContainer.layer.shadowColor = UIColor.black.cgColor
        self.headerContainer.layer.shadowOpacity = 0.2
        self.headerContainer.layer.shadowOffset = CGSize.zero
        self.headerContainer.layer.shadowRadius = 0.5
        self.headerContainer.layer.masksToBounds = false
        
        let path = UIBezierPath()
        path.move(to: CGPoint())
        path.addLine(to: CGPoint(x: self.triangleView.bounds.size.width, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.triangleView.bounds.size.height))
        path.addLine(to: CGPoint())
        
        let shape = CAShapeLayer()
        shape.frame = self.triangleView.bounds
        shape.path = path.cgPath
        
        self.triangleView.layer.mask = shape
        
        for view in barContainers {
            view.layer.shadowColor = UIColor.gray.cgColor
            view.layer.shadowOpacity = 0.2
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowRadius = 0.5
            view.layer.masksToBounds = false
        }
    }
	
	func setupCell(matchDetailData: UnsafeMutablePointer<BA_MatchDetailData>?) {
		
        let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
        if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
            self.homeTeamLogo.isHidden = !isLogo
            self.awayTeamLogo.isHidden = !isLogo
            self.homeTeamForm.isHidden = isLogo
            self.awayTeamForm.isHidden = isLogo
            
            if isLogo {
                UIImage.getWebImage(imageUrl: (matchDetailData?.pointee.homeTeamLogoURLString)!) { (responseImage) in
                    
                    self.homeTeamLogo.image = responseImage
                }
                UIImage.getWebImage(imageUrl: (matchDetailData?.pointee.awayTeamLogoURLString)!) { (responseImage) in
                    
                    self.awayTeamLogo.image = responseImage
                }
            }
            
        } else {
            self.homeTeamLogo.isHidden = true
            self.awayTeamLogo.isHidden = true
            self.homeTeamForm.isHidden = false
            self.awayTeamForm.isHidden = false
        }
        
        var fouls: Float = 0
        var shots: Float = 0
        var shotsOn: Float = 0
        var shotsOut: Float = 0
        var rescues: Float = 0
        var freeKicks: Float = 0
        var corners: Float = 0
        var offsides: Float = 0
        
        self.homeTeamForm.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.homeTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.homeTeamUIColor2)!)
        
		self.homeTeamName.text = "\((matchDetailData?.pointee.homeTeamName)!)"
		let homeTeamPosVal: Double
		
		if let homeTeamAverageStats = matchDetailData?.pointee.homeTeamAverageStats {
			
            fouls += homeTeamAverageStats.foul
            shots += homeTeamAverageStats.shot
            shotsOn += homeTeamAverageStats.shotOnTarget
            shotsOut += homeTeamAverageStats.missedShot
            rescues += homeTeamAverageStats.rescue
            freeKicks += homeTeamAverageStats.freeKick
            corners += homeTeamAverageStats.corner
            offsides += homeTeamAverageStats.offSide
            
			self.homeTeamFoul.text = String(format: "%.1f", homeTeamAverageStats.foul)
			self.homeTeamShot.text = String(format: "%.1f", homeTeamAverageStats.shot)
			self.homeTeamShotOnTarget.text = String(format: "%.1f", homeTeamAverageStats.shotOnTarget)
			self.homeTeamMissedShot.text = String(format: "%.1f", homeTeamAverageStats.missedShot)
			self.homeTeamRescue.text = String(format: "%.1f", homeTeamAverageStats.rescue)
			self.homeTeamFreeKick.text = String(format: "%.1f", homeTeamAverageStats.freeKick)
			self.homeTeamCorner.text = String(format: "%.1f", homeTeamAverageStats.corner)
			self.homeTeamOffside.text = String(format: "%.1f", homeTeamAverageStats.offSide)
			
			homeTeamPosVal = Double(homeTeamAverageStats.pos)
		}else{
			homeTeamPosVal = 0
		}
        
        self.awayTeamForm.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.awayTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.awayTeamUIColor2)!)
		
		self.awayTeamName.text = "\((matchDetailData?.pointee.awayTeamName)!)"
		let awayTeamPosVal: Double
		
		if let awayTeamAverageStats = matchDetailData?.pointee.awayTeamAverageStats {
			
            fouls += awayTeamAverageStats.foul
            shots += awayTeamAverageStats.shot
            shotsOn += awayTeamAverageStats.shotOnTarget
            shotsOut += awayTeamAverageStats.missedShot
            rescues += awayTeamAverageStats.rescue
            freeKicks += awayTeamAverageStats.freeKick
            corners += awayTeamAverageStats.corner
            offsides += awayTeamAverageStats.offSide
            
			self.awayTeamFoul.text = String(format: "%.1f", awayTeamAverageStats.foul)
			self.awayTeamShot.text = String(format: "%.1f", awayTeamAverageStats.shot)
			self.awayTeamShotOnTarget.text = String(format: "%.1f", awayTeamAverageStats.shotOnTarget)
			self.awayTeamMissedShot.text = String(format: "%.1f", awayTeamAverageStats.missedShot)
			self.awayTeamRescue.text = String(format: "%.1f", awayTeamAverageStats.rescue)
			self.awayTeamFreeKick.text = String(format: "%.1f", awayTeamAverageStats.freeKick)
			self.awayTeamCorner.text = String(format: "%.1f", awayTeamAverageStats.corner)
			self.awayTeamOffside.text = String(format: "%.1f", awayTeamAverageStats.offSide)
			
			awayTeamPosVal = Double(awayTeamAverageStats.pos)
		}else{
			awayTeamPosVal = 0
		}
        
        if let awayTeamAverageStats = matchDetailData?.pointee.awayTeamAverageStats {
            
            self.awayFaulConstraint = self.awayFaulConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.foul / fouls))
            self.awayShotsConstraint = self.awayShotsConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.shot / shots))
            self.awayShotsOnTargetConstraint = self.awayShotsOnTargetConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.shotOnTarget / shotsOn))
            self.awayMissedOutShotsConstraint = self.awayMissedOutShotsConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.missedShot / shotsOut))
            self.awayRescuesConstraint = self.awayRescuesConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.rescue / rescues))
            self.awayFreeKickConstraint = self.awayFreeKickConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.foul / fouls))
            self.awayCornerConstraint = self.awayCornerConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.corner / corners))
            self.awayOffsideConstraint = self.awayOffsideConstraint.setMultiplier(multiplier: CGFloat(awayTeamAverageStats.offSide / offsides))
        }
        
        if let homeTeamAverageStats = matchDetailData?.pointee.homeTeamAverageStats {
            
            self.homeFaulConstraint = self.homeFaulConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.foul / fouls))
            self.homeShotsConstraint = self.homeShotsConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.shot / shots))
            self.homeShotsOnTargetConstraint = self.homeShotsOnTargetConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.shotOnTarget / shotsOn))
            self.homeMissedOutShotsConstraint = self.homeMissedOutShotsConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.missedShot / shotsOut))
            self.homeRescuesConstraint = self.homeRescuesConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.rescue / rescues))
            self.homeFreeKickConstraint = self.homeFreeKickConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.foul / fouls))
            self.homeCornerConstraint = self.homeCornerConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.corner / corners))
            self.homeOffsideConstraint = self.homeOffsideConstraint.setMultiplier(multiplier: CGFloat(homeTeamAverageStats.offSide / offsides))
        }
		
		let homeTeamProgressVal: Double = (homeTeamPosVal / 100.0)
		let awayTeamProgressVal: Double = (awayTeamPosVal / 100.0)
		
		let homeTeamRiseValue: Double = (homeTeamPosVal / 8)
		let awayTeamRiseValue: Double = (awayTeamPosVal / 8)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
			
			self.setupPercentTexts(homeTeamPos: homeTeamPosVal, awayTeamPos: awayTeamPosVal, homeTeamRiseValue: homeTeamRiseValue, awayTeamRiseValue: awayTeamRiseValue, homeTeamCurrentPos: 0, awayTeamCurrentPos: 0, currentDuration: 0)
			
            self.homeTeamBallControlProgress.angle = 360 * homeTeamProgressVal
            self.awayTeamBallControlProgress.angle = 360 * awayTeamProgressVal
            
//			self.homeTeamBallControlProgress.setProgress(progress: homeTeamProgressVal, animationduration: 0.8)
//			self.awayTeamBallControlProgress.setProgress(progress: awayTeamProgressVal, animationduration: 0.8)
			
		})
	}
	
	private func setupPercentTexts(homeTeamPos: Double, awayTeamPos: Double, homeTeamRiseValue: Double, awayTeamRiseValue: Double, homeTeamCurrentPos: Double, awayTeamCurrentPos: Double, currentDuration: Int) {
		
		if(currentDuration == 800) {
			
			self.homeTeamBallControl.text = String(format: "%d", Int(homeTeamPos))
			self.awayTeamBallControl.text = String(format: "%d", Int(awayTeamPos))
		}else{
			
			self.homeTeamBallControl.text = String(format: "%.0f", (homeTeamCurrentPos + homeTeamRiseValue))
			self.awayTeamBallControl.text = String(format: "%.0f", (awayTeamCurrentPos + awayTeamRiseValue))
			
			let nextDuration = currentDuration + 100
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
				
				self.setupPercentTexts(homeTeamPos: homeTeamPos, awayTeamPos: awayTeamPos, homeTeamRiseValue: homeTeamRiseValue, awayTeamRiseValue: awayTeamRiseValue, homeTeamCurrentPos: (homeTeamCurrentPos + homeTeamRiseValue), awayTeamCurrentPos: (awayTeamCurrentPos + awayTeamRiseValue), currentDuration: nextDuration)
			})
		}
	}
}

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        let mult = multiplier.isNaN ? CGFloat(0) : multiplier
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: mult,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
