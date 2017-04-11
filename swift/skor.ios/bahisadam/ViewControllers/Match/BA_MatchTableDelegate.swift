//
//  BA_MatchTableDelegate.swift
//  bahisadam
//
//  Created by ilker özcan on 23/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import BahisadamLive

protocol BA_MatchTableDelegate {
	
	func leagueDetailTapped(leagueId: Int)
	func matchDetailTapped(matchYear: Int, matchId: String, matchType: BA_Matc.MATCH_TYPES)
	func matchDetailTapped(matchId: String, matchType: BA_Matc.MATCH_TYPES)
    func favoritesTapped(matchId: String, isFavorite: Bool)
    func favoritesTapped(cell: UICollectionViewCell, matchId: String, isFavorite: Bool)
    
}
