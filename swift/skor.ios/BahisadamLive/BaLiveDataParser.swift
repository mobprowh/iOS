//
//  BaLiveDataParser.swift
//  bahisadam
//
//  Created by ilker özcan on 09/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public struct LiveData {
	
	public let sectionCount: Int
	public let rowCounts: [Int]
	public let allLeagueData: [BA_Leagues]
}

public func ConfigureLiveData(data: Dictionary<String, AnyObject>) -> LiveData {

    var leagues: [UnsafeMutablePointer<BA_Leagues>] = [UnsafeMutablePointer<BA_Leagues>]()
    
    if let matches = data["data"]!["matches"] as? [Dictionary<String, AnyObject>] {
        
        for match in matches  {
            
            if let leagueData = match["league_id"] as? Dictionary<String, AnyObject> {
                
                let matchId = match["_id"] as? String ?? ""
                
                let leagueId = leagueData["_id"] as? Int ?? 0
                let leagueDataIndex = leagues.index { (data) -> Bool in
                    
                    if(data.pointee.leagueId == leagueId) {
                        
                        return true
                    }else{
                        return false
                    }
                }
                
                let leagueDataPointerPP: UnsafeMutablePointer<BA_Leagues>
                if(leagueDataIndex != nil) {
                    
                    leagueDataPointerPP = leagues[leagueDataIndex!]
                }else{
                    let leagueOrder = leagueData["order"] as? Int ?? 0
                    let leagueName = leagueData["league_name_tr"] as? String ?? ""
                    let newLeague = BA_Leagues(leagueName: leagueName, leagueId: leagueId, leagueOrder: leagueOrder)
                    leagueDataPointerPP = UnsafeMutablePointer<BA_Leagues>.allocate(capacity: MemoryLayout<BA_Leagues>.size)
                    leagueDataPointerPP.initialize(to: newLeague)
                    leagues.append(leagueDataPointerPP)
                }
                
                let homeTeamData: BA_Team
                if let homeTeam = match["home_team"] as? Dictionary<String, AnyObject> {
                    
                    let teamName = homeTeam["team_name_tr"] as? String ?? ""
                    let teamId: Int
                    if let idfield = homeTeam["id"] as? String {
                        
                        teamId = Int(idfield)!
                    }else{
                        teamId = homeTeam["id"] as? Int ?? 0
                    }
                    let color1 = homeTeam["color1"] as? String ?? ""
                    let color2 = homeTeam["color2"] as? String ?? ""
                    
                    homeTeamData = BA_Team(teamName: teamName, teamId: teamId, color1: color1, color2: color2)
                    
                }else{
                    homeTeamData = BA_Team(teamName: "", teamId: 0, color1: "", color2: "")
                }
                
                let awayTeamData: BA_Team
                if let awayTeam = match["away_team"] as? Dictionary<String, AnyObject> {
                    
                    let teamName = awayTeam["team_name_tr"] as? String ?? ""
                    let teamId: Int
                    if let idfield = awayTeam["id"] as? String {
                        
                        teamId = Int(idfield)!
                    }else{
                        teamId = awayTeam["id"] as? Int ?? 0
                    }
                    let color1 = awayTeam["color1"] as? String ?? ""
                    let color2 = awayTeam["color2"] as? String ?? ""
                    
                    awayTeamData = BA_Team(teamName: teamName, teamId: teamId, color1: color1, color2: color2)
                    
                }else{
                    awayTeamData = BA_Team(teamName: "", teamId: 0, color1: "", color2: "")
                }
                
                let matchDate = match["match_date"] as? String ?? BA_DateFormat(date: nil)
                var bets = [String]()
                if let odds = match["odds"] as? Dictionary<String, AnyObject> {
                    
                    if let iddaa = odds["iddaa"] as? Dictionary<String, AnyObject> {
                        
                        if let tx1 = iddaa["1"] as? String {
                            
                            bets.append(tx1)
                            
                        }else if let tx1 = iddaa["1"] as? Float {
                            
                            bets.append("\(tx1)")
                            
                        }else if let tx1 = iddaa["1"] as? Int {
                            
                            bets.append("\(tx1)")
                        }
                        
                        if let tx2 = iddaa["X"] as? String {
                            
                            bets.append(tx2)
                        }else if let tx2 = iddaa["X"] as? Float {
                            
                            bets.append("\(tx2)")
                            
                        }else if let tx2 = iddaa["X"] as? Int {
                            
                            bets.append("\(tx2)")
                        }
                        
                        if let tx3 = iddaa["2"] as? String {
                            
                            bets.append(tx3)
                            
                        }else if let tx3 = iddaa["2"] as? Float {
                            
                            bets.append("\(tx3)")
                            
                        }else if let tx3 = iddaa["2"] as? Int {
                            
                            bets.append("\(tx3)")
                        }
                    }
                }
                
                let resultType = match["result_type"] as? String ?? "NotPlayed"
                
                // ignore if it is not live match
                if resultType != "Playing" {
                    leagues.remove(at: leagues.index(of: leagueDataPointerPP)!)
                    continue
                }
                
                let homeGoals = match["home_goals"] as? Int ?? 0
                let awayGoals = match["away_goals"] as? Int ?? 0
                let matchYear = match["year"] as? Int ?? 2017
                let halfTimeHomeGoals = match["half_time_home_score"] as? Int ?? 0
                let halfTimeAwayGoals = match["half_time_away_score"] as? Int ?? 0
                let currentMinutes = match["live_minute"] as? Int ?? 0
                let matchData = BA_Matc(homeTeam: homeTeamData, awayTeam: awayTeamData, matchDateStr: matchDate!, bets: bets, resultType: resultType, homeGoals: homeGoals, awayGoals: awayGoals, matchId: matchId, matchYear: matchYear, halfTimeHomeGoals: halfTimeHomeGoals, halfTimeAwayGoals: halfTimeAwayGoals, currentMinutes: currentMinutes)
                
                leagueDataPointerPP.pointee.addMatch(match: matchData)
            }
        }
    }
    ////
    ////
    
    
	let allLeagueData = leagues.sorted { (d1, d2) -> Bool in
		
		if(d1.pointee.leagueOrder < d2.pointee.leagueOrder) {
			return true
		}else{
			return false
		}
	}
	
	let sectionCount = allLeagueData.count
	var rowCounts = [Int]()
	
	for leagueData in allLeagueData {
		
		rowCounts.append(leagueData.pointee.matches.count)
	}
    
    var leaguesData = [BA_Leagues]()
    
    for league in allLeagueData {
        leaguesData.append(league.pointee)
    }
	
	return LiveData(sectionCount: sectionCount, rowCounts: rowCounts, allLeagueData: leaguesData)
}
