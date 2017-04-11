//
//  BA_Database+CountryLeagues.swift
//  bahisadam
//
//  Created by ilker özcan on 29/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import CoreData
import BahisadamLive

extension BA_Database {

	func getCountryList(handler: @escaping BA_DatabaseAsyncResponse) {
		
		if let lastCountryListUpdate = self.getApiUpdate(apiName: BA_DatabaseTTLs.StatsApi.name) {
			
			let currentTimeInterval = Int(Date().timeIntervalSince1970)
			let lastCountryUpdateInterval = Int((lastCountryListUpdate.lastUpdateDate?.timeIntervalSince1970)!)
			
			if(lastCountryUpdateInterval + BA_DatabaseTTLs.StatsApi.ttl < currentTimeInterval) {
				
				self.getCountyListFromServer(handler: handler)
			}else{
				
				DispatchQueue.main.async {
				
					let fetchRequest: NSFetchRequest<Countries> = Countries.fetchRequest()
					let sortDesc = NSSortDescriptor(key: "countryOrder", ascending: true)
					//let leagueSortDesc = NSSortDescriptor(key: "leagues.leagueOrder", ascending: true)
					fetchRequest.sortDescriptors = [sortDesc]
					
					do {
						
						let response = try self.managedObjectContext?.fetch(fetchRequest)
						let responseData = response! as [Countries]
						
						var countries: [BA_Countries] = [BA_Countries]()
						
						for countryInDb in responseData {
							
							var currentCountry = BA_Countries(countryId: Int(countryInDb.countryId), countryName: countryInDb.country ?? "", countryCode: countryInDb.countryCode ?? "", countryOrder: Int(countryInDb.countryOrder))
							
							countryInDb.leagues?.enumerateObjects({ (element, idx, stop) in
								
								let leagueData = element as! Leagues
								let leagueInCountry = BA_Leagues(leagueName: leagueData.leagueName ?? "", leagueId: Int(leagueData.leagueId), leagueOrder: Int(leagueData.leagueOrder))
								currentCountry.addLeague(league: leagueInCountry)
							})
							
							countries.append(currentCountry)
						}
						
						handler(true, countries as AnyObject?, nil, 200)
						
					} catch _ {
						
						self.getCountyListFromServer(handler: handler)
					}
				}
			}
			
		}else{
			
			self.getCountyListFromServer(handler: handler)
		}
	}
	
	private func getCountyListFromServer(handler: @escaping BA_DatabaseAsyncResponse) {
		
		IO_NetworkHelper(getJSONRequest: BA_Server.StatsApi, completitionHandler: { (status, data, error, statusCode) in
			
			if(status) {
				
				if let dataArr = data as? [Dictionary<String, AnyObject>] {
					
					let countries = self.configureCountryListData(data: dataArr)
					handler(status, countries as AnyObject?, error, statusCode)
					return
				}
			}
			
			handler(status, nil, error, statusCode)
		})
	}
	
	private func configureCountryListData(data: [Dictionary<String, AnyObject>]) -> [BA_Countries] {
		
		var countries: [BA_Countries] = [BA_Countries]()
		
		for countryObject in data {
			
			let countryId = countryObject["_id"] as? Int ?? 0
			let countryName = countryObject["country_name_tr"] as? String ?? ""
			let countryCode = countryObject["country_code"] as? String ?? ""
			let countryOrder = countryObject["order"] as? Int ?? 0
			var newCountry = BA_Countries(countryId: countryId, countryName: countryName, countryCode: countryCode, countryOrder: countryOrder)
			
			if let leagues = countryObject["leagues"] as? [Dictionary<String, AnyObject>] {
				
				for leagueData in leagues {
					
					let leagueId = leagueData["_id"] as? Int ?? 0
					let leagueName = leagueData["league_name_tr"] as? String ?? ""
					let leagueOrder = leagueData["order"] as? Int ?? 0
					let newLeague = BA_Leagues(leagueName: leagueName, leagueId: leagueId, leagueOrder: leagueOrder)
					newCountry.addLeague(league: newLeague)
				}
				
			}
			
			if(newCountry.leagues.count > 0) {
				
				countries.append(newCountry)
			}
		}
		
		let allCountries = countries.sorted { (d1, d2) -> Bool in
			
			if(d1.countryOrder < d2.countryOrder) {
				return true
			}else{
				return false
			}
		}
		
		self.updateCountriesOnDatabase(countries: allCountries)
		return allCountries
	}
	
