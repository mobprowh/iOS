//
//  BA_MatchDetailNewForecastCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 21/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_MatchDetailNewForecastDelegate {
	
	func newForecastButtonTapped()
}

class BA_MatchDetailNewForecastCollectionViewCell: UICollectionViewCell {
	
	private var delegate: BA_MatchDetailNewForecastDelegate?
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	func setupCell(delegate: BA_MatchDetailNewForecastDelegate) {
		
		self.delegate = delegate
	}
	
	@IBAction func cellButtonTapped(sender: UIButton) {
		
		guard self.delegate != nil else {
			
			return
		}
		
		self.delegate?.newForecastButtonTapped()
	}
}
