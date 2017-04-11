//
//  BA_MatchDetailStadiumCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 27/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchDetailStadiumCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var stadiumImage: UIImageView!
	@IBOutlet var stadiumName: UILabel!
	@IBOutlet var stadiumCapacity: UILabel!
	@IBOutlet var stadiumFans: UILabel!
	@IBOutlet var stadiumYearBuilt: UILabel!
	
	func setupCell(matchDetailData: UnsafeMutablePointer<BA_MatchDetailData>?) {
		
		self.stadiumName.text = matchDetailData?.pointee.stadiumName
		self.stadiumCapacity.text = matchDetailData?.pointee.stadiumCapacity
		self.stadiumFans.text = matchDetailData?.pointee.stadiumFans
		self.stadiumYearBuilt.text = matchDetailData?.pointee.stadiumYearBuilt
		
		guard matchDetailData?.pointee.stadiumImageUrl != nil else {
			return
		}
		
		UIImage.getWebImage(imageUrl: (matchDetailData?.pointee.stadiumImageUrl)!) { (responseImage) in
			
			self.stadiumImage.image = responseImage
		}
	}
}
