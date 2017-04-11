//
//  MatchCollectionViewController.swift
//  bahisadam
//
//  Created by ilker özcan on 21/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class MatchCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	private let reuseIdentifier = "dateViewSubdate"
	private let reuseIdentifierPicker = "dateViewSubdatePicker"
	private let cellWidth: CGFloat = 42 // 50
	private let cellHeight: CGFloat = 48
	private let cellSpace: CGFloat = 5
	private let oneDayInterval: TimeInterval = 86400
    private let daysLetters = ["P", "S", "Ç", "P", "C", "Ct", "Pz"]
	
	private var delegate: MatchDateCollectionViewCellDelegate?
	private var displayElementCount: Int!
	private var currentDateVal = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(MatchDateCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		//self.collectionView!.register(MatchDateCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifierPicker)

        // Do any additional setup after loading the view.
		let frameWidth = UIScreen.main.bounds.size.width
		self.displayElementCount = Int(frameWidth) / (Int(cellWidth) + Int(cellSpace))
		
		if(self.displayElementCount > 6) {
			
			self.displayElementCount = 6
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
		self.collectionView!.scrollToItem(at: IndexPath(row: 2, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		//self.delegate = nil
		super.viewWillDisappear(animated)
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
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		
		/*guard self.delegate != nil else {
			
			return 0
		}*/
		
        return (self.displayElementCount + 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        let frameWidth = UIScreen.main.bounds.size.width
        let width = frameWidth / CGFloat(self.displayElementCount + 2)
        
        return CGSize(width: width, height: cellHeight)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell: MatchDateCollectionViewCell
		if(indexPath.row == (self.displayElementCount + 1)) {
			
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierPicker, for: indexPath) as! MatchDateCollectionViewCell
			cell.setupView(dayName: "", day: "", delegate: self.delegate, startDate: nil)
		}else{
			
			cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MatchDateCollectionViewCell
			
			let rowStart = indexPath.row - 2
			let timeInterval = TimeInterval(rowStart) * oneDayInterval
			let currentDate = Date(timeIntervalSinceNow: timeInterval)
			let formattedDate = self.formatDate(currDate: currentDate)
			let isCurrentDate = (Int(timeInterval) == currentDateVal) ? true : false
			cell.setupView(dayName: formattedDate.1, day: formattedDate.0, delegate: self.delegate, startDate: currentDate, isCurrentDay: isCurrentDate)
		}
		
        // Configure the cell
    
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

	func setDelegate(delegate: MatchDateCollectionViewCellDelegate) {
		
		self.delegate = delegate
		//self.collectionView?.reloadData()
	}
	
	func changeDate(dateDiff: Int) {
		
		self.currentDateVal = dateDiff
		self.collectionView?.reloadData()
	}
	
	private func formatDate(currDate: Date) -> (String, String) {
		
		let dateFormatterDay = DateFormatter()
		dateFormatterDay.dateFormat = "d"
		let day = dateFormatterDay.string(from: currDate)
		
		let dateFormatterDayName = DateFormatter()
		dateFormatterDayName.locale = Locale(identifier: "tr_TR_POSIX")
		dateFormatterDayName.dateFormat = "e"
		var dayName = dateFormatterDayName.string(from: currDate)
        
        if let index = Int(dayName) {
            dayName = daysLetters[index - 1]
        }
        
//		let index = dayName.index(dayName.startIndex, offsetBy: 1)
		return (day, dayName)
	}
}
