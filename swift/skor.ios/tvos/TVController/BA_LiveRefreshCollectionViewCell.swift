//
//  BA_LiveRefreshCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 13/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_LiveRefreshCollectionViewCellDelegate {
	
	func refreshStart()
}

class BA_LiveRefreshCollectionViewCell: UICollectionViewCell {
	
	private var delegate: BA_LiveRefreshCollectionViewCellDelegate?
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	func setupCell(delegate: BA_LiveRefreshCollectionViewCellDelegate) {
		
		self.delegate = delegate
	}
	
	func updateCellLayout() {
		
		self.layoutIfNeeded()
	}
	
	@IBAction func btnRefreshPressed(sender: UIButton) {
		
		guard self.delegate != nil else {
			return
		}
		
		self.delegate!.refreshStart()
	}
}
