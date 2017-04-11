//
//  BA_MatchOddsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 05/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchOddsCollectionViewCell: UICollectionViewCell {
	
	enum Ba_MatchOddsCellTypes: Int {
		
		case DUAL = 2
		case TRIO = 3
		case QUART = 4
	}
	
	@IBOutlet var cellProgressBar: [BA_CircleProgressView]!
	@IBOutlet var cellProgress: [UILabel]!
	@IBOutlet var cellNames: [UILabel]!
	
	func setupCell(cellType: Ba_MatchOddsCellTypes, names: [String], data: [Float]) {
		
		let sumOfData = data.reduce(0, +)
		
		for i in 0..<cellType.rawValue {
			
			cellNames[i].text = names[i]
			cellProgress[i].text = String(format: "%.2f", data[i])
			
			let barData = data[i] / sumOfData
			cellProgressBar[i].setProgress(progress: Double(barData), animationduration: 1)
		}
	}
}