	private func updateCountriesOnDatabase(countries: [BA_Countries]) {
		
		self.dbQueue.async {
			
			let lastUpdateDate = Date() as NSDate
			
			for currentCountry in countries {
				
				let newCountryData: Countries
				if let countryExistsInDb = self.getCountryFromId(id: currentCountry.countryId) {
					
					newCountryData = countryExistsInDb
				}else{
					
					newCountryData = NSEntityDescription.insertNewObject(forEntityName: "Countries", into: self.managedObjectContext!) as! Countries
					newCountryData.countryId = Int64(currentCountry.countryId)
				}
				
				newCountryData.country = currentCountry.countryName
				newCountryData.countryCode = currentCountry.countryCode
				newCountryData.countryOrder = Int32(currentCountry.countryOrder)
				newCountryData.lastUpdateDate = lastUpdateDate
				
				for currentLeague in currentCountry.leagues {
					
					let newLeagueData: Leagues
					if let leagueExistsInDatabase = self.getLeagueFromId(id: currentLeague.leagueId) {
						
						newLeagueData = leagueExistsInDatabase
					}else{
					
						newLeagueData = NSEntityDescription.insertNewObject(forEntityName: "Leagues", into: self.managedObjectContext!) as! Leagues
						newLeagueData.leagueId = Int64(currentLeague.leagueId)
					}
					
					newLeagueData.leagueName = currentLeague.leagueName
					newLeagueData.leagueOrder = Int32(currentLeague.leagueOrder)
					newLeagueData.lastUpdateDate = lastUpdateDate
					newCountryData.addToLeagues(newLeagueData)
				}
				
			}
			
			self.saveContext()
			let leaguesFetchRequest: NSFetchRequest<Leagues> = Leagues.fetchRequest()
			leaguesFetchRequest.predicate = NSPredicate(format: "lastUpdateDate < %@", lastUpdateDate)
			do {
				
				if let willDeleteLeagues = try self.managedObjectContext?.fetch(leaguesFetchRequest) {
				
					for willDeleteLeague in willDeleteLeagues {
						self.managedObjectContext?.delete(willDeleteLeague)
					}
					
					self.saveContext()
				}
				
			} catch _ {
			}
			
			let countriesFetchRequest: NSFetchRequest<Countries> = Countries.fetchRequest()
			countriesFetchRequest.predicate = NSPredicate(format: "lastUpdateDate < %@", lastUpdateDate)
			do {
				
				if let willDeleteCountries = try self.managedObjectContext?.fetch(countriesFetchRequest) {
				
					for willDeleteCountry in willDeleteCountries {
						self.managedObjectContext?.delete(willDeleteCountry)
					}
					
					self.saveContext()
				}
			} catch _ {
			}
			
			self.updateApiUpdateDate(apiName: BA_DatabaseTTLs.StatsApi.name)
		}
	}
	
	private func getCountryFromId(id: Int) -> Countries? {
		
		let fetchRequest: NSFetchRequest<Countries> = Countries.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "countryId = %i", id)
		
		do {
			
			let response = try self.managedObjectContext?.fetch(fetchRequest)
			let responseData = response! as [Countries]
			
			if(responseData.count > 0) {
				
				return responseData[0]
			}else{
				return nil
			}
			
		} catch _ {
			
			return nil
		}
	}
	
	internal func getLeagueFromId(id: Int) -> Leagues? {
		
		let fetchRequest: NSFetchRequest<Leagues> = Leagues.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "leagueId = %i", id)
		
		do {
			
			let response = try self.managedObjectContext?.fetch(fetchRequest)
			let responseData = response! as [Leagues]
			
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
