//
//  BA_BallControlCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 04/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import KDCircularProgress

class BA_BallControlCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var homeTeamName: UILabel!
	@IBOutlet var homeTeamBallControlProgress: KDCircularProgress!
	@IBOutlet var homeTeamBallControl: UILabel!
    @IBOutlet var homeTeamForm: BA_TeamForm!
    @IBOutlet var homeTeamLogo: UIImageView!
	
	@IBOutlet var awayTeamName: UILabel!
	@IBOutlet var awayTeamBallControlProgress: KDCircularProgress!
	@IBOutlet var awayTeamBallControl: UILabel!
    @IBOutlet var awayTeamForm: BA_TeamForm!
    @IBOutlet var awayTeamLogo: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.homeTeamBallControl.layer.cornerRadius = self.homeTeamBallControl.bounds.size.width / 2.0
        self.homeTeamBallControl.layer.masksToBounds = true
        
        self.awayTeamBallControl.layer.cornerRadius = self.awayTeamBallControl.bounds.size.width / 2.0
        self.awayTeamBallControl.layer.masksToBounds = true
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
        
        self.homeTeamForm.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.homeTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.homeTeamUIColor2)!)
        
		self.homeTeamName.text = "\((matchDetailData?.pointee.homeTeamName)!)"
		let homeTeamPosVal: Double
		
		if let homeTeamStats = matchDetailData?.pointee.homeTeamMatchStats {
			
			homeTeamPosVal = Double(homeTeamStats.pos)
		}else{
			homeTeamPosVal = 0
		}
        
        self.awayTeamForm.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.awayTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.awayTeamUIColor2)!)
		
		self.awayTeamName.text = "\((matchDetailData?.pointee.awayTeamName)!)"
		let awayTeamPosVal: Double
		
		if let awayTeamStats = matchDetailData?.pointee.awayTeamMatchStats {
			
			awayTeamPosVal = Double(awayTeamStats.pos)
		}else{
			awayTeamPosVal = 0
		}
		
		let homeTeamProgressVal: Double = (homeTeamPosVal / 100.0)
		let awayTeamProgressVal: Double = (awayTeamPosVal / 100.0)
		
		let homeTeamRiseValue: Double = (homeTeamPosVal / 8)
		let awayTeamRiseValue: Double = (awayTeamPosVal / 8)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
			
			self.setupPercentTexts(homeTeamPos: homeTeamPosVal, awayTeamPos: awayTeamPosVal, homeTeamRiseValue: homeTeamRiseValue, awayTeamRiseValue: awayTeamRiseValue, homeTeamCurrentPos: 0, awayTeamCurrentPos: 0, currentDuration: 0)
			
            self.homeTeamBallControlProgress.animate(fromAngle: 0, toAngle: 360 * homeTeamProgressVal, duration: 0.8, completion: nil)
            self.awayTeamBallControlProgress.animate(fromAngle: 0, toAngle: 360 * awayTeamProgressVal, duration: 0.8, completion: nil)
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
