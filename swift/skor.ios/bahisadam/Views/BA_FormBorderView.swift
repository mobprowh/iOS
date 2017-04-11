//
//  BA_FormBorderView.swift
//  bahisadam
//
//  Created by ilker özcan on 01/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

@IBDesignable
class BA_FormBorderView: UIImageView {
	
	@IBInspectable var templateTintColor: UIColor! {
		
		didSet {
			
			self.setNeedsLayout()
		}
	}
	
	private var templateImageVal: Int!
	
	@IBInspectable var templateImage: Int {
	
		get {
			return templateImageVal
		}
		
		set {
			
			self.templateImageVal = newValue
		}
	}
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
	// Drawing code
	}
	*/

	override func layoutSubviews() {
	
		super.layoutSubviews()
		self.tintColor = templateTintColor
	}
	
}
