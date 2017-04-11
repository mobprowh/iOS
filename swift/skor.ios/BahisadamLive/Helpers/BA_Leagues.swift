//
//  BA_Match.swift
//  bahisadam
//
//  Created by ilker özcan on 21/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit

public struct BA_Team {
	
	public var teamName: String
	public var teamId: Int
#if os(iOS)
	public var color1: UIColor!
	public var color2: UIColor!
#endif
    
    public var teamLogoURLString: String {
        get {
            return "http://static.bahisadam.com/images/logo/teams/\(self.teamId)_logo.png"
        }
    }
	
	public init(teamName: String, teamId: Int, color1: String, color2: String) {
		
		self.teamName = teamName
		self.teamId = teamId
		
	#if os(iOS)
		self.color1 = self.stringToColor(stringColor: color1)
		self.color2 = self.stringToColor(stringColor: color2)
	#endif
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

public struct BA_Matc {
	
	public enum MATCH_TYPES: String {
		case Playing = "Playing"
		case Played = "Played"
		case NotPlayed = "NotPlayed"
	}
	
	public var homeTeam: BA_Team
	public var awayTeam: BA_Team
	public var matchDate: Date?
	public var bets: [String]
	public var homeGoals: Int
	public var awayGoals: Int
	public var matchType: MATCH_TYPES
	public var matchId: String
	public var matchYear: Int
	public var halfTimeHomeGoals: Int
	public var halfTimeAwayGoals: Int
	public var currentMinutes: Int
	public var currentLiveMinutes: String?
    public var isFavorite = false
	
	public init(homeTeam: BA_Team, awayTeam: BA_Team, matchDateStr: String, bets: [String], resultType: String, homeGoals: Int, awayGoals: Int, matchId: String, matchYear: Int, halfTimeHomeGoals: Int, halfTimeAwayGoals: Int, currentMinutes: Int) {
		
		self.homeTeam = homeTeam
		self.awayTeam = awayTeam
		self.matchDate = BA_DateFormat(string: matchDateStr)
		self.bets = bets
		self.homeGoals = homeGoals
		self.awayGoals = awayGoals
		self.matchId = matchId
		self.matchYear = matchYear
		self.halfTimeHomeGoals = halfTimeHomeGoals
		self.halfTimeAwayGoals = halfTimeAwayGoals
		self.currentMinutes = currentMinutes
        self.currentLiveMinutes = "\(currentMinutes)"
		
		switch resultType {
		case "Playing":
			self.matchType = MATCH_TYPES.Playing
			break
		case "Played":
			self.matchType = MATCH_TYPES.Played
			break
		default:
			self.matchType = MATCH_TYPES.NotPlayed
			break
		}
	}
	
	public init(homeTeam: BA_Team, awayTeam: BA_Team, resultType: String, homeGoals: Int, awayGoals: Int, matchId: String, matchYear: Int, currentMinutes: String) {
		
		self.homeTeam = homeTeam
		self.awayTeam = awayTeam
		self.matchDate = nil
		self.bets = [String]()
		self.homeGoals = homeGoals
		self.awayGoals = awayGoals
		self.matchId = matchId
		self.matchYear = matchYear
		self.halfTimeHomeGoals = 0
		self.halfTimeAwayGoals = 0
		self.currentMinutes = Int(currentMinutes) ?? 0
		self.currentLiveMinutes = currentMinutes
		
		switch resultType {
		case "Playing":
			self.matchType = MATCH_TYPES.Playing
			break
		case "Played":
			self.matchType = MATCH_TYPES.Played
			break
		default:
			self.matchType = MATCH_TYPES.NotPlayed
			break
		}
	}
}

public struct BA_Leagues {
	
	public var leagueName: String
	public var leagueId: Int
	public var leagueOrder: Int
	public var matches: [BA_Matc]
	
	public var customLogoUrl: String?
	
	private let logoUrlFormat = "http://static.bahisadam.com/images/logo/leagues/%d_logo.png"
	public var logoUrl: String {
		
		get {
			
			if(self.customLogoUrl == nil) {
				
				return String(format: self.logoUrlFormat, self.leagueId)
			}else{
				
				return self.customLogoUrl!
			}
		}
	}
	
	public init(leagueName: String, leagueId: Int, leagueOrder: Int) {
		
		self.leagueName = leagueName
		self.leagueId = leagueId
		self.leagueOrder = leagueOrder
		self.matches = [BA_Matc]()
	}
	
	public init(leagueName: String, leagueId: Int, leagueOrder: Int, customLogo: String) {
		
		self.leagueName = leagueName
		self.leagueId = leagueId
		self.leagueOrder = leagueOrder
		self.matches = [BA_Matc]()
		self.customLogoUrl = customLogo
	}
	
	public mutating func addMatch(match: BA_Matc) {
		
		self.matches.append(match)
	}
}

public struct BA_Countries {
	
	public var countryId: Int
	public var countryName: String
	public var countryCode: String
	public var countryOrder: Int
	public var leagues: [BA_Leagues]
	
	public init(countryId: Int, countryName: String, countryCode: String, countryOrder: Int) {
		
		self.countryId = countryId
		self.countryName = countryName
		self.countryCode = countryCode
		self.countryOrder = countryOrder
		self.leagues = [BA_Leagues]()
	}
	
	public mutating func addLeague(league: BA_Leagues) {
		
		self.leagues.append(league)
	}
}

public struct BA_Standings {
	
	public var groupCode: Int32
	public var teamName: String
	public var teamId: Int64
	public var standingAG: Int32
	public var standingAVG: Int32
	public var standingB: Int32
	public var standingG: Int32
	public var standingM: Int32
	public var standingOM: Int32
	public var standingPTS: Int32
	public var standingYG: Int32
	public var league: BA_Leagues?
	
	public init(groupCode: Int32, teamName: String, teamId: Int64, standingAG: Int32, standingAVG: Int32, standingB: Int32, standingG: Int32, standingM: Int32, standingOM: Int32, standingPTS: Int32, standingYG: Int32) {
		
		self.groupCode = groupCode
		self.teamName = teamName
		self.teamId = teamId
		self.standingAG = standingAG
		self.standingAVG = standingAVG
		self.standingB = standingB
		self.standingG = standingG
		self.standingM = standingM
		self.standingOM = standingOM
		self.standingPTS = standingPTS
		self.standingYG = standingYG
	}
	
	public mutating func updateLeagueData(league: BA_Leagues) {
		
		self.league = league
	}
}
