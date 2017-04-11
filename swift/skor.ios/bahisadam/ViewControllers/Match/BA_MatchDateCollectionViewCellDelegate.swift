//
//  MatchDateCollectionViewCellDelegate.swift
//  bahisadam
//
//  Created by ilker özcan on 21/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

protocol MatchDateCollectionViewCellDelegate {
	
	func MatchDateCollectionViewCellDateSelected(atDay: Date)
	func MatchDateCollectionViewCellDatePickerSelected()
}
