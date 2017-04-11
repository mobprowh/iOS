//
//  BA_MatchDetailData.swift
//  bahisadam
//
//  Created by ilker özcan on 25/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit
import BahisadamLive

struct BA_MatchStats {
	
	// % Ball control
	let pos: Float
	let foul: Float
	let shot: Float
	let shotOnTarget: Float
	let missedShot: Float
	let rescue: Float
	let freeKick: Float
	let corner: Float
	let offSide: Float
}

struct BA_MatchEvents {
	
	enum EventTypes: String {
		
		case None = ""
		case YellowCard = "YellowCard"
		case RedCard = "RedCard"
		case Goal = "Goal"
		case Asist = "Asist"
		case Substitution = "Substitution"
	}
	
	enum EventTeam: Int {
		case Home = 0
		case Away = 1
	}
	
	let type: EventTypes
	let team: EventTeam
	let playerName: String
	let playerSrId: String
	let minute: Int
	let substitutionAction: Int
	
	init(eventType: String, homeTeamId: Int, awayTeamId: Int, eventTeamId: Int, playerName: String, playerSrId: String, minute: Int, substitutionAction: Int = 0) {
		
		if(eventType == EventTypes.YellowCard.rawValue) {
			
			self.type = EventTypes.YellowCard
			
		}else if(eventType == EventTypes.RedCard.rawValue) {
			
			self.type = EventTypes.RedCard
			
		}else if(eventType == EventTypes.Goal.rawValue) {
			
			self.type = EventTypes.Goal
			
		}else if(eventType == EventTypes.Asist.rawValue) {
			
			self.type = EventTypes.Asist
		
		}else if(eventType == EventTypes.Substitution.rawValue) {
			
			self.type = EventTypes.Substitution
			
		}else{
			
			self.type = EventTypes.None
		}
		
		if(eventTeamId == homeTeamId) {
			
			self.team = EventTeam.Home
		}else{
			
			self.team = EventTeam.Away
		}
		
		self.playerName = playerName
		self.playerSrId = playerSrId
		self.minute = minute
		self.substitutionAction = substitutionAction
	}
	
}

struct BA_MatchOdds {
	
	let result_1: Float
	let result_x: Float
	let result_2: Float
	
	let halfTime_1: Float
	let halfTime_x: Float
	let halfTime_2: Float
	
	let doubleChance_1_x: Float
	let doubleChance_x_2: Float
	let doubleChance_1_2: Float
	
	let hand_1: Float
	let hand_x: Float
	let hand_2: Float
	
	let bott_15: Float
	let top_15: Float
	
	let bott_25: Float
	let top_25: Float
	
	let bott_35: Float
	let top_35: Float
	
	let htbott_15: Float
	let httop_15: Float
	
	let sog01: Float
	let sog23: Float
	let sog46: Float
	let sog7: Float
	
	let opposingGoalYes: Float
	let opposingGoalNo: Float
	
	let iyms_11: Float
	let iyms_x1: Float
	let iyms_21: Float
	let iyms_1x: Float
	let iyms_2x: Float
	let iyms_xx: Float
	let iyms_22: Float
	let iyms_x2: Float
	let iyms_12: Float
}

struct BA_Player {
	
	let jerseyNumber: Int
	let playerId: String
	let playerName: String
	let playerPos: String
}

struct BA_MatchDetailData {
	
	var matchId: String
	
	var homeTeamColor1: String?
	var homeTeamColor2: String?
	var homeTeamName: String?
	
	var awayTeamColor1: String?
	var awayTeamColor2: String?
	var awayTeamName: String?
	
	var stadiumName: String?
	var stadiumImageUrl: String?
	var stadiumCapacity: String?
	var stadiumFans: String?
	var stadiumYearBuilt: String?
	
	var homeTeamForecast: Int?
	var awayTeamForecast: Int?
	var drawForecast: Int?
	
	var leagueId: Int?
	var leagueName: String?
	
