//
//  BA_LiveCollectionViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 11/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import TVBahisadamLive

fileprivate let cellReuseIdentifier = "liveScoreView"
fileprivate let cellHeaderReuseIdentifier = "liveHeaderView"
fileprivate let cellFooterReuseIdentifier = "liveFooterView"
fileprivate let emptyCellResueIdentifier = "emptyCell"
fileprivate let refreshCellResueIdentifier = "refreshCell"

class BA_LiveCollectionViewController: UICollectionViewController, BA_LiveRefreshCollectionViewCellDelegate {
	
	private var sectionCount = 0
	private var rowCounts = [Int]()
	private var allLeagueData: [BA_Leagues]?
	private var noMatchesViewIsActive = false
	private var firstDataLoaded = false
	private var isFirstLoad = true
	
	private var getLayout: BA_LiveCollectionViewLayout {
		
		get {
			return self.collectionViewLayout as! BA_LiveCollectionViewLayout
		}
	}
	
    override func viewDidLoad() {
		
		self.isFirstLoad = true
        super.viewDidLoad()
		
		rowCounts.append(0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)

        // Do any additional setup after loading the view.
		
		self.collectionView?.alwaysBounceVertical = true
		self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if(isFirstLoad) {
			
			isFirstLoad = false
		}else{
			
			self.loadData()
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
		
		if(self.sectionCount == 0 && firstDataLoaded) {
			
			noMatchesViewIsActive = true
			return 1
		}else{
			noMatchesViewIsActive = false
		}
		
		if(firstDataLoaded) {
			return (self.sectionCount + 1)
		}else{
			return 0
		}
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		if(noMatchesViewIsActive) {
			
			return 1
		}
		
		if(section == 0) {
			return 1
		}
		
		let currentSection = section - 1
		let rowCount = self.rowCounts[currentSection]
		if(rowCount % 2 == 0) {
			return rowCount
		}else{
			return rowCount + 1
		}
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if(indexPath.section == 0) {
			
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: refreshCellResueIdentifier, for: indexPath) as! BA_LiveRefreshCollectionViewCell
			cell.setupCell(delegate: self)
			return cell
			
		}else{
			
			let currentSection = indexPath.section - 1
			if(noMatchesViewIsActive) {
				
				//let cell = tableView.dequeueReusableCell(withIdentifier: "liveScoreDoesNotHaveMatchView", for: indexPath) as! BA_NoMatchTableViewCell
				//cell.setupCell()
				return UICollectionViewCell()
			}else{
				
				if(indexPath.row >= rowCounts[currentSection]) {
					
					let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellResueIdentifier, for: indexPath)
					return cell
				}else {
					
					let leagueData = self.allLeagueData![currentSection]
					let matchData = leagueData.matches[indexPath.row]
					let isLeftCell = (indexPath.row % 2 == 0) ? true : false
					let rightBorderStatus: Bool
					
					if(isLeftCell) {
						
						if((indexPath.row + 1) >= rowCounts[currentSection]) {
							
							rightBorderStatus = false
						}else{
							rightBorderStatus = true
						}
						
					}else{
						rightBorderStatus = false
					}
					
					let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! BA_LIveMatchCollectionViewCell
					cell.setupView(matchData: matchData, rightBorderStatus: rightBorderStatus)
					return cell
				}
			}
		}
    }
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		if(noMatchesViewIsActive || indexPath.section == 0) {
			
			switch kind {
			case UICollectionElementKindSectionHeader:
				
				return UICollectionReusableView()
			case UICollectionElementKindSectionFooter:
				
				return UICollectionReusableView()
			default:
				abort()
			}
			
		}else{
			
			let currentSection = indexPath.section - 1
			switch kind {
			case UICollectionElementKindSectionHeader:
			
				let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellHeaderReuseIdentifier, for: indexPath) as! BA_LiveHeaderCollectionReusableView
				let leagueData = self.allLeagueData![currentSection]
				headerView.setupHeader(leagueName: leagueData.leagueName, leagueImageURL: leagueData.logoUrl)
				return headerView
			case UICollectionElementKindSectionFooter:
			
				let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellFooterReuseIdentifier, for: indexPath) as! BA_LiveFooterCollectionReusableView
				return footerView
			default:
				abort()
			}
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		
		if(indexPath.section > 0 && !noMatchesViewIsActive) {
			
			switch elementKind {
			case UICollectionElementKindSectionHeader:
			
				if let headerView = view as? BA_LiveHeaderCollectionReusableView {
				
					headerView.setupBorderMask()
				}
				break
			case UICollectionElementKindSectionFooter:
			
				if let footerView = view as? BA_LiveFooterCollectionReusableView {
				
					footerView.setupFooter()
				}
			
				break
			default:
				abort()
			}
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		if(indexPath.section == 0) {
			
			if let refreshCell = cell as? BA_LiveRefreshCollectionViewCell {
				
				refreshCell.updateCellLayout()
			}
		}
	}

	
	override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
	
		if(indexPath.section == 0) {
			
			return false
		}else{
			
			return true
		}
	}
	
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

	private func loadData() {
		
		BA_ProgressHudView.ShowHud(forView: self.view)
		
		IO_NetworkHelper(getJSONRequest: BA_Server.LiveApi, completitionHandler: { (status, data, error, statusCode) in
			
			if(status) {
				
				if let dataDict = data as? Dictionary<String, AnyObject> {
					
					self.configureData(data: dataDict)
				}
			}
			
			BA_ProgressHudView.removeAllHuds()
		})
	}
	
	func refreshStart() {
		self.loadData()
	}
	
	private func configureData(data: Dictionary<String, AnyObject>) {
		
		let liveData = ConfigureLiveData(data: data)
		self.sectionCount = liveData.sectionCount
		self.rowCounts = liveData.rowCounts
		self.allLeagueData = liveData.allLeagueData
		
		self.collectionView?.reloadData()
		
		if(self.sectionCount > 0) {
			
			DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
				
				let collectionVCLayout = self.getLayout
				let scrollRect = CGRect(x: 0, y: collectionVCLayout.refreshViewHeight, width: self.collectionView!.frame.width, height: self.collectionView!.frame.height + 18)
				self.collectionView?.scrollRectToVisible(scrollRect, animated: true)
			})
		}
		
		firstDataLoaded = true
	}
	
	
}
