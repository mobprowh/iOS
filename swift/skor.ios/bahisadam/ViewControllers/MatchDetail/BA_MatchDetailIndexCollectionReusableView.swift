//
//  BA_MatchDetailIndexCollectionReusableView.swift
//  bahisadam
//
//  Created by ilker özcan on 27/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchDetailIndexCollectionReusableView: UICollectionReusableView {
	
	@IBOutlet var cellView: UIView!
	@IBOutlet var cellTitle: UILabel!
	
	func setupCell(title: String) {
		
		self.cellTitle.text = title
		
		self.layoutIfNeeded()
        self.cellView.layer.shadowColor = UIColor.black.cgColor
        self.cellView.layer.shadowOpacity = 0.2
        self.cellView.layer.shadowOffset = CGSize.zero
        self.cellView.layer.shadowRadius = 0.5
        self.cellView.layer.masksToBounds = false
	}
}
