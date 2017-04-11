//
//  BA_PointsCellCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 28/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive

protocol BA_PointsCellCollectionViewCellDelegate {
	
	func pointsCellTabBtnTapped(tabType: BA_PointsCellCollectionViewCell.CellTypes)
}

class BA_PointsCellCollectionViewCell: UICollectionViewCell {
 
    enum CellTypes: Int {
		case GENERAL = 0
		case INSIDE = 1
		case OUTSIDE = 2
	}
	
//	@IBOutlet var btnGeneral: UIButton!
//	@IBOutlet var btnInside: UIButton!
//	@IBOutlet var btnOutside: UIButton!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
	
	@IBOutlet var team1Pos: UILabel!
	@IBOutlet var team2Pos: UILabel!
    
    @IBOutlet var team1Form: BA_TeamForm!
    @IBOutlet var team2Form: BA_TeamForm!
    @IBOutlet var team1Logo: UIImageView!
    @IBOutlet var team2Logo: UIImageView!
	
	@IBOutlet var team1Name: UILabel!
	@IBOutlet var team2Name: UILabel!
	
	@IBOutlet var team1OM: UILabel!
	@IBOutlet var team2OM: UILabel!
	
	@IBOutlet var team1G: UILabel!
	@IBOutlet var team2G: UILabel!
	
	@IBOutlet var team1B: UILabel!
	@IBOutlet var team2B: UILabel!
	
	@IBOutlet var team1M: UILabel!
	@IBOutlet var team2M: UILabel!
	
	@IBOutlet var team1AVG: UILabel!
	@IBOutlet var team2AVG: UILabel!
    
    var currentMatchDetailData: UnsafeMutablePointer<BA_MatchDetailData>?
	
	private var delegate: BA_PointsCellCollectionViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.segmentedControl.addTarget(self, action: #selector(valueChanged(control:)), for: .valueChanged)
    }
    
    func valueChanged(control: UISegmentedControl) {
        guard self.delegate != nil else {
            return
        }
        
        let value = CellTypes.init(rawValue: control.selectedSegmentIndex)
        
        setupCell(cellType: value!, matchDetailData: currentMatchDetailData, delegate: delegate!)
    }
    
