//
//  BA_MatchDetailWhoWinsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 28/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_WhoWinsCellCollectionViewCellDelegate {
	
	func whoWinsCellTabBtnTapped(btnIdx: Int)
}

class BA_MatchDetailWhoWinsCollectionViewCell: UICollectionViewCell {
	
	private var delegate: BA_WhoWinsCellCollectionViewCellDelegate?

	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	func setupCell(delegate: BA_WhoWinsCellCollectionViewCellDelegate) {
		
		self.delegate = delegate
	}
	
	@IBAction func btnX1Tapped(sender: UIButton) {
		
		guard self.delegate != nil else {
			return
		}
		
		self.delegate!.whoWinsCellTabBtnTapped(btnIdx: 0)
	}
	
	@IBAction func btnXTapped(sender: UIButton) {
		
		guard self.delegate != nil else {
			return
		}
		
		self.delegate!.whoWinsCellTabBtnTapped(btnIdx: 1)
	}
	
	@IBAction func btnX2Tapped(sender: UIButton) {
		
		guard self.delegate != nil else {
			return
		}
		
		self.delegate!.whoWinsCellTabBtnTapped(btnIdx: 2)
	}
}
