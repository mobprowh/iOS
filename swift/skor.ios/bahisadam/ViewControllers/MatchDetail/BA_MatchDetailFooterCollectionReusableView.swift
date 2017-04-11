//
//  BA_MatchDetailFooterCollectionReusableView.swift
//  bahisadam
//
//  Created by ilker özcan on 27/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchDetailFooterCollectionReusableView: UICollectionReusableView {
	
	@IBOutlet var cellView: UIView!
	
	func setupCell() {

		self.layoutIfNeeded()
		let path = UIBezierPath(roundedRect: self.cellView.bounds,
		                        byRoundingCorners:[.bottomLeft, .bottomRight],
		                        cornerRadii: CGSize(width: 4, height:  4))
		
		let maskLayer = CAShapeLayer()
		
		maskLayer.path = path.cgPath
		self.cellView.layer.mask = maskLayer
	}
}
