//
//  IO_UIView.swift
//  bahisadam
//
//  Created by ilker özcan on 24/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIView {

	@IBInspectable var borderColor:UIColor? {
		set {
			layer.borderColor = newValue!.cgColor
		}
		get {
			if let color = layer.borderColor {
				return UIColor(cgColor:color)
			}
			else {
				return nil
			}
		}
	}
	@IBInspectable var borderWidth:CGFloat {
		set {
			self.layoutIfNeeded()
			layer.borderWidth = newValue
		}
		get {
			return layer.borderWidth
		}
	}
	@IBInspectable var cornerRadius:CGFloat {
		set {
			self.layoutIfNeeded()
			layer.cornerRadius = newValue
			clipsToBounds = newValue > 0
		}
		get {
			return layer.cornerRadius
		}
	}
}

#if os(iOS)
	/// uiview cntroller extensions
	extension UIViewController {
		
		/// Present modal view right to left animation
		public func IO_presentViewControllerWithCustomAnimation(_ viewControllerToPresent: UIViewController!) {
			
			let screenSizeWidth							= UIScreen.main.bounds.size.width
			let startTransition							= CGAffineTransform(translationX: screenSizeWidth, y: 0)
			viewControllerToPresent.view.isHidden			= true
			self.present(viewControllerToPresent, animated: false, completion: { () -> Void in
				
				viewControllerToPresent.view.isHidden			= false
				viewControllerToPresent.view.transform		= startTransition
				let destinationTransform					= CGAffineTransform(translationX: 0, y: 0)
				UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.05, options: [], animations: { () -> Void in
					
					viewControllerToPresent.view.transform	= destinationTransform
				}, completion: { finished in
					
					viewControllerToPresent.view.transform	= destinationTransform
				})
				
			})
		}
		
		/// Dismiss modal view right to left animation
		public func IO_dismissViewControllerWithCustomAnimation() {
			
			let screenSizeWidth							= UIScreen.main.bounds.size.width
			let destinationTransform					= CGAffineTransform(translationX: screenSizeWidth, y: 0)
			
			UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.05, options: [], animations: { () -> Void in
				
				self.view.transform					= destinationTransform
			}, completion: { finished in
				
				self.view.transform					= destinationTransform
				self.dismiss(animated: false, completion: nil)
			})
			
		}
	}
#endif
