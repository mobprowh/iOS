//
//  BA_MatchDetailMenuCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 24/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_MatchDetailMenuCollectionViewCellDelegate {
    func cell(_ cell: BA_MatchDetailMenuCollectionViewCell, tappedIndex: Int)
}

class BA_MatchDetailMenuCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var tabNameButton: UIButton!
	
	private var delegate: BA_MatchDetailMenuCollectionViewCellDelegate?
	private var itemIdx: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabNameButton.contentEdgeInsets = UIEdgeInsetsMake(-0.5, 0, 0, 0);
    }
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	func setupCell(item: BA_MatchDetailMenus, delegate: BA_MatchDetailMenuCollectionViewCellDelegate?) {
		
		self.itemIdx = item.menuIDx
		self.delegate = delegate
		self.tabNameButton.setTitle(item.menuName, for: UIControlState.normal)
	}
	
	func setSelected() {
		
		self.tabNameButton.isSelected = true
        
        addBorder()
	}
	
	func setUnselected() {
		
		self.tabNameButton.isSelected = false
        
        removeBorder()
	}
    
    func addBorder() {
        let borderHeight = CGFloat(6.0)
        let border = CALayer()
        border.backgroundColor = UIColor.white.cgColor
        border.frame = CGRect.init(x: 0.0, y: self.bounds.size.height - borderHeight, width: self.bounds.size.width, height: borderHeight)
        border.name = "border"
        self.layer.addSublayer(border)
    }
    
    func removeBorder() {
        let border = self.layer.sublayers?.first(where: {$0.name == "border"})
        border?.removeFromSuperlayer()
    }
	
	@IBAction func tabNameButtonTapped(sender: UIButton) {
		
		guard delegate != nil else {
			
			return
		}
		
//		delegate?.itemTapped(itemNumber: self.itemIdx)
        
        delegate?.cell(self, tappedIndex: self.itemIdx)
	}
}
