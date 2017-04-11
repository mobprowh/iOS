//
//  InterfaceController.swift
//  watch Extension
//
//  Created by ilker özcan on 10/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import WatchKit
import Foundation
import WKBahisadamLive

class InterfaceController: WKInterfaceController {

	@IBOutlet var tableView: WKInterfaceTable!
	
	private enum MATCH_LIST_STATUSES {
		case LOADING
		case LISTING
		case NO_MATCHES
	}
	
	private var tableStatus = MATCH_LIST_STATUSES.LOADING
	private var sectionCount = 0
	private var rowCounts: [Int]!
	private var allLeagueData: [BA_Leagues]?
	private var sumOfRowCount = 0
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		self.tableStatus = MATCH_LIST_STATUSES.LOADING
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		self.setTableStatus(newStatus: .LOADING)
		self.loadData()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
	
	private func setTableStatus(newStatus: MATCH_LIST_STATUSES) {
		
		if(newStatus == .LOADING) {
			
			self.tableStatus = MATCH_LIST_STATUSES.LOADING
			self.tableView.setNumberOfRows(0, withRowType: "BA_liveTableRow")
			self.tableView.setNumberOfRows(0, withRowType: "BA_NoMatchRow")
			self.tableView.setNumberOfRows(1, withRowType: "BA_LoadingMatchesRow")
			
		}else if(newStatus == .NO_MATCHES) {
			
			self.tableStatus = MATCH_LIST_STATUSES.NO_MATCHES
			self.tableView.setNumberOfRows(0, withRowType: "BA_liveTableRow")
			self.tableView.setNumberOfRows(1, withRowType: "BA_NoMatchRow")
			self.tableView.setNumberOfRows(0, withRowType: "BA_LoadingMatchesRow")
			
		}else if(newStatus == .LISTING) {
			
			self.tableStatus = MATCH_LIST_STATUSES.LISTING
			self.tableView.setNumberOfRows(0, withRowType: "BA_NoMatchRow")
			self.tableView.setNumberOfRows(0, withRowType: "BA_LoadingMatchesRow")
			self.tableView.setNumberOfRows(self.sumOfRowCount, withRowType: "BA_liveTableRow")
			
			var currentRow = 0
			for leagueData in self.allLeagueData! {
				
				for matchData in leagueData.matches {
					
					let cell = self.tableView.rowController(at: currentRow) as! BA_LiveMatchItem
					cell.setupCell(matchData: matchData)
					currentRow += 1
				}
			}
		}
	}
	
	private func loadData(withoutHud noHud: Bool = false) {
		
		IO_NetworkHelper(getJSONRequest: BA_Server.LiveApi, completitionHandler: { (status, data, error, statusCode) in
			
			if(status) {
				
				if let dataDict = data as? Dictionary<String, AnyObject> {
					
					self.configureData(data: dataDict)
				}
			}
		})
	}

	private func configureData(data: Dictionary<String, AnyObject>) {
		
		let liveData = ConfigureLiveData(data: data)
		self.sectionCount = liveData.sectionCount
		self.rowCounts = liveData.rowCounts
		self.allLeagueData = liveData.allLeagueData
		
		self.sumOfRowCount = 0
		for rowData in self.rowCounts {
			
			self.sumOfRowCount += rowData
		}
		
		if(self.sumOfRowCount == 0) {
			
			setTableStatus(newStatus: .NO_MATCHES)
		}else{
			setTableStatus(newStatus: .LISTING)
		}
	}
}