	func setupCell(cellType: CellTypes, matchDetailData: UnsafeMutablePointer<BA_MatchDetailData>?, delegate: BA_PointsCellCollectionViewCellDelegate) {
        
		guard matchDetailData?.pointee.homeTeamPos != nil && matchDetailData?.pointee.awayTeamPos != nil else {
			return
		}
        
        currentMatchDetailData = matchDetailData
		
		let team1PosInt: Int
		let team1Data: BA_Standings?
		let team2PosInt: Int
		let team2Data: BA_Standings?
		
		switch cellType {
		case .GENERAL:
			
            self.segmentedControl.selectedSegmentIndex = CellTypes.GENERAL.rawValue
            
			guard (matchDetailData?.pointee.homeTeamInsidePos != nil && matchDetailData?.pointee.awayTeamInsidePos != nil) else {
    
				team1PosInt = 0
				team2PosInt = 0
				team1Data = nil
				team2Data = nil
				return
			}
			
			if((matchDetailData?.pointee.homeTeamPos)! <= (matchDetailData?.pointee.awayTeamPos)!) {
				
				team1PosInt = matchDetailData?.pointee.homeTeamPos ?? 0
				team1Data = (matchDetailData?.pointee.homeTeamStanding)!
				
				team2PosInt = matchDetailData?.pointee.awayTeamPos ?? 0
				team2Data = (matchDetailData?.pointee.awayTeamStanding)!
                
                let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
                if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
                    self.team1Logo.isHidden = !isLogo
                    self.team2Logo.isHidden = !isLogo
                    self.team1Form.isHidden = isLogo
                    self.team2Form.isHidden = isLogo
                    
                    if isLogo {
                        UIImage.getWebImage(imageUrl: (matchDetailData?.pointee.homeTeamLogoURLString)!) { (responseImage) in
                            
                            self.team1Logo.image = responseImage
                        }
                        UIImage.getWebImage(imageUrl: (matchDetailData?.pointee.awayTeamLogoURLString)!) { (responseImage) in
                            
                            self.team2Logo.image = responseImage
                        }
                    }
                    
                } else {
                    self.team1Logo.isHidden = true
                    self.team2Logo.isHidden = true
                    self.team1Form.isHidden = false
                    self.team2Form.isHidden = false
                }
                
                team1Form.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.homeTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.homeTeamUIColor2)!)
                team2Form.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.awayTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.awayTeamUIColor2)!)
			}else{
				
				team2PosInt = matchDetailData?.pointee.homeTeamPos ?? 0
				team2Data = (matchDetailData?.pointee.homeTeamStanding)!
				
				team1PosInt = matchDetailData?.pointee.awayTeamPos ?? 0
				team1Data = (matchDetailData?.pointee.awayTeamStanding)!
                
                let appDelegate = UIApplication.shared.delegate as! BA_AppDelegate
                if let isLogo = appDelegate.remoteConfig?["is_ios_logo_enabled"].boolValue {
                    self.team1Logo.isHidden = !isLogo
                    self.team2Logo.isHidden = !isLogo
                    self.team1Form.isHidden = isLogo
                    self.team2Form.isHidden = isLogo
                    
                    if isLogo {
                        UIImage.getWebImage(imageUrl: (matchDetailData?.pointee.awayTeamLogoURLString)!) { (responseImage) in
                            
                            self.team1Logo.image = responseImage
                        }
                        UIImage.getWebImage(imageUrl: (matchDetailData?.pointee.homeTeamLogoURLString)!) { (responseImage) in
                            
                            self.team2Logo.image = responseImage
                        }
                    }
                    
                } else {
                    self.team1Logo.isHidden = true
                    self.team2Logo.isHidden = true
                    self.team1Form.isHidden = false
                    self.team2Form.isHidden = false
                }
                
                team1Form.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.awayTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.awayTeamUIColor2)!)
                team2Form.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.homeTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.homeTeamUIColor2)!)
			}
			
			break
		case .INSIDE:
            self.segmentedControl.selectedSegmentIndex = CellTypes.INSIDE.rawValue
			
			guard (matchDetailData?.pointee.homeTeamInsidePos != nil && matchDetailData?.pointee.awayTeamInsidePos != nil) else {
    
				team1PosInt = 0
				team2PosInt = 0
				team1Data = nil
				team2Data = nil
				return
			}
			
			if((matchDetailData?.pointee.homeTeamInsidePos)! <= (matchDetailData?.pointee.awayTeamInsidePos)!) {
				
				team1PosInt = matchDetailData?.pointee.homeTeamInsidePos ?? 0
				team1Data = (matchDetailData?.pointee.homeTeamInsideStanding)!
				
				team2PosInt = matchDetailData?.pointee.awayTeamInsidePos ?? 0
				team2Data = (matchDetailData?.pointee.awayTeamInsideStanding)!
			}else{
				
				team2PosInt = matchDetailData?.pointee.homeTeamInsidePos ?? 0
				team2Data = (matchDetailData?.pointee.homeTeamInsideStanding)!
				
				team1PosInt = matchDetailData?.pointee.awayTeamInsidePos ?? 0
				team1Data = (matchDetailData?.pointee.awayTeamInsideStanding)!
			}
			
			break
		case .OUTSIDE:
            
            self.segmentedControl.selectedSegmentIndex = CellTypes.OUTSIDE.rawValue
            
			guard (matchDetailData?.pointee.homeTeamInsidePos != nil && matchDetailData?.pointee.awayTeamInsidePos != nil) else {
    
				team1PosInt = 0
				team2PosInt = 0
				team1Data = nil
				team2Data = nil
				return
			}
			
			if((matchDetailData?.pointee.homeTeamOutsidePos)! <= (matchDetailData?.pointee.awayTeamOutsidePos)!) {
				
				team1PosInt = matchDetailData?.pointee.homeTeamOutsidePos ?? 0
				team1Data = (matchDetailData?.pointee.homeTeamOutsideStandings)!
				
				team2PosInt = matchDetailData?.pointee.awayTeamOutsidePos ?? 0
				team2Data = (matchDetailData?.pointee.awayTeamOutsideStandings)!
                
                team1Form.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.homeTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.homeTeamUIColor2)!)
                team2Form.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.awayTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.awayTeamUIColor2)!)
			}else{
				
				team2PosInt = matchDetailData?.pointee.homeTeamOutsidePos ?? 0
				team2Data = (matchDetailData?.pointee.homeTeamOutsideStandings)!
				
				team1PosInt = matchDetailData?.pointee.awayTeamOutsidePos ?? 0
				team1Data = (matchDetailData?.pointee.awayTeamOutsideStandings)!
                
                team1Form.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.awayTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.awayTeamUIColor2)!)
                team2Form.setTeamFormColors(leftFormColor: (matchDetailData?.pointee.homeTeamUIColor1)!, rightFormColor: (matchDetailData?.pointee.homeTeamUIColor2)!)
			}
			
			break
		}
		
		team1Pos.text = "\(team1PosInt)"
		team2Pos.text = "\(team2PosInt)"
		
		self.delegate = delegate
		
		guard (team1Data != nil && team2Data != nil) else {
			
			return
		}
		
		team1Name.text = team1Data!.teamName
		team2Name.text = team2Data!.teamName
		
		team1OM.text = "\(team1Data!.standingOM)"
		team2OM.text = "\(team2Data!.standingOM)"
		
		team1G.text = "\(team1Data!.standingG)"
		team2G.text = "\(team2Data!.standingG)"
		
		team1B.text = "\(team1Data!.standingB)"
		team2B.text = "\(team2Data!.standingB)"
		
		team1M.text = "\(team1Data!.standingM)"
		team2M.text = "\(team2Data!.standingM)"
		
		team1AVG.text = "\(team1Data!.standingPTS)"
		team2AVG.text = "\(team2Data!.standingPTS)"
	}
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
}
