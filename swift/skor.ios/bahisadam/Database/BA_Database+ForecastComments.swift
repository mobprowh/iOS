//
//  BA_Database+Standings.swift
//  bahisadam
//
//  Created by ilker özcan on 29/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import CoreData

extension BA_Database {
	
	func isMatchCommented(matchId: String) -> Bool {
		
		let fetchRequest: NSFetchRequest<ForecastComments> = ForecastComments.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "matchId = %@", matchId)
		
		do {
			
			let response = try self.managedObjectContext?.fetch(fetchRequest)
			let responseData = response! as [ForecastComments]
			
			if(responseData.count > 0) {
				
				return true
			}else{
				return false
			}
			
		} catch _ {
			
			return false
		}
	}
	
	func addForecastComment(matchId: String) {
		
		self.dbQueue.sync {
			
			let newForecastCommentData = NSEntityDescription.insertNewObject(forEntityName: "ForecastComments", into: self.managedObjectContext!) as! ForecastComments
			
			newForecastCommentData.matchId = matchId
			newForecastCommentData.commentDate = Date() as NSDate
			self.saveContext()
			
		}
	}
}
