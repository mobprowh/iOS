//
//  BA_GoalsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 29/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_GoalsCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet var homeTeamForm: BA_TeamForm!
    @IBOutlet var awayTeamForm: BA_TeamForm!
    @IBOutlet var homeTeamLogo: UIImageView!
    @IBOutlet var awayTeamLogo: UIImageView!
    
	@IBOutlet var homeTeamName: UILabel!
	@IBOutlet var awayTeamName: UILabel!
	
	@IBOutlet var homeTeamInsideAG: UILabel!
	@IBOutlet var homeTeamInsideYG: UILabel!
	
//	@IBOutlet var awayTeamInsideAG: UILabel!
//	@IBOutlet var awayTeamInsideYG: UILabel!
	
//	@IBOutlet var homeTeamOutsideAG: UILabel!
//	@IBOutlet var homeTeamOutsideYG: UILabel!
	
	@IBOutlet var awayTeamOutsideAG: UILabel!
	@IBOutlet var awayTeamOutsideYG: UILabel!
	
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
        self.awayTeamForm.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.awayTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.awayTeamUIColor2
            )!)
        
		self.homeTeamName.text = matchDetailData?.pointee.homeTeamName
		self.awayTeamName.text = matchDetailData?.pointee.awayTeamName
		
		let homeTeamInsideAGVal: Float = ((matchDetailData?.pointee.homeTeamInsideStanding?.standingOM ?? 0) > 0) ? (Float(matchDetailData?.pointee.homeTeamInsideStanding?.standingAG ?? 0) / Float((matchDetailData?.pointee.homeTeamInsideStanding?.standingOM)!)) : 0
		self.homeTeamInsideAG.text = String(format: "%.2f", homeTeamInsideAGVal)
		
		let homeTeamInsideYGVal: Float = ((matchDetailData?.pointee.homeTeamInsideStanding?.standingOM ?? 0) > 0) ? (Float(matchDetailData?.pointee.homeTeamInsideStanding?.standingYG ?? 0) / Float((matchDetailData?.pointee.homeTeamInsideStanding?.standingOM)!)) : 0
		self.homeTeamInsideYG.text = String(format: "%.2f", homeTeamInsideYGVal)
		
//		let awayTeamInsideAGVal: Float = ((matchDetailData?.pointee.awayTeamInsideStanding?.standingOM ?? 0) > 0) ? (Float(matchDetailData?.pointee.awayTeamInsideStanding?.standingAG ?? 0) / Float((matchDetailData?.pointee.awayTeamInsideStanding?.standingOM)!)) : 0
//		self.awayTeamInsideAG.text = String(format: "%.2f", awayTeamInsideAGVal)
//		
//		let awayTeamInsideYGVal: Float = ((matchDetailData?.pointee.awayTeamInsideStanding?.standingOM ?? 0) > 0) ? (Float(matchDetailData?.pointee.awayTeamInsideStanding?.standingYG ?? 0) / Float((matchDetailData?.pointee.awayTeamInsideStanding?.standingOM)!)) : 0
//		self.awayTeamInsideYG.text = String(format: "%.2f", awayTeamInsideYGVal)
		
		
//		let homeTeamOutsideAGVal: Float = ((matchDetailData?.pointee.homeTeamOutsideStandings?.standingOM ?? 0) > 0) ? (Float(matchDetailData?.pointee.homeTeamOutsideStandings?.standingAG ?? 0) / Float((matchDetailData?.pointee.homeTeamOutsideStandings?.standingOM)!)) : 0
//		self.homeTeamOutsideAG.text = String(format: "%.2f", homeTeamOutsideAGVal)
//		
//		let homeTeamOutsideYGVal: Float = ((matchDetailData?.pointee.homeTeamOutsideStandings?.standingOM ?? 0) > 0) ? (Float(matchDetailData?.pointee.homeTeamOutsideStandings?.standingYG ?? 0) / Float((matchDetailData?.pointee.homeTeamOutsideStandings?.standingOM)!)) : 0
//		self.homeTeamOutsideYG.text = String(format: "%.2f", homeTeamOutsideYGVal)
		
		let awayTeamOutsideAGVal: Float = ((matchDetailData?.pointee.awayTeamOutsideStandings?.standingOM ?? 0) > 0) ? (Float(matchDetailData?.pointee.awayTeamOutsideStandings?.standingAG ?? 0) / Float((matchDetailData?.pointee.awayTeamOutsideStandings?.standingOM)!)) : 0
		self.awayTeamOutsideAG.text = String(format: "%.2f", awayTeamOutsideAGVal)
		
		let awayTeamOutsideYGVal: Float = ((matchDetailData?.pointee.awayTeamOutsideStandings?.standingOM ?? 0) > 0) ? (Float(matchDetailData?.pointee.awayTeamOutsideStandings?.standingYG ?? 0) / Float((matchDetailData?.pointee.awayTeamOutsideStandings?.standingOM)!)) : 0
		self.awayTeamOutsideYG.text = String(format: "%.2f", awayTeamOutsideYGVal)
	}
}
