//
//  BA_NoMatchTableViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 03/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import QuartzCore

class BA_NoMatchTableViewCell: UITableViewCell {

	@IBOutlet var clockArrow: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func setupCell() {
		
		clockArrow.layer.removeAllAnimations()
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
		rotationAnimation.toValue = M_2_PI
		rotationAnimation.duration = 2;
		rotationAnimation.isCumulative = true
		rotationAnimation.repeatCount = Float.infinity;
		rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
		clockArrow.layer.add(rotationAnimation, forKey: "transform.rotation.z")
		
		/*
		let options: UIViewAnimationOptions = [.repeat, .curveLinear]
		UIView.animate(withDuration: 30, delay: 0, options: options, animations: {
			
			//self.clockArrow.transform = CGAffineTransform(rotationAngle: 0.2)
			self.clockArrow.transform = CGAffineTransform(rotationAngle: CGFloat(-2 * M_PI))
		}) { (finished) in
				
		}
		*/
	}
}
