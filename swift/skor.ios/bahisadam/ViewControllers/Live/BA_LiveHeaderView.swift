//
//  BA_LiveHeaderView.swift
//  bahisadam
//
//  Created by ilker özcan on 25/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import FontAwesome_swift

class BA_LiveHeaderView: UITableViewHeaderFooterView {

	@IBOutlet var sectionContentView: UIView!
	@IBOutlet var leagueNameLabel: UILabel!
	@IBOutlet var leagueImage: UIImageView!
    @IBOutlet var leagueDetailButton: UIButton!
    
    var leagueId: Int = 0
    
    private var delegate: BA_LiveTableViewCellDelegate?
	
	var leagueNameVal: String = ""
	var leagueImageVal: String = ""
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override func removeFromSuperview() {
		
		super.removeFromSuperview()
	}

	func setupHeader(leagueId: Int, leagueName: String, leagueImageURL: String, delegate: BA_LiveTableViewCellDelegate) {
		
        self.delegate = delegate
		self.leagueNameVal = leagueName
		self.leagueImageVal = leagueImageURL
		self.leagueNameLabel.text = leagueName
        self.leagueId = leagueId
		UIImage.getWebImage(imageUrl: self.leagueImageVal) { (responseImage) in
			
			self.leagueImage.image = responseImage
		}
        
        self.leagueDetailButton.setTitle(FontAwesome.angleRight.rawValue, for: .normal)
	}
	
	func setupBorderMask() {
		
		self.layoutIfNeeded()
		let path = UIBezierPath(roundedRect:self.sectionContentView.bounds,
		                        byRoundingCorners:[.topLeft, .topRight],
		                        cornerRadii: CGSize(width: 8, height:  8))
		
		let maskLayer = CAShapeLayer()
		
		maskLayer.path = path.cgPath
		self.sectionContentView.layer.mask = maskLayer
	}
    
    func setupShadow() {
        self.layoutIfNeeded()
        self.sectionContentView.layer.shadowColor = UIColor.black.cgColor
        self.sectionContentView.layer.shadowOpacity = 0.2
        self.sectionContentView.layer.shadowOffset = CGSize.zero
        self.sectionContentView.layer.shadowRadius = 0.5
        self.sectionContentView.layer.masksToBounds = false
    }
    
    @IBAction func btnLeagueDetailTapped(_ sender: UIButton) {
        
        if(self.delegate != nil) {
            self.delegate?.leagueDetailTapped(leagueId: self.leagueId)
        }
    }
}
