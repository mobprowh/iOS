//
//  BA_DatabaseTTL.swift
//  bahisadam
//
//  Created by ilker özcan on 29/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

struct BA_DatabaseTTL {
	
	let name: String
	let ttl: Int
	
}

struct BA_DatabaseTTLs {
	
	// 3 hours
	static let StatsApi = BA_DatabaseTTL(name: "StatsApi", ttl: 10800)
	
	// 6 hours
	static let AllStandingsApi = BA_DatabaseTTL(name: "AllStandingsApi", ttl: 21600)
	
	// 6 hours
	static let HomeAwayStandingsApi = BA_DatabaseTTL(name: "HomeAwayStandingsApi", ttl: 21600)
}
