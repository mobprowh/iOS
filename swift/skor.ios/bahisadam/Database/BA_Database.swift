//
//  BA_Database.swift
//  bahisadam
//
//  Created by ilker özcan on 28/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import CoreData
import Dispatch

public typealias BA_DatabaseAsyncResponse = (_ success: Bool, _ data: AnyObject?, _ errorStr: String?, _ statusCode: Int) -> Void

public class BA_Database: IO_DataManagement {

	private static var Singleton: BA_Database!
	
	internal lazy var dbQueue = DispatchQueue(label: "com.bahisadam.BA_DatabaseQueue", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
	
	/// Core data helper class
	public override init(databaseName: String, databaseResourceName: String) {
		
		super.init(databaseName: databaseName, databaseResourceName: databaseResourceName)
		
		BA_Database.Singleton = self
	}
	
	/// Core data shared instance
	public override class var SharedInstance: BA_Database {
		
		if(BA_Database.Singleton == nil) {
			NSLog("\n-------------\nWarning!\n-------------\nData Management is not inited!\n")
			abort()
		}
		
		return BA_Database.Singleton
	}
	
	func isMatchVoted(matchId: String) -> Bool {
		
		let fetchRequest: NSFetchRequest<MatchVotes> = MatchVotes.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "matchId = %@", matchId)
		
		do {
			
			let responseData: [MatchVotes]
			//if #available(iOS 10.0, *) {
				
			//	responseData = try fetchRequest.execute()
			//} else {
				
				let fetchResponse = try self.managedObjectContext?.fetch(fetchRequest)
				responseData = fetchResponse! as [MatchVotes]
			//}
			
			if(responseData.count > 0) {
				
				return true
			}else{
				
				return false
			}
			
		} catch _ {
			//print(error.localizedDescription)
			return false
		}
		
	}
	
	func voteMatch(matchId: String, voteNum: Int16) {
		
		DispatchQueue.main.async {
			
			if let currentContext = self.managedObjectContext {
			
				let entity = NSEntityDescription.insertNewObject(forEntityName: "MatchVotes", into: currentContext) as! MatchVotes
				entity.matchId = matchId
				entity.vote = voteNum
			
				self.saveContext()
			}
		}
	}
	
	func getApiUpdate(apiName: String) -> ApiUpdates? {
		
		let fetchRequest: NSFetchRequest<ApiUpdates> = ApiUpdates.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "apiName = %@", apiName)
		
		do {
			
			let response = try self.managedObjectContext?.fetch(fetchRequest)
			let responseData = response! as [ApiUpdates]
			
			if(responseData.count > 0) {
					
				return responseData[0]
			}else{
				return nil
			}

		} catch _ {
			
			return nil
		}
	}
	
	func updateApiUpdateDate(apiName: String) {
		
		if let currentApiUpdate = self.getApiUpdate(apiName: apiName) {
			
			currentApiUpdate.lastUpdateDate = Date() as NSDate?
			
			self.saveContext()
			
		}else{
			
			let newApiUpdateEntity = NSEntityDescription.insertNewObject(forEntityName: "ApiUpdates", into: self.managedObjectContext!) as! ApiUpdates
			newApiUpdateEntity.apiName = apiName
			newApiUpdateEntity.lastUpdateDate = Date() as NSDate?
			
			self.saveContext()
		}
	}
}
