//
//  BA_MatcEventsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 04/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_MatcEventsCollectionViewCellDelegate {
	
	func playerSelected(playerId: String)
}

class BA_MatcEventsCollectionViewCell: UICollectionViewCell {
 
//	@IBOutlet var firstMinutesLabel: UILabel!
//	@IBOutlet var secondMinutesLabel: UILabel!
//	
//	@IBOutlet var firstPlayerNameButton: UIButton!
//	@IBOutlet var secondPlayerNameButton: UIButton!
//	
//	@IBOutlet var yellowCardView: UIView!
//	@IBOutlet var redCardView: UIView!
    
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var firstPlayerNameLabel: UILabel!
    @IBOutlet var secondPlayerNameLabel: UILabel!
    @IBOutlet var eventImageView: UIImageView!
    
	
	//private var delegate: BA_MatcEventsCollectionViewCellDelegate?
	private var matchDetailDataPP: UnsafeMutablePointer<BA_MatchDetailData>?
	private var eventIdx: Int?
	private var firstEventRealIdx: Int?
	private var secondEventRealIdx: Int?
	
	override func removeFromSuperview() {
		
		//self.delegate = nil
		self.matchDetailDataPP = nil
		super.removeFromSuperview()
	}
	
	func setupCell(matchDetailData: UnsafeMutablePointer<BA_MatchDetailData>?, eventIdx: Int, eventType: BA_MatchEvents.EventTypes/*, delegate: BA_MatcEventsCollectionViewCellDelegate*/) {
		
		self.matchDetailDataPP = matchDetailData
		//self.delegate = delegate
		self.eventIdx = eventIdx
		self.firstEventRealIdx = -1
		self.secondEventRealIdx = -1
		
		if let matchEvents = matchDetailData?.pointee.matchEvents {
			
			var idxForType = 0
			
			for i in 0..<matchEvents.count {
				
				if(eventType == .Goal || eventType == .Asist) {
					
					if(matchEvents[i].type == eventType) {
						
						if(eventIdx == idxForType) {
							
							self.firstEventRealIdx = i
							break
						}else{
							
							idxForType += 1
						}
						
					}
					
				}else if(eventType == .YellowCard) {
					
					if(matchEvents[i].type == .RedCard || matchEvents[i].type == .YellowCard) {
						
						if(eventIdx == idxForType) {
							
							self.firstEventRealIdx = i
							break
						}else{
							
							idxForType += 1
						}
					}
				}else if(eventType == .Substitution) {
					
					if(matchEvents[i].type == eventType && matchEvents[i].substitutionAction == 18) {
						
						if(eventIdx == idxForType) {
							
							self.firstEventRealIdx = i
						}else{
							
							idxForType += 1
						}
					}else if(matchEvents[i].type == eventType && matchEvents[i].substitutionAction == 19 && self.firstEventRealIdx != -1) {
						
						self.secondEventRealIdx = i
						break
					}
				}
			}
			
			if((eventType == .Goal || eventType == .Asist) && self.firstEventRealIdx != -1) {
				
                self.firstPlayerNameLabel.text = "\(matchEvents[self.firstEventRealIdx!].playerName)"
				self.minutesLabel.text = "\(matchEvents[self.firstEventRealIdx!].minute)'"
				
			}else if(eventType == .YellowCard && self.firstEventRealIdx != -1) {
				
                self.firstPlayerNameLabel.text = "\(matchEvents[self.firstEventRealIdx!].playerName)"
				self.minutesLabel.text = "\(matchEvents[self.firstEventRealIdx!].minute)'"
				let currentDataEventType = matchEvents[self.firstEventRealIdx!].type
				
				if(currentDataEventType == .RedCard) {
					
					self.eventImageView.image = UIImage(named: "stats_redcard")
				}else if(currentDataEventType == .YellowCard) {
					
					self.eventImageView.image = UIImage(named: "stats_yellowcard")
				}
			
			}else if(eventType == .Substitution && self.firstEventRealIdx != -1 && self.secondEventRealIdx != -1) {
				
                self.firstPlayerNameLabel.text = "\(matchEvents[self.firstEventRealIdx!].playerName)"
                self.secondPlayerNameLabel.text = "\(matchEvents[self.secondEventRealIdx!].playerName)"
				self.minutesLabel.text = "\(matchEvents[self.firstEventRealIdx!].minute)'"
			}
            
            minutesLabel.backgroundColor = UIColor.init(colorLiteralRed: 218.0/255.0, green: 228.0/255.0, blue: 236.0/255.0, alpha: 1.0)
            minutesLabel.layer.cornerRadius = minutesLabel.bounds.size.width / 2.0
            minutesLabel.layer.masksToBounds = true
		}
	}
	
	// TODO: UPDATE Events Player
	@IBAction func firstPlayerButtonTapped(sender: UIButton) {
		
		/*guard self.delegate != nil else {
			return
		}
		
		if let playerId = self.matchDetailDataPP?.pointee.matchEvents?[self.firstEventRealIdx!].playerSrId {
			
			self.delegate?.playerSelected(playerId: playerId)
		}*/
	}
	
	@IBAction func secondPlayerButtonTapped(sender: UIButton) {
		
		/*guard self.delegate != nil else {
			return
		}
		
		if let playerId = self.matchDetailDataPP?.pointee.matchEvents?[self.secondEventRealIdx!].playerSrId {
			
			self.delegate?.playerSelected(playerId: playerId)
		}*/
	}
}
