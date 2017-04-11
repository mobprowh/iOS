//
//  BA_MatchDetailIndexLayout.swift
//  bahisadam
//
//  Created by ilker özcan on 27/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchDetailIndexLayout: UICollectionViewFlowLayout {

	enum BA_MatchDetailTabChangeDirection {
		
		case NONE
		case LEFT
		case RIGHT
	}
	
	fileprivate let headerSize = CGSize(width: 375, height: 40)
	fileprivate let footerSize = CGSize(width: 375, height: 12)
	
	private var initialInsetTop: CGFloat!
	private var cellData: [BA_MatchDetailIndexCellData]!
	private var currentTab: Int = 0
	private var dissappearingTab = -1
	private var dissapearingItemAttributes: [UICollectionViewLayoutAttributes]?
	
	// store attributes
	private var cachedAttributes = [UICollectionViewLayoutAttributes]()
	
	private var viewHeight: CGFloat = 0
	private var viewWidth: CGFloat = 0
	private var tabChangeDirection = BA_MatchDetailTabChangeDirection.NONE
	
	override var collectionViewContentSize: CGSize {
		
		get {
			
			return CGSize(width: self.viewWidth, height: self.viewHeight)
		}
	}
	
	func prepareLayout(insetTop: CGFloat, cellData: [BA_MatchDetailIndexCellData], currentTab: Int) {
		
		self.initialInsetTop = insetTop
		self.cellData = cellData
		self.currentTab = currentTab
        self.minimumLineSpacing = 0.0
        self.minimumInteritemSpacing = 0.0
	}
	
	// prepare attributes
	override func prepare() {
		
		if(self.dissappearingTab != -1) {
			
			self.dissapearingItemAttributes = self.cachedAttributes
		}
		
		cachedAttributes.removeAll(keepingCapacity: false)
		var startY: CGFloat = 0
		let startX: CGFloat = 0
		let sizeWidth = self.collectionView?.bounds.size
		let lineSpace = self.minimumLineSpacing
		let zIndex = 10
		var realSection = 0
		
		guard self.cellData != nil else {
			return
		}
		
		for section in 0..<cellData.count {
			
			if(self.cellData[section].tabIdx != self.currentTab) {
				
				continue
			}
			
			if(!cellData[section].isVisible) {
				
				realSection += 1
				continue
			}
			
			let indexPath = IndexPath(item: 0, section: realSection)
			let sectionAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
			
			if(self.cellData[section].hasResuableHeader) {
				
                let headerHeight = currentTab == 3 ? 30.0 : headerSize.height
                
				sectionAttributes.frame = CGRect(x: startX, y: startY, width: sizeWidth!.width, height: headerHeight)
				sectionAttributes.zIndex = zIndex
				sectionAttributes.isHidden = false
				cachedAttributes.append(sectionAttributes)
				startY += headerHeight
			}else{
				
				sectionAttributes.frame = CGRect(x: startX, y: 0, width: 0, height: 0)
				sectionAttributes.zIndex = zIndex
				sectionAttributes.isHidden = true
				cachedAttributes.append(sectionAttributes)
			}
			
			let cellCount = self.cellData[section].rowCount
			for item in 0..<cellCount {
					
				let currentCellHeight = cellData[section].cellHeights[item]
				let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: realSection))
				cellAttributes.frame = CGRect(x: startX, y: startY, width: sizeWidth!.width, height: currentCellHeight)
				cellAttributes.zIndex = zIndex
				startY += currentCellHeight
				cachedAttributes.append(cellAttributes)
			}
			
			let footerSectionAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: indexPath)
			
			if(self.cellData[section].hasResuableFooter) {
				
				footerSectionAttributes.frame = CGRect(x: startX, y: startY, width: sizeWidth!.width, height: footerSize.height)
				footerSectionAttributes.zIndex = zIndex
				footerSectionAttributes.isHidden = false
				cachedAttributes.append(footerSectionAttributes)
				startY += footerSize.height
			}else{
				
				footerSectionAttributes.frame = CGRect(x: startX, y: 0, width: 0, height: 0)
				footerSectionAttributes.zIndex = zIndex
				footerSectionAttributes.isHidden = true
				cachedAttributes.append(footerSectionAttributes)
			}
			
			startY += lineSpace
			realSection += 1
		}
		
		self.viewWidth = startX + (sizeWidth?.width)!
		self.viewHeight = startY
	}
	
	// return stored attributes
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		var layoutAttributes = [UICollectionViewLayoutAttributes]()
		
		for cellAttributes in cachedAttributes {
			
			if cellAttributes.frame.intersects(rect) {
				
				layoutAttributes.append(cellAttributes)
			}
		}
		
		return cachedAttributes
	}
	
	override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		var realSectionNumber = 0
		for currentCellData in self.cellData {
			
			if(currentCellData.tabIdx != self.currentTab) {
				
				realSectionNumber += 1
			}else{
				
				break
			}
		}
		
		let currentSectionNumber = itemIndexPath.section + realSectionNumber
		guard self.cellData.count > currentSectionNumber else {
			return nil	
		}
		if(!self.cellData[currentSectionNumber].isVisible) {
			
			return nil
		}
		
		if let attr = self.layoutAttributesForItem(at: itemIndexPath) {
			
			let collectionViewSize = (self.collectionView?.bounds)!.size
			if(self.tabChangeDirection == .LEFT) {
				
				attr.transform = attr.transform.translatedBy(x: collectionViewSize.width, y: 0).scaledBy(x: 0.6, y: 0.6)
				return attr
				
			}else if(self.tabChangeDirection == .RIGHT) {
				
				attr.transform = attr.transform.translatedBy(x: -collectionViewSize.width, y: 0).scaledBy(x: 0.6, y: 0.6)
				return attr
			}else{
				
				return attr
			}
		}
		
		return nil
	}
	
	override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		var realSectionNumber = 0
		for currentCellData in self.cellData {
			
			if(currentCellData.tabIdx != self.currentTab) {
				
				realSectionNumber += 1
			}else{
				
				break
			}
		}
		
		let currentSectionNumber = elementIndexPath.section + realSectionNumber
		
		if(!self.cellData[currentSectionNumber].isVisible) {
			
			return nil
		}
		
		if let attr = self.layoutAttributesForSupplementaryView(ofKind: elementKind, at: elementIndexPath) {
			
			let collectionViewSize = (self.collectionView?.bounds)!.size
			if(self.tabChangeDirection == .LEFT) {
				
				attr.transform = attr.transform.translatedBy(x: collectionViewSize.width, y: 0).scaledBy(x: 0.6, y: 0.6)
				return attr
				
			}else if(self.tabChangeDirection == .RIGHT) {
				
				attr.transform = attr.transform.translatedBy(x: -collectionViewSize.width, y: 0).scaledBy(x: 0.6, y: 0.6)
				return attr
			}else{
				
				return attr
			}
		}
		
		return nil
	}
	
	override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		guard self.dissappearingTab != -1 else {
			
			return nil
		}
		
		var realSectionNumber = 0
		for currentCellData in self.cellData {
			
			if(currentCellData.tabIdx != self.dissappearingTab) {
				
				realSectionNumber += 1
			}else{
				
				break
			}
		}
		
		let currentSectionNumber = itemIndexPath.section + realSectionNumber
		
		if(!self.cellData[currentSectionNumber].isVisible) {
			
			return nil
		}
		
		if let dissapearingItems = self.dissapearingItemAttributes {
			
			let collectionViewSize = (self.collectionView?.bounds)!.size
			
			for dissapearingItem in dissapearingItems {
				
				if (dissapearingItem.indexPath == itemIndexPath && dissapearingItem.representedElementKind == nil) {
					
					if(self.tabChangeDirection == .LEFT) {
						
						dissapearingItem.transform = dissapearingItem.transform.translatedBy(x: -collectionViewSize.width, y: 0).scaledBy(x: 0.6, y: 0.6)
						return dissapearingItem
						
					}else if(self.tabChangeDirection == .RIGHT) {
						
						dissapearingItem.transform = dissapearingItem.transform.translatedBy(x: collectionViewSize.width, y: 0).scaledBy(x: 0.6, y: 0.6)
						return dissapearingItem
					}else{
						
						return dissapearingItem
					}
				}
			}
		}
		
		return nil
	}
	
	override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		
		guard self.dissappearingTab != -1 else {
			
			return nil
		}
		
		var realSectionNumber = 0
		for currentCellData in self.cellData {
			
			if(currentCellData.tabIdx != self.dissappearingTab) {
				
				realSectionNumber += 1
			}else{
				
				break
			}
		}
		
		let currentSectionNumber = elementIndexPath.section + realSectionNumber
		
		if(!self.cellData[currentSectionNumber].isVisible) {
			
			return nil
		}
		
		if let dissapearingItems = self.dissapearingItemAttributes {
			
			let collectionViewSize = (self.collectionView?.bounds)!.size
			
			for dissapearingItem in dissapearingItems {
				
				
				if (dissapearingItem.indexPath == elementIndexPath && dissapearingItem.representedElementKind == elementKind) {
					
					if(self.tabChangeDirection == .LEFT) {
						
						dissapearingItem.transform = dissapearingItem.transform.translatedBy(x: -collectionViewSize.width, y: 0).scaledBy(x: 0.6, y: 0.6)
						return dissapearingItem
						
					}else if(self.tabChangeDirection == .RIGHT) {
						
						dissapearingItem.transform = dissapearingItem.transform.translatedBy(x: collectionViewSize.width, y: 0).scaledBy(x: 0.6, y: 0.6)
						return dissapearingItem
					}else{
						
						return dissapearingItem
					}
				}
			}
		}
		
		return nil
	}
	
	override func finalizeCollectionViewUpdates() {
		
		self.tabChangeDirection = .NONE
		self.dissapearingItemAttributes = nil
		self.dissappearingTab = -1
		super.finalizeCollectionViewUpdates()
	}
	
	func changeTab(tabNum: Int, cellData: [BA_MatchDetailIndexCellData]?) {
		
		let oldTabNum = self.currentTab
		
		if(tabNum < oldTabNum) {
			
			self.tabChangeDirection = BA_MatchDetailTabChangeDirection.RIGHT
		}else if(tabNum > oldTabNum) {
			
			self.tabChangeDirection = BA_MatchDetailTabChangeDirection.LEFT
		}
		
		self.collectionView?.contentOffset = CGPoint(x: 0, y: -self.initialInsetTop)
		self.currentTab = tabNum
		self.cellData = cellData
		self.dissappearingTab = oldTabNum
	}
}
