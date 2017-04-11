//
//  TodayViewController.swift
//  livewidget
//
//  Created by ilker özcan on 09/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import NotificationCenter
import BahisadamLive

fileprivate let maxItemCount = 8
fileprivate let openMatchDetailUrl = "com.bahisadam://openMatchDetail/%d/%@"
fileprivate let openLiveUrl = "com.bahisadam://openLiveTab"

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource, BA_LiveWidgetDelegate {
	
	@IBOutlet var widgetCollectionView: UICollectionView!
	
	private var sectionCount = 0
	private var rowCounts = [Int]()
	private var allLeagueData: [BA_Leagues]?
	private var sumOfRowCount: Int = 0
	private var isDisplayingNoMatchCell = false
	private var collectionViewLayoutClass: BA_MatchListCollectionViewLayout?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
		
		self.collectionViewLayoutClass = self.widgetCollectionView.collectionViewLayout as? BA_MatchListCollectionViewLayout
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func widgetPerformUpdate(completionHandler: @escaping ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
		
		IO_NetworkHelper(getJSONRequest: BA_Server.LiveApi, completitionHandler: { (status, data, error, statusCode) in
			
			if(status) {
				
				if let dataDict = data as? Dictionary<String, AnyObject> {
					
					self.configureData(data: dataDict)
					completionHandler(NCUpdateResult.newData)
					return
				}
			}
			
			completionHandler(NCUpdateResult.noData)
		})
		
    }
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		if(sumOfRowCount > maxItemCount) {
			
			return maxItemCount
		}
		
		return self.sumOfRowCount
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if(self.isDisplayingNoMatchCell) {
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "baNoLiveMatchView", for: indexPath)
			return cell
			
		}else{
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "baWidgetLiveMatch", for: indexPath) as! BA_LiveWidgetCollectionViewCell
			var currentLeague = 0
			var currentIdx = 0
			var currentRow = 0
			var parentBreak = false
		
			for currentRowCountIdx in 0..<sectionCount {
			
				currentIdx = 0
				for _ in 0..<self.rowCounts[currentRowCountIdx] {
				
					if(currentRow == indexPath.item) {
					
						parentBreak = true
						break
					}
				
					currentRow += 1
					currentIdx += 1
				}
			
				if(parentBreak) {
					break
				}
				currentLeague += 1
			}
		
			let matchData = self.allLeagueData?[currentLeague].matches[currentIdx]
			let scoreData = "\(matchData!.homeGoals) - \(matchData!.awayGoals)"
			cell.setupCell(team1Name: matchData!.homeTeam.teamName, team2Name: matchData!.awayTeam.teamName, score: scoreData, matchYear: matchData!.matchYear, matchId: matchData!.matchId, delegate: self)
			return cell
		}
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
		
		if(self.sumOfRowCount > 0) {
			
			self.collectionViewLayoutClass?.layoutMode = .MULTIPLE_CELLS
			self.isDisplayingNoMatchCell = false
			
		}else{
			
			self.collectionViewLayoutClass?.layoutMode = .ONE_CELL
			self.isDisplayingNoMatchCell = true
			self.sumOfRowCount = 1
		}
		
		self.widgetCollectionView.reloadData()
	}
	
	func openMatchDetail(matchYear: Int, matchId: String) {
		
		/*
		let formattedUrl = String(format: openMatchDetailUrl, matchYear, matchId)
		if let appUrl = URL(string: formattedUrl) {
			
			self.extensionContext?.open(appUrl, completionHandler: nil)
		}*/
	}
	
	@IBAction func openLiveScreen(sender: UIButton) {
		
		if let appUrl = URL(string: openLiveUrl) {
			
			self.extensionContext?.open(appUrl, completionHandler: nil)
		}
	}
}
