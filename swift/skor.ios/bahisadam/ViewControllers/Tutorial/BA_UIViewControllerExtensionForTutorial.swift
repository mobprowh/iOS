//
//  BA_UIViewControllerExtensionForTutorial.swift
//  bahisadam
//
//  Created by ilker özcan on 26/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit

#if os(iOS)
	/// uiview controller extensions
	extension BA_TutorialViewController {
		
		public func BA_presentTutorialViewController(viewControllerToPresent: UIViewController!, navigationViewController: UINavigationController) {
			
			let screenSizeWidth = UIScreen.main.bounds.size.width
			let startTransition = CGAffineTransform(translationX: -screenSizeWidth, y: 0)
			viewControllerToPresent.view.isHidden = true
			
			navigationViewController.present(viewControllerToPresent, animated: false, completion: { () -> Void in
				
				viewControllerToPresent.view.isHidden = false
				viewControllerToPresent.view.transform = startTransition
				let destinationTransform = CGAffineTransform(translationX: 0, y: 0)
				let navigationViewDestinationTransition = CGAffineTransform(translationX: screenSizeWidth, y: 0)
				
				UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.05, options: [], animations: { () -> Void in
					
					viewControllerToPresent.view.transform	= destinationTransform
					navigationViewController.view.transform = navigationViewDestinationTransition
				}, completion: { finished in
						
					viewControllerToPresent.view.transform	= destinationTransform
					navigationViewController.view.transform = navigationViewDestinationTransition
				})
				
			})
		}
		
		/// Dismiss modal view right to left animation
		public func BA_dismissTutorialViewController(navigationView: UIView) {
			
			let screenSizeWidth = UIScreen.main.bounds.size.width
			let navigationDestinationTransition = CGAffineTransform(translationX: 0, y: 0)
			let destinationTransform = CGAffineTransform(translationX: -screenSizeWidth, y: 0)
			
			UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.05, options: [], animations: { () -> Void in
				
				self.view.transform	= destinationTransform
				navigationView.transform = navigationDestinationTransition
			}, completion: { finished in
					
				self.view.transform = destinationTransform
				navigationView.transform = navigationDestinationTransition
				self.dismiss(animated: false, completion: nil)
			})
			
		}
	}
#endif
