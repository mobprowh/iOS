//
//  MatchDateCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 21/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class MatchDateCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var dayNameLabel: UILabel!
	@IBOutlet weak var dayButton: UIButton!
	
	private var tapGestureRecognizer: UITapGestureRecognizer!
	private var delegate: MatchDateCollectionViewCellDelegate?
	private var dayValue: Int!
	private var startDate: Date?
	
	func setupView(dayName: String, day: String, delegate: MatchDateCollectionViewCellDelegate?, startDate: Date?, isCurrentDay: Bool = false) {
		
		self.delegate = delegate
		self.startDate = startDate
		
		if(self.reuseIdentifier! == "dateViewSubdate") {
			
			self.dayValue = Int(day)!
			self.dayNameLabel.text = dayName
			self.dayButton.setTitle(day, for: UIControlState.normal)
			self.dayButton.isSelected = false
            self.dayNameLabel.textColor = UIColor.white

			if(isCurrentDay) {
				
				self.dayButton.setTitle(day, for: UIControlState.selected)
				self.dayButton.isSelected = true
                self.dayNameLabel.textColor = UIColor.init(colorLiteralRed: 48.0/255.0, green: 228.0/255.0, blue: 98.0/255.0, alpha: 1.0)
			}
			self.contentView.layoutIfNeeded()
		}
		
		self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapGestureTapped(sender:)))
		self.contentView.addGestureRecognizer(self.tapGestureRecognizer)
	}
	
	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	private func changeDate() {
		
		guard self.delegate != nil else {
			return
		}
		
		if(self.reuseIdentifier! == "dateViewSubdate") {
			
			self.delegate!.MatchDateCollectionViewCellDateSelected(atDay: self.startDate!)
		}else if(self.reuseIdentifier! == "dateViewSubdatePicker") {
			
			self.delegate!.MatchDateCollectionViewCellDatePickerSelected()
		}
	}
	
	public func cellTapGestureTapped(sender: UITapGestureRecognizer?) -> Void {
		
		self.changeDate()
	}
	
	@IBAction func btnDateTapped(sender: UIButton) {
		
		self.changeDate()
	}
}
