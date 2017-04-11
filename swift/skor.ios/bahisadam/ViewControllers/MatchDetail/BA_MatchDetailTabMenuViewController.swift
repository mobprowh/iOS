//
//  BA_MatchDetailTabMenuViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 08/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchDetailTabMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, BA_MatchDetailMenuCollectionViewCellDelegate {
	
	@IBOutlet var collectionView: UICollectionView!
	
	// MARK: - Parent View Controller
	var delegate: BA_MatchDetailMenuDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return BA_CurrentMatchDetailMenus.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BA_matchDetailMenuCell", for: indexPath) as? BA_MatchDetailMenuCollectionViewCell {
			
			menuCell.setupCell(item: BA_CurrentMatchDetailMenus[indexPath.item], delegate: self)
			return menuCell
		}
		
		return UICollectionViewCell()
	}
	
	func setSelectedTab(tabIdx: Int) {
		
		for i in 0..<BA_CurrentMatchDetailMenus.count {
			
			let indexPath = IndexPath(item: i, section: 0)
			if let menuCell = self.collectionView.cellForItem(at: indexPath) as? BA_MatchDetailMenuCollectionViewCell {
				
				if(i == tabIdx) {
					menuCell.setSelected()
				}else{
					menuCell.setUnselected()
				}
			}
		}
	}
    
    func cell(_ cell: BA_MatchDetailMenuCollectionViewCell, tappedIndex: Int) {
        guard delegate != nil else {
            
            return
        }
        
        delegate?.itemTapped(itemNumber: tappedIndex)
    }
}
