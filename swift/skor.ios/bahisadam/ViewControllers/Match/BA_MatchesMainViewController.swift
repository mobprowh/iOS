//
//  BA_MatchesMainViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 21/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchesMainViewController: UIViewController, MatchDateCollectionViewCellDelegate, UIPopoverPresentationControllerDelegate {
	
	@IBOutlet weak var datePickerView: UIView!
	@IBOutlet weak var backdrop: UIView!
    
    
	private var collectionVC: UnsafeMutablePointer<MatchCollectionViewController>?
	private var collectionVCAllocated = false
	private var matchListCollectionVC: UnsafeMutablePointer<BA_MatchListCollectionViewController>?
	private var matchListCVCAllocated = false
	private var selectedDate: Date?
	private var newValueSetted = false
    
    var favoritesState = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // change the list type
        for controller in self.childViewControllers {
            if let matchList = controller as? BA_MatchListCollectionViewController {
                matchList.favoritesState = self.favoritesState
            }
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		
		self.tabBarController?.navigationItem.title = ""
		super.viewWillAppear(animated)
	}
	
	deinit {
		
		if(collectionVCAllocated) {
		
			defer {
				self.collectionVC!.deinitialize()
				self.collectionVC!.deallocate(capacity: MemoryLayout<MatchCollectionViewController>.size)
			}
		
			collectionVCAllocated = false
		}
		
		if(matchListCVCAllocated) {
		
			defer {
				self.matchListCollectionVC!.deinitialize()
				self.matchListCollectionVC!.deallocate(capacity: MemoryLayout<BA_MatchListCollectionViewController>.size)
			}
		
			matchListCVCAllocated = false
		}
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		// Get the new view controller using segue.destinationViewController.
		// Pass the selected object to the new view controller.
		
		if let segueId = segue.identifier {
			
			if(segueId == "matchDateSelection") {
				
				if let maMatchColVC = segue.destination as? MatchCollectionViewController {
					
					maMatchColVC.setDelegate(delegate: self)
					self.collectionVC = UnsafeMutablePointer<MatchCollectionViewController>.allocate(capacity: MemoryLayout<MatchCollectionViewController>.size)
					self.collectionVC?.initialize(to: maMatchColVC)
					self.collectionVCAllocated = true
				}
			}else if(segueId == "matchesCollectionView") {
				
				if let maMatchTableVC = segue.destination as? BA_MatchListCollectionViewController {
					
					self.matchListCollectionVC = UnsafeMutablePointer<BA_MatchListCollectionViewController>.allocate(capacity: MemoryLayout<BA_MatchListCollectionViewController>.size)
					self.matchListCollectionVC?.initialize(to: maMatchTableVC)
					self.matchListCVCAllocated = true
				}
            }
            
		}
	}

	
	func MatchDateCollectionViewCellDatePickerSelected() {
		
		if(self.datePickerView.isHidden) {
			
			self.datePickerView.isHidden = false
			self.backdrop.isHidden = false
		}else{
			self.datePickerView.isHidden = true
			self.backdrop.isHidden = true
		}
	}
	
	func MatchDateCollectionViewCellDateSelected(atDay: Date) {
		
		if(self.collectionVC != nil) {
			
			self.matchListCollectionVC?.pointee.changeDate(startDate: atDay)
			let today = Date().timeIntervalSince1970
			let atDayInt = atDay.timeIntervalSince1970
			let diff = Int(round((atDayInt - today) / 86400.0)) * 86400
			self.collectionVC?.pointee.changeDate(dateDiff: Int(diff))
		}
		
		self.datePickerView.isHidden = true
		self.backdrop.isHidden = true
	}
	
	@IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
		
		self.selectedDate = sender.date
	}
	
	@IBAction func pickButtonTapped(_ sender: UIButton) {
		
		self.datePickerView.isHidden = true
		self.backdrop.isHidden = true
		
		if(self.matchListCollectionVC != nil && self.selectedDate != nil) {
			
			self.matchListCollectionVC?.pointee.changeDate(startDate: self.selectedDate!)
			let today = Date().timeIntervalSince1970
			let atDayInt = self.selectedDate?.timeIntervalSince1970
			let diff = Int(round((atDayInt! - today) / 86400.0)) * 86400
			self.collectionVC?.pointee.changeDate(dateDiff: Int(diff))
		}
	}
    
    
    
	
}
