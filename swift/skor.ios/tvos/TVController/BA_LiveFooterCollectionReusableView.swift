//
//  BA_LiveFooterCollectionReusableView.swift
//  bahisadam
//
//  Created by ilker özcan on 12/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_LiveFooterCollectionReusableView: UICollectionReusableView {
	
	@IBOutlet var sectionContentView: UIView!
	
	func setupFooter() {
		
		self.layoutIfNeeded()
		let path = UIBezierPath(roundedRect:self.sectionContentView.bounds,
		                        byRoundingCorners:[.bottomRight, .bottomLeft],
		                        cornerRadii: CGSize(width: 16, height:  16))
		
		let maskLayer = CAShapeLayer()
		
		maskLayer.path = path.cgPath
		self.sectionContentView.layer.mask = maskLayer
	}
}
