//
//  BA_MatchDetailMenus.swift
//  bahisadam
//
//  Created by ilker özcan on 08/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

struct BA_MatchDetailMenus {
	
	enum BA_MatchDetailMenuTypes {
		case INDEX
		case MATCHES
		case LINEUPS
		case STATS
		case ODDS
		case CREATE_FORECAST
	}
	
	let type: BA_MatchDetailMenuTypes
	let menuIDx: Int
	let menuName: String
}

let BA_CurrentMatchDetailMenus: [BA_MatchDetailMenus] = [

	BA_MatchDetailMenus(type: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.INDEX, menuIDx: 0, menuName: "Detay"),
	BA_MatchDetailMenus(type: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.MATCHES, menuIDx: 1, menuName: "Maçlar"),
	BA_MatchDetailMenus(type: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.LINEUPS, menuIDx: 2, menuName: "Kadrolar"),
	BA_MatchDetailMenus(type: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.STATS, menuIDx: 3, menuName: "İstatistik"),
	BA_MatchDetailMenus(type: BA_MatchDetailMenus.BA_MatchDetailMenuTypes.ODDS, menuIDx: 4, menuName: "İddaa")
]

func BA_CurrentMatchDetailMenusIdx(forType: BA_MatchDetailMenus.BA_MatchDetailMenuTypes) -> Int {
	
	if(forType == .CREATE_FORECAST) {
		return 99
	}
	
	var retval: Int?
	for matchDetailMenu in BA_CurrentMatchDetailMenus {
		
		if(matchDetailMenu.type == forType) {
			
			retval = matchDetailMenu.menuIDx
			break
		}
	}
	
	guard retval != nil else {
		
		return 0
	}
	
	return retval!
}
