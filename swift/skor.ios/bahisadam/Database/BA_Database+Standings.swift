//
//  BA_Database+Standings.swift
//  bahisadam
//
//  Created by ilker özcan on 29/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import CoreData
import BahisadamLive

extension BA_Database {
	
	func getAllStandingsForLeague(leagueId: Int, groupCode: Int, handler: @escaping BA_DatabaseAsyncResponse) {
		
		if let lastStandingsUpdate = self.getApiUpdate(apiName: BA_DatabaseTTLs.HomeAwayStandingsApi.name) {
			
			let currentTimeInterval = Int(Date().timeIntervalSince1970)
			let lastStandingsUpdateInterval = Int((lastStandingsUpdate.lastUpdateDate?.timeIntervalSince1970)!)
			
			if(lastStandingsUpdateInterval + BA_DatabaseTTLs.HomeAwayStandingsApi.ttl < currentTimeInterval) {
				
				self.getAllStandingsListFromServer(leagueId: leagueId, handler: handler)
			}else{
				
				DispatchQueue.main.async {
					
					let fetchRequest: NSFetchRequest<AllStandings> = AllStandings.fetchRequest()
					fetchRequest.predicate = NSPredicate(format: "groupCode = %i AND standingType = %i AND league.leagueId = %i", groupCode, DB_STANDING_TYPES.ALL.rawValue, leagueId)
					let sortDescPTS = NSSortDescriptor(key: "standingPTS", ascending: false)
					let sortDescAVG = NSSortDescriptor(key: "standingAVG", ascending: false)
					fetchRequest.sortDescriptors = [sortDescPTS, sortDescAVG]
				
					do {
					
						let response = try self.managedObjectContext?.fetch(fetchRequest)
						let responseData = response! as [AllStandings]
					
						if(response?.count == 0) {
							
							self.getAllStandingsListFromServer(leagueId: leagueId, handler: handler)
						}else{
							
							var standings: [BA_Standings] = [BA_Standings]()
							
							for standingsInDb in responseData {
								
								var currentStanding = BA_Standings(groupCode: standingsInDb.groupCode, teamName: (standingsInDb.teamName ?? ""), teamId: standingsInDb.teamId, standingAG: standingsInDb.standingAG, standingAVG: standingsInDb.standingAVG, standingB: standingsInDb.standingB, standingG: standingsInDb.standingG, standingM: standingsInDb.standingM, standingOM: standingsInDb.standingOM, standingPTS: standingsInDb.standingPTS, standingYG: standingsInDb.standingYG)
								
								let standingLeague = BA_Leagues(leagueName: (standingsInDb.league?.leagueName ?? ""), leagueId: Int(standingsInDb.league?.leagueId ?? 0), leagueOrder: Int((standingsInDb.league?.leagueOrder ?? 0)))
								
								currentStanding.updateLeagueData(league: standingLeague)
								standings.append(currentStanding)
								
							}
							
							handler(true, standings as AnyObject?, nil, 200)
						}
					
					} catch _ {
					
						self.getAllStandingsListFromServer(leagueId: leagueId, handler: handler)
					}
				}
			}
			
		}else{
			
			self.getAllStandingsListFromServer(leagueId: leagueId, handler: handler)
		}
	}
	
	private func getAllStandingsListFromServer(leagueId: Int, handler: @escaping BA_DatabaseAsyncResponse) {
		
		let apiUrl = String(format: BA_Server.StandingsApi, leagueId)
		IO_NetworkHelper(getJSONRequest: apiUrl, completitionHandler: { (status, data, error, statusCode) in
			
			if(status) {
				
				if let dataArr = data as? [String: AnyObject] {
					
					let standings = self.configureAllStandingsListData(data: dataArr["standings"] as! [String : AnyObject])
					handler(status, standings as AnyObject?, error, statusCode)
					return
				}
			}
			
			handler(status, nil, error, statusCode)
		})
	}
	
