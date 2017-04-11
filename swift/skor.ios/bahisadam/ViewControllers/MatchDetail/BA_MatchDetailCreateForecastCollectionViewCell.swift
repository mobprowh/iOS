//
//  BA_MatchDetailCreateForecastCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 21/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_MatchDetailCreateForecastDelegate {
	
	func createForecastBtnSendTapped(selectedForecastVal: String, comment: String)
}

class BA_MatchDetailCreateForecastCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
 
	// MARK: User defined attributes
	var selectedButtonColor: UIColor!
	var defaultButtonColor: UIColor!
	
	
	@IBOutlet var result_1: UIButton!
	@IBOutlet var result_x: UIButton!
	@IBOutlet var result_2: UIButton!
	
	@IBOutlet var halfTime_1: UIButton!
	@IBOutlet var halfTime_x: UIButton!
	@IBOutlet var halfTime_2: UIButton!

	@IBOutlet var doubleChance_1_x: UIButton!
	@IBOutlet var doubleChance_x_2: UIButton!
	@IBOutlet var doubleChance_1_2: UIButton!

	@IBOutlet var hand_1: UIButton!
	@IBOutlet var hand_x: UIButton!
	@IBOutlet var hand_2: UIButton!

	@IBOutlet var bott_15: UIButton!
	@IBOutlet var top_15: UIButton!
	
	@IBOutlet var bott_35: UIButton!
	@IBOutlet var top_35: UIButton!
	
	@IBOutlet var bott: UIButton!
	@IBOutlet var top: UIButton!
	
	@IBOutlet var kgv: UIButton!
	@IBOutlet var kgy: UIButton!
	
	@IBOutlet var sog01: UIButton!
	@IBOutlet var sog23: UIButton!
	@IBOutlet var sog46: UIButton!
	@IBOutlet var sog7: UIButton!
	
	@IBOutlet var iyms_11: UIButton!
	@IBOutlet var iyms_x1: UIButton!
	@IBOutlet var iyms_21: UIButton!
	@IBOutlet var iyms_1x: UIButton!
	@IBOutlet var iyms_2x: UIButton!
	@IBOutlet var iyms_xx: UIButton!
	@IBOutlet var iyms_22: UIButton!
	@IBOutlet var iyms_x2: UIButton!
	@IBOutlet var iyms_12: UIButton!
	
	@IBOutlet var textView: UITextView!
	
	private var delegate: BA_MatchDetailCreateForecastDelegate?
	private var selectedButton = -1
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	func setupCell(matchOdds: BA_MatchOdds, delegate: BA_MatchDetailCreateForecastDelegate) {
		
		self.delegate = delegate
		
		self.result_1.setTitle(String(format: "%.2f", matchOdds.result_1), for: UIControlState.normal)
		self.result_x.setTitle(String(format: "%.2f", matchOdds.result_x), for: UIControlState.normal)
		self.result_2.setTitle(String(format: "%.2f", matchOdds.result_2), for: UIControlState.normal)
		
		self.halfTime_1.setTitle(String(format: "%.2f", matchOdds.halfTime_1), for: UIControlState.normal)
		self.halfTime_x.setTitle(String(format: "%.2f", matchOdds.halfTime_x), for: UIControlState.normal)
		self.halfTime_2.setTitle(String(format: "%.2f", matchOdds.halfTime_2), for: UIControlState.normal)
		
		self.doubleChance_1_x.setTitle(String(format: "%.2f", matchOdds.doubleChance_1_x), for: UIControlState.normal)
		self.doubleChance_x_2.setTitle(String(format: "%.2f", matchOdds.doubleChance_x_2), for: UIControlState.normal)
		self.doubleChance_1_2.setTitle(String(format: "%.2f", matchOdds.doubleChance_1_2), for: UIControlState.normal)
		
		self.hand_1.setTitle(String(format: "%.2f", matchOdds.hand_1), for: UIControlState.normal)
		self.hand_x.setTitle(String(format: "%.2f", matchOdds.hand_x), for: UIControlState.normal)
		self.hand_2.setTitle(String(format: "%.2f", matchOdds.hand_2), for: UIControlState.normal)
		
		self.bott_15.setTitle(String(format: "%.2f", matchOdds.bott_15), for: UIControlState.normal)
		self.top_15.setTitle(String(format: "%.2f", matchOdds.top_15), for: UIControlState.normal)
		
		self.bott_35.setTitle(String(format: "%.2f", matchOdds.bott_35), for: UIControlState.normal)
		self.top_35.setTitle(String(format: "%.2f", matchOdds.top_35), for: UIControlState.normal)
		
		self.bott.setTitle(String(format: "%.2f", matchOdds.bott_25), for: UIControlState.normal)
		self.top.setTitle(String(format: "%.2f", matchOdds.top_25), for: UIControlState.normal)
		
		self.kgv.setTitle(String(format: "%.2f", matchOdds.opposingGoalYes), for: UIControlState.normal)
		self.kgy.setTitle(String(format: "%.2f", matchOdds.opposingGoalNo), for: UIControlState.normal)
		
		self.sog01.setTitle(String(format: "%.2f", matchOdds.sog01), for: UIControlState.normal)
		self.sog23.setTitle(String(format: "%.2f", matchOdds.sog23), for: UIControlState.normal)
		self.sog46.setTitle(String(format: "%.2f", matchOdds.sog46), for: UIControlState.normal)
		self.sog7.setTitle(String(format: "%.2f", matchOdds.sog7), for: UIControlState.normal)
		
		self.iyms_11.setTitle(String(format: "%.2f", matchOdds.iyms_11), for: UIControlState.normal)
		self.iyms_x1.setTitle(String(format: "%.2f", matchOdds.iyms_x1), for: UIControlState.normal)
		self.iyms_21.setTitle(String(format: "%.2f", matchOdds.iyms_21), for: UIControlState.normal)
		self.iyms_1x.setTitle(String(format: "%.2f", matchOdds.iyms_1x), for: UIControlState.normal)
		self.iyms_2x.setTitle(String(format: "%.2f", matchOdds.iyms_2x), for: UIControlState.normal)
		self.iyms_xx.setTitle(String(format: "%.2f", matchOdds.iyms_xx), for: UIControlState.normal)
		self.iyms_22.setTitle(String(format: "%.2f", matchOdds.iyms_22), for: UIControlState.normal)
		self.iyms_x2.setTitle(String(format: "%.2f", matchOdds.iyms_x2), for: UIControlState.normal)
		self.iyms_12.setTitle(String(format: "%.2f", matchOdds.iyms_12), for: UIControlState.normal)
		
	}
	
	private func getSelectedButtonFromTag(tagIdx: Int) -> UIButton? {
	
		switch(tagIdx) {
		case 1:
			return self.result_1
		case 2:
			return self.result_x
		case 3:
			return self.result_2
		case 4:
			return self.halfTime_1
		case 5:
			return self.halfTime_x
		case 6:
			return self.halfTime_2
		case 7:
			return self.doubleChance_1_x
		case 8:
			return self.doubleChance_x_2
		case 9:
			return self.doubleChance_1_2
		case 10:
			return self.hand_1
		case 11:
			return self.hand_x
		case 12:
			return self.hand_2
		case 13:
			return self.bott_15
		case 14:
			return self.top_15
		case 15:
			return self.bott_35
		case 16:
			return self.top_35
		case 17:
			return self.bott
		case 18:
			return self.top
		case 19:
			return self.kgv
		case 20:
			return self.kgy
		case 21:
			return self.sog01
		case 22:
			return self.sog23
		case 23:
			return self.sog46
		case 24:
			return self.sog7
		case 25:
			return self.iyms_11
		case 26:
			return self.iyms_x1
		case 27:
			return self.iyms_21
		case 28:
			return self.iyms_1x
		case 29:
			return self.iyms_2x
		case 30:
			return self.iyms_xx
		case 31:
			return self.iyms_22
		case 32:
			return self.iyms_x2
		case 33:
			return self.iyms_12
		default:
			return nil
		}
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		
		if text == "\n" {
			self.textView.resignFirstResponder()
			return false
		}
		
		return true
	}
	
	@IBAction func btnSendTapped(sender: UIButton) {
		
		guard self.delegate != nil else {
			
			return
		}
		
		guard (self.selectedButton != -1) else {
			
			return
		}
		
		let selectedForecastVal: String
		switch(self.selectedButton) {
		case 1:
			selectedForecastVal = "1"
			break
		case 2:
			selectedForecastVal = "X"
			break
		case 3:
			selectedForecastVal = "2"
			break
		case 4:
			selectedForecastVal = "IY1"
			break
		case 5:
			selectedForecastVal = "IYX"
			break
		case 6:
			selectedForecastVal = "IY2"
			break
		case 7:
			selectedForecastVal = "1X"
			break
		case 8:
			selectedForecastVal = "X2"
			break
		case 9:
			selectedForecastVal = "12"
			break
		case 10:
			selectedForecastVal = "H1"
			break
		case 11:
			selectedForecastVal = "HX"
			break
		case 12:
			selectedForecastVal = "H2"
			break
		case 13:
			selectedForecastVal = "IY15Alt"
			break
		case 14:
			selectedForecastVal = "IY15Üst"
			break
		case 15:
			selectedForecastVal = "35Alt"
			break
		case 16:
			selectedForecastVal = "35Üst"
			break
		case 17:
			selectedForecastVal = "Alt"
			break
		case 18:
			selectedForecastVal = "Üst"
			break
		case 19:
			selectedForecastVal = "KGV"
			break
		case 20:
			selectedForecastVal = "KGY"
			break
		case 21:
			selectedForecastVal = "GS01"
			break
		case 22:
			selectedForecastVal = "GS23"
			break
		case 23:
			selectedForecastVal = "GS46"
			break
		case 24:
			selectedForecastVal = "GS7P"
			break
		case 25:
			selectedForecastVal = "SF11"
			break
		case 26:
			selectedForecastVal = "SFX1"
			break
		case 27:
			selectedForecastVal = "SF21"
			break
		case 28:
			selectedForecastVal = "SF1X"
			break
		case 29:
			selectedForecastVal = "SF2X"
			break
		case 30:
			selectedForecastVal = "SFXX"
			break
		case 31:
			selectedForecastVal = "SF22"
			break
		case 32:
			selectedForecastVal = "SFX2"
			break
		case 33:
			selectedForecastVal = "SF12"
			break
		default:
			selectedForecastVal = ""
			break
		}
		
		self.textView.resignFirstResponder()
		self.delegate?.createForecastBtnSendTapped(selectedForecastVal: selectedForecastVal, comment: self.textView.text)
	}
	
	@IBAction func oddsSelected(sender: UIButton) {
		
		if(self.selectedButton != sender.tag) {
			
			if let currentSelectedButton = self.getSelectedButtonFromTag(tagIdx: self.selectedButton) {
				
				currentSelectedButton.backgroundColor = defaultButtonColor
			}
			
			self.selectedButton = sender.tag
			sender.backgroundColor = selectedButtonColor
		}
	}
}