	var homeTeamId: Int?
	var awayTeamId: Int?
	
	var isPlayed = false
	var isPlaying = false
	var homeGoals = 0
	var awayGoals = 0
    var halfTimeAwayGoals = 0
    var halfTimeHomeGoals = 0
	var liveMinute = 0
	var matchDate: Date?
	
	var homeTeamStanding: BA_Standings?
	var homeTeamPos: Int?
	var awayTeamStanding: BA_Standings?
	var awayTeamPos: Int?
	
	var homeTeamInsidePos: Int?
	var homeTeamInsideStanding: BA_Standings?
	
	var homeTeamOutsidePos: Int?
	var homeTeamOutsideStandings: BA_Standings?
	
	var awayTeamInsidePos: Int?
	var awayTeamInsideStanding: BA_Standings?
	
	var awayTeamOutsidePos: Int?
	var awayTeamOutsideStandings: BA_Standings?
	
	var homeTeamLastMatches: [BA_Matc]?
	var homeTeamHomeMatches: [BA_Matc]?
	var homeTeamAwayMatches: [BA_Matc]?
	
	var awayTeamLastMatches: [BA_Matc]?
	var awayTeamHomeMatches: [BA_Matc]?
	var awayTeamAwayMatches: [BA_Matc]?
	
	var headToHeadMatches: [BA_Matc]?
	
	var homeTeamAverageStats: BA_MatchStats?
	var awayTeamAverageStats: BA_MatchStats?
	
	var homeTeamMatchStats: BA_MatchStats?
	var awayTeamMatchStats: BA_MatchStats?
	
	var matchEvents: [BA_MatchEvents]?
	
	var odds: BA_MatchOdds?
	
	var homeTeamLineups: [BA_Player]?
	var homeTeamSubstitutesLineups: [BA_Player]?
	
	var awayTeamLineups: [BA_Player]?
	var awayTeamSubstitutesLineups: [BA_Player]?

	#if os(iOS)
	public var homeTeamUIColor1: UIColor {
		
		get {
			return self.stringToColor(stringColor: self.homeTeamColor1!)
		}
	}
	
	public var homeTeamUIColor2: UIColor {
		
		get {
			return self.stringToColor(stringColor: self.homeTeamColor2!)
		}
	}
	
	public var awayTeamUIColor1: UIColor {
		
		get {
			return self.stringToColor(stringColor: self.awayTeamColor1!)
		}
	}
	
	public var awayTeamUIColor2: UIColor {
		
		get {
			return self.stringToColor(stringColor: self.awayTeamColor2!)
		}
	}
	#endif
    
    public var homeTeamLogoURLString: String {
        get {
            if let teamid = homeTeamId {
                return "http://static.bahisadam.com/images/logo/teams/\(teamid)_logo.png"
            } else {
                return ""
            }
        }
    }
    
    public var awayTeamLogoURLString: String {
        get {
            if let teamid = awayTeamId {
                return "http://static.bahisadam.com/images/logo/teams/\(teamid)_logo.png"
            } else {
                return ""
            }
        }
    }
	
	init(matchId: String) {
		
		self.matchId = matchId
	}
	
	#if os(iOS)
	private func stringToColor(stringColor: String) -> UIColor {
		
		let hexColorString: String
		
		if(stringColor.characters.count >= 7) {
			
			let stringStartIndex = stringColor.index(stringColor.startIndex, offsetBy: 1)
			hexColorString = stringColor.substring(from: stringStartIndex)
		}else{
			hexColorString = "FFFFFF"
		}
		
		var hexInt: UInt32 = 0
		let scanner = Scanner(string: hexColorString)
		scanner.scanHexInt32(&hexInt)
		let color = UIColor(
			red: CGFloat((hexInt & 0xFF0000) >> 16)/225,
			green: CGFloat((hexInt & 0xFF00) >> 8)/225,
			blue: CGFloat((hexInt & 0xFF))/225,
			alpha: 1)
		
		return color
	}
	#endif
	
	
}
