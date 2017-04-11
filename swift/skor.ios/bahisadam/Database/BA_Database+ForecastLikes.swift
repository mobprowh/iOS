//
//  BA_Database+ForecastLikes.swift
//  bahisadam
//
//  Created by ilker özcan on 30/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import CoreData

extension BA_Database {
	
	func isLikedForecast(forecastId: String) -> Bool {
		
		let likedRequest: NSFetchRequest<ForecastLikes> = ForecastLikes.fetchRequest()
		likedRequest.predicate = NSPredicate(format: "forecastId = %@", forecastId)
		
		do {
			
			let likeData = (try self.managedObjectContext?.fetch(likedRequest))! as [ForecastLikes]
			if(likeData.count > 0) {
				return true
			}else{
				return false
			}
			
		} catch _ {
			return false
		}
	}
	
	func likeForecast(forecastId: String) {
		
		self.dbQueue.sync {
			
			let newForecastData = NSEntityDescription.insertNewObject(forEntityName: "ForecastLikes", into: self.managedObjectContext!) as! ForecastLikes
			newForecastData.forecastId = forecastId
			newForecastData.likeDate = NSDate()
			
			self.saveContext()
		}
	}
}
