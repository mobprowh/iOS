//
//  BA_Player.swift
//  bahisadam
//
//  Created by andrey on 3/18/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit

public struct BA_Players {
    
    public var playerId: String
    public var playerNic: String
    public var name: String
    public var lastName: String
    public var teamId: String
    public var playerCC: String
    public var teamName: String
    public var total: String
    public var year: String
    public var playerAlias: String
    public var teamAlias: String
    public var teamSheildUrl: String
    public var playerImageUrl: String
    public var teamFlagUrl: String
    
    public var playerDetailURLString: String {
        get {
            return "http://www.bahisadam.com/oyuncu/\(self.playerNic)/\(self.playerId)/istatistikler"
        }
    }
    
    public init(playerId: String, playerNic: String, name: String, lastName: String, teamId: String, playerCC: String, teamName: String, total: String, year: String, playerAlias: String, teamAlias: String, teamSheildUrl: String, playerImageUrl: String, teamFlagUrl: String) {
        
        self.playerId = playerId
        self.playerNic = playerNic
        self.name = name
        self.lastName = lastName
        self.teamId = teamId
        self.playerCC = playerCC
        self.teamName = teamName
        self.total = total
        self.year = year
        self.playerAlias = playerAlias
        self.teamAlias = teamAlias
        self.teamSheildUrl = teamSheildUrl
        self.playerImageUrl = playerImageUrl
        self.teamFlagUrl = teamFlagUrl
        
    }
    
    
    
}
