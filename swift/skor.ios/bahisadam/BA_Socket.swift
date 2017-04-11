//
//  BA_Socket.swift
//  bahisadam
//
//  Created by ilker özcan on 17/01/2017.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import Foundation
import SocketIO
import BahisadamLive
import Dispatch

protocol BA_SocketDelegate {
	
	func socketDataChanged(leagueId: Int, matchId: String, homeGoals: Int, awayGoals: Int, halfTimeHomeGoals: Int, halfTimeAwayGoals: Int, resultType: String, liveMinute: Int)
}

class BA_Socket {
	
	private let SocketQueue = DispatchQueue(label: "com.bahisadam.socketQueue", qos: DispatchQoS.userInteractive, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
	
	private var SocketClient: SocketIOClient?
	private var _isConnected = false
	
	private var socketListeners: Dictionary<Int, BA_SocketDelegate?>?
	private var currentListenerIdx = 0
	
	class var sharedInstance : BA_Socket {
		
		struct Singleton {
			
			static let instance = BA_Socket()
		}
		
		return Singleton.instance
	}
	
	init() {

		self.socketListeners = Dictionary<Int, BA_SocketDelegate>()
		
	#if DEBUG
		self.SocketClient = SocketIOClient(socketURL: URL(string: BA_Server.BaseUrl)!, config: [.log(true), .forceWebsockets(false), .forceNew(true), .reconnects(true)])
	#else
		self.SocketClient = SocketIOClient(socketURL: URL(string: BA_Server.BaseUrl)!, config: [.forceWebsockets(false), .forceNew(true), .reconnects(true)])
	#endif
		
		self.startListening()
	}
	
	private func startListening() {
		
		self.SocketClient?.on("connect") { data, ack in
			
			#if DEBUG
				print("Socket: connected! \(data)")
			#endif
			
			self._isConnected = true
		}
		
		self.SocketClient?.on("disconnect") { data, ack in
			
			#if DEBUG
				print("Socket: disconnect! \(data)")
			#endif
			
			self._isConnected = false
		}
		
		self.SocketClient?.on("livescores_updated") { data, ack in
			
			#if DEBUG
				print("livescores_updated \(data)")
			#endif
			
			if let scores = data[0] as? [String : AnyObject] {
				
				self.updateListeners(updatedData: scores)
			}
		}
		
	}
	
	func Connect() {
		
		if(!self._isConnected) {
			
			self.SocketClient?.connect()
		}
	}
	
	func Disconnect() {
		
		if(self._isConnected) {
			
			self.SocketClient?.disconnect()
		}
	}
	
	func addListener(listener: BA_SocketDelegate, socketIdx: Int?) -> Int {
		
		guard self.socketListeners != nil else {
			
			let callIdx: Int
			if(socketIdx == nil) {
				
				self.currentListenerIdx += 1
				callIdx = self.currentListenerIdx
			}else{
				callIdx = socketIdx!
			}
			
			self.SocketQueue.asyncAfter(deadline: .now() + .milliseconds(150), execute: {
				
				let _ = self.addListener(listener: listener, socketIdx: callIdx)
			})
			
			return self.currentListenerIdx
		}
		
		if(socketIdx == nil) {
			
			self.currentListenerIdx += 1
			self.socketListeners?[self.currentListenerIdx] = listener
			
			return self.currentListenerIdx
		}else{
			
			self.socketListeners?[socketIdx!] = listener
			
			return socketIdx!
		}
	}
	
	func removeListener(index: Int) {
		
		let _ = self.socketListeners?.removeValue(forKey: index)
	}
	
	private func updateListeners(updatedData: [String : AnyObject]) {
		
		self.SocketQueue.async {
			
			if let scores = updatedData["scores"] as? [String : AnyObject] {
				
				for scoreData in scores {
					
					if let league = scoreData.value as? [String : AnyObject] {
						
						let leagueId = league["id"] as? Int ?? 0
						
						if let matches = league["matches"] as? [[String : AnyObject]] {
							
							for matchData in matches {
								
								let matchId = matchData["_id"] as? String ?? ""
								let homeGoals = matchData["home_goals"] as? Int ?? 0
								let awayGoals = matchData["away_goals"] as? Int ?? 0
								let halfTimeHomeGoals = matchData["half_time_home_score"] as? Int ?? 0
								let halfTimeAwayGoals = matchData["half_time_away_score"] as? Int ?? 0
								let resultType = matchData["result_type"] as? String ?? ""
								let liveMinute = matchData["live_minute"] as? Int ?? 0
								
								self.callDelegate(leagueId: leagueId, matchId: matchId, homeGoals: homeGoals, awayGoals: awayGoals, halfTimeHomeGoals: halfTimeHomeGoals, halfTimeAwayGoals: halfTimeAwayGoals, resultType: resultType, liveMinute: liveMinute)
							}
						}
					}
				}
			}
		}
	}
	
	private func callDelegate(leagueId: Int, matchId: String, homeGoals: Int, awayGoals: Int, halfTimeHomeGoals: Int, halfTimeAwayGoals: Int, resultType: String, liveMinute: Int) {
		
		
		for delegate in self.socketListeners! {
			
			if(delegate.value != nil) {
				
				DispatchQueue.main.async {
					
					delegate.value?.socketDataChanged(leagueId: leagueId, matchId: matchId, homeGoals: homeGoals, awayGoals: awayGoals, halfTimeHomeGoals: halfTimeHomeGoals, halfTimeAwayGoals: halfTimeAwayGoals, resultType: resultType, liveMinute: liveMinute)
				}
			}
		}
	}
}
