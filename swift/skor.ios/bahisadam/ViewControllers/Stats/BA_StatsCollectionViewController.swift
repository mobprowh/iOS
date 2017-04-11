//
//  BA_StatsCollectionViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 03/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import MBProgressHUD
import BahisadamLive

private let reuseIdentifier = "leagueCell"

class BA_StatsCollectionViewController: UICollectionViewController, BA_StatsDelegate {

	private var allCountries: [BA_Countries]?
	private var sectionCount = 0
	private var rowCounts = [Int]()
	private var downloadingImageCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

		rowCounts.append(0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
		if let statsLayout = self.collectionView?.collectionViewLayout as? BA_StatsFlowLayout {
			
			statsLayout.prepareLayout(insets: (self.collectionView?.contentInset)!)
		}
		
		self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return self.sectionCount
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.rowCounts[section]
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BA_StatsCollectionViewCell
		let leagueData = (self.allCountries![indexPath.section].leagues)[indexPath.row]
		// Configure the cell
		cell.setupCell(leagueName: leagueData.leagueName, leagueId: leagueData.leagueId, imageUrl: leagueData.logoUrl, delegate: self)
		
        return cell
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
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		switch kind {
		case UICollectionElementKindSectionHeader:
				
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "countryCell", for: indexPath) as! BA_StatsCollectionReusableView
			headerView.setupHeader(countryName: self.allCountries![indexPath.section].countryName, countryCode: self.allCountries![indexPath.section].countryCode, countryId: self.allCountries![indexPath.section].countryId, delegate: self)
			return headerView
		case UICollectionElementKindSectionFooter:
			
			let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "countryFooterCell", for: indexPath) as! BA_StatsFooterCollectionReusableView
			return footerView
			
		default:
			abort()
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		
		switch elementKind {
		case UICollectionElementKindSectionHeader:
			
			if let headerView = view as? BA_StatsCollectionReusableView {
				
				headerView.setupMask()
			}
			
			break
		case UICollectionElementKindSectionFooter:
			
			if let footerView = view as? BA_StatsFooterCollectionReusableView {
				
				footerView.setupFooter()
			}
			
			break
		default:
			abort()
		}
	}
	
	private func loadData() {
		
		MBProgressHUD.showAdded(to: self.view, animated: false)
		
		BA_Database.SharedInstance.getCountryList { (status, data, error, statusCode) in
			
			if(status) {
				
				self.allCountries = data as? [BA_Countries]
				self.sectionCount = self.allCountries!.count
				self.rowCounts = [Int]()
				
				for countryData in self.allCountries! {
					
					self.rowCounts.append(countryData.leagues.count)
				}
				
				self.collectionView?.reloadData()
			}
			
			MBProgressHUD.hideAllHUDs(for: self.view, animated: false)
		}
	}
	
	func expandCountry(countryId: Int) {
		
		guard self.allCountries != nil else {
			return
		}
		
		let index = self.allCountries!.index { (data) -> Bool in
			
			if(data.countryId == countryId) {
				return true
			}
			
			return false
		}
		
		guard index != nil else {
			return
		}
		
		if let statsLayout = self.collectionView?.collectionViewLayout as? BA_StatsFlowLayout {
			
			statsLayout.expandSection(section: index!)
		}
		
	}
	
	func leagueTapped(leagueId: Int) {
	
		if let statsVC = self.parent as? BA_StatsViewController {
			
			statsVC.openWebView(leagueId: leagueId)
			
		}else if let pointsVC = self.parent as? BA_PointsViewController {
			
			pointsVC.openWebView(leagueId: leagueId)
		}
	}
}
