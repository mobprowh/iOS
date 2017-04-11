//
//  BA_FakeTabBarViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 18/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import BahisadamLive
import FontAwesome_swift

@IBDesignable
public class BA_FakeTabBarView: UIView, UITabBarDelegate {

	@IBOutlet var currentTabBarLastTabImage: UITabBarItem!
    
    @IBOutlet var favoriteItem: UITabBarItem!

	var contentView : UIView?
	var delegate: BA_FakeTabBarViewDelegate?
	
	private var currentRegion: String = "tr"
	
	override public init(frame: CGRect) {
		
		super.init(frame: frame)
		xibSetup()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		
		super.init(coder: aDecoder)
		xibSetup()
	}
	
	private func xibSetup() {
		
		self.contentView = loadViewFromNib()
		
		// use bounds not frame or it'll be offset
		/*self.contentView?.frame = self.bounds
		*/
		
		guard self.contentView != nil else {
			
			return
		}
		
		self.addSubview(self.contentView!)
	}
	
	func loadViewFromNib() -> UIView! {
		
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
		
		return view
	}
    
    func setupLoggedIn() {
        let color = UIColor.init(colorLiteralRed: 50.0/255.0, green: 184.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        favoriteItem.title = "Favorilerim"
        favoriteItem.image = UIImage.fontAwesomeIcon(name: FontAwesome.starO, textColor: color, size: CGSize(width: 37, height: 37))
        favoriteItem.selectedImage = UIImage.fontAwesomeIcon(name: FontAwesome.star, textColor: color, size: CGSize(width: 37, height: 37))
    }
	
	override public func willMove(toWindow newWindow: UIWindow?) {
		
		super.willMove(toWindow: newWindow)
		
		if let region = IO_Helpers.deviceLocale {
			
			self.currentRegion = region
			if(self.currentRegion == "az") {
				
				currentTabBarLastTabImage.image = UIImage(named: "league_logo_az")
				currentTabBarLastTabImage.selectedImage = UIImage(named: "league_logo_az")
			}
		}
	}
	
	public func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		
		guard delegate != nil else {
			
			return
		}
		
		delegate?.fakeTabBarItemSelected(tabBarItemNumber: item.tag)
	}
	
}
