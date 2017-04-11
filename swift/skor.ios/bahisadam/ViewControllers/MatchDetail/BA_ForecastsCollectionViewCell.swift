//
//  BA_ForecastsCollectionViewCell.swift
//  bahisadam
//
//  Created by ilker özcan on 30/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_ForecastsCollectionViewCellDelegate {
	
	func btnLikeTapped(forecastId: String)
}

class BA_ForecastsCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var userScore: UILabel!
	@IBOutlet var userName: UILabel!
	@IBOutlet var forecastVal: UILabel!
	@IBOutlet var userComment: UILabel!
	@IBOutlet var likeButton: UIButton!
	
	private var cellForecastData: BA_MatcDetailForecasts?
	private var delegate: BA_ForecastsCollectionViewCellDelegate?
	
	func setupCell(forecastData: BA_MatcDetailForecasts, delegate: BA_ForecastsCollectionViewCellDelegate) {
		
		self.cellForecastData = forecastData
		self.delegate = delegate
		self.userScore.text = String(format: "%.1f", forecastData.userScore)
		self.userName.text = forecastData.userName
		self.forecastVal.text = forecastData.forecast
		self.userComment.text = forecastData.userComment
		
		if(BA_Database.SharedInstance.isLikedForecast(forecastId: forecastData.forecastId)) {
			
			self.likeButton.isEnabled = false
			self.likeButton.setTitle("\(forecastData.totalLike)", for: UIControlState.disabled)
		}else{
			
			self.likeButton.setTitle("\(forecastData.totalLike)", for: UIControlState.normal)
		}
	}

	override func removeFromSuperview() {
		
		self.delegate = nil
		super.removeFromSuperview()
	}
	
	@IBAction func btnLikeTapped(sender: UIButton) {
	
		guard (delegate != nil && cellForecastData != nil) else {
			return
		}
		
		self.cellForecastData?.totalLike += 1
		self.likeButton.isEnabled = false
		self.likeButton.setTitle("\(self.cellForecastData!.totalLike)", for: UIControlState.disabled)
		self.delegate?.btnLikeTapped(forecastId: (self.cellForecastData?.forecastId)!)
	}
}