	private func configureAllStandingsListData(data: [String : AnyObject]) -> [BA_Standings] {
		
		var standings: [BA_Standings] = [BA_Standings]()
		
		for (_, standingGroupVal) in data {
			
			let standingGroup = standingGroupVal as! [[String : AnyObject]]
			
			for standingObject in standingGroup {
			
				let groupCodeStr: String
				let teamId: Int64
				let leagueId: Int
				if let standingIdData = standingObject["_id"] as? [String: AnyObject] {
				
					groupCodeStr = standingIdData["group_code"] as? String ?? "0"
					teamId = standingIdData["team"] as? Int64 ?? 0
					leagueId = standingIdData["league"] as? Int ?? 0
				}else{
					groupCodeStr = "0"
					teamId = 0
					leagueId = 0
				}
			
				let teamName = standingObject["team_name_tr"] as? String ?? ""
				let standingAG = standingObject["AG"] as? Int32 ?? 0
				let standingAVG = standingObject["AVG"] as? Int32 ?? 0
				let standingB = standingObject["B"] as? Int32 ?? 0
				let standingG = standingObject["G"] as? Int32 ?? 0
				let standingM = standingObject["M"] as? Int32 ?? 0
				let standingOM = standingObject["OM"] as? Int32 ?? 0
				let standingPTS = standingObject["PTS"] as? Int32 ?? 0
				let standingYG = standingObject["YG"] as? Int32 ?? 0
				let groupCode = Int32(groupCodeStr) ?? 0
			
				var newStanding = BA_Standings(groupCode: groupCode, teamName: teamName, teamId: teamId, standingAG: standingAG, standingAVG: standingAVG, standingB: standingB, standingG: standingG, standingM: standingM, standingOM: standingOM, standingPTS: standingPTS, standingYG: standingYG)
			
				if let currentLeagueData = self.getLeagueFromId(id: leagueId) {
				
					let standingLeague = BA_Leagues(leagueName: (currentLeagueData.leagueName ?? ""), leagueId: Int(currentLeagueData.leagueId), leagueOrder: Int(currentLeagueData.leagueOrder))
					newStanding.updateLeagueData(league: standingLeague)
				
				}else{
				
					let standingLeague = BA_Leagues(leagueName: "", leagueId: leagueId, leagueOrder: 0)
					newStanding.updateLeagueData(league: standingLeague)
				}
				
				standings.append(newStanding)
			}
		}
		
		self.updateAllStandingsOnDatabase(standings: standings)
		return standings
	}
	
	private func updateAllStandingsOnDatabase(standings: [BA_Standings]) {
		
		self.dbQueue.sync {
			
			let lastUpdateDate = Date() as NSDate
			
			for currentStanding in standings {
				
				let newStandingData: AllStandings
				if let standingExistsInDb = self.getAllStandingFromId(teamId: currentStanding.teamId, groupCode: currentStanding.groupCode, leagueId: (currentStanding.league?.leagueId)!) {
					
					newStandingData = standingExistsInDb
				}else{
					
					newStandingData = NSEntityDescription.insertNewObject(forEntityName: "AllStandings", into: self.managedObjectContext!) as! AllStandings
					newStandingData.teamId = currentStanding.teamId
					newStandingData.groupCode = currentStanding.groupCode
					
					if let standingLeague = self.getLeagueFromId(id: (currentStanding.league?.leagueId ?? 0)) {
						
						newStandingData.league = standingLeague
					}else{
						
						let newLeagueData = NSEntityDescription.insertNewObject(forEntityName: "Leagues", into: self.managedObjectContext!) as! Leagues
						newLeagueData.leagueId = Int64((currentStanding.league?.leagueId ?? 0))
						newLeagueData.leagueName = ""
						newLeagueData.leagueOrder = 0
						newLeagueData.lastUpdateDate = lastUpdateDate
						newStandingData.league = newLeagueData
					}
				}
				
				newStandingData.teamName = currentStanding.teamName
				newStandingData.standingAG = currentStanding.standingAG
				newStandingData.standingAVG = currentStanding.standingAVG
				newStandingData.standingB = currentStanding.standingB
				newStandingData.standingG = currentStanding.standingG
				newStandingData.standingM = currentStanding.standingM
				newStandingData.standingOM = currentStanding.standingOM
				newStandingData.standingPTS = currentStanding.standingPTS
				newStandingData.standingYG = currentStanding.standingYG
				newStandingData.lastUpdateDate = lastUpdateDate
				newStandingData.standingType = DB_STANDING_TYPES.ALL.rawValue
				
			}
			
			self.saveContext()
			let standingsFetchRequest: NSFetchRequest<AllStandings> = AllStandings.fetchRequest()
			standingsFetchRequest.predicate = NSPredicate(format: "standingType = %i AND lastUpdateDate < %@", DB_STANDING_TYPES.ALL.rawValue, lastUpdateDate)
			do {
				
				if let willDeleteStandings = try self.managedObjectContext?.fetch(standingsFetchRequest) {
				
					for willDeleteStanding in willDeleteStandings {
						self.managedObjectContext?.delete(willDeleteStanding)
					}
					
				}
				self.saveContext()
				
			} catch _ {
			}
			
			self.updateApiUpdateDate(apiName: BA_DatabaseTTLs.HomeAwayStandingsApi.name)
		}
	}
	
	private func getAllStandingFromId(teamId: Int64, groupCode: Int32, leagueId: Int) -> AllStandings? {
		
		let fetchRequest: NSFetchRequest<AllStandings> = AllStandings.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "standingType = %i AND teamId = %i AND groupCode = %i AND league.leagueId = %i", DB_STANDING_TYPES.ALL.rawValue, teamId, groupCode, leagueId)
		
		do {
			
			let response = try self.managedObjectContext?.fetch(fetchRequest)
			let responseData = response! as [AllStandings]
			
			if(responseData.count > 0) {
				
				return responseData[0]
			}else{
				return nil
			}
			
		} catch _ {
			
			return nil
		}
	}
}
