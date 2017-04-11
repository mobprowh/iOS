//
//  BA_LiveCollectionViewLayout.swift
//  bahisadam
//
//  Created by ilker özcan on 11/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_LiveCollectionViewLayout: UICollectionViewFlowLayout {

	private let _refreshViewHeight: CGFloat = 134
	
	var refreshViewHeight: CGFloat {
		
		get {
			return _refreshViewHeight
		}
	}
	
	// store attributes
	private var cachedAttributes = [UICollectionViewLayoutAttributes]()
	private var lastBounds: CGRect!
	
	var collectionViewWidth: CGFloat {
		
		get {
			return self.collectionView!.bounds.size.width
		}
	}
	
	// prepare attributes
	override func prepare() {
		
		cachedAttributes.removeAll(keepingCapacity: false)
		
		if(lastBounds == nil) {
			lastBounds = CGRect(x: 0, y: 0, width: collectionView!.bounds.width, height: collectionView!.bounds.height)
		}
		
		var y: CGFloat = 0
		let headerHeight = self.headerReferenceSize.height
		let footerHeight = self.footerReferenceSize.height
		let currentCollectionViewWidth = self.collectionViewWidth
		let currentItemViewWidth = (currentCollectionViewWidth / 2) - 24
		let itemHeight = self.itemSize.height
		let itemRightXPos = currentItemViewWidth + 24
		
		for currentSection in 0..<self.collectionView!.numberOfSections {
			
			if(currentSection == 0) {
				
				if(lastBounds.origin.y > (y + _refreshViewHeight)) {
					
					y += _refreshViewHeight
				}else{
					
					let indexPath = IndexPath(item: 0, section: 0)
					let sectionAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
					y = 0
					sectionAttributes.frame = CGRect(x: 0, y: y, width: currentCollectionViewWidth, height: _refreshViewHeight)
					sectionAttributes.zIndex = 15
					y += _refreshViewHeight
					cachedAttributes.append(sectionAttributes)
				}
				continue
			}
			
			if(lastBounds.origin.y > (y + headerHeight)) {
			
				y += headerHeight
			}else{
				
				let indexPath = IndexPath(item: 0, section: currentSection)
				let sectionAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
				sectionAttributes.frame = CGRect(x: 0, y: y, width: currentCollectionViewWidth, height: headerHeight)
				sectionAttributes.zIndex = 10
				y += headerHeight
				cachedAttributes.append(sectionAttributes)
			}
			
			for item in 0..<self.collectionView!.numberOfItems(inSection: currentSection) {
				
				if(lastBounds.origin.y > (y + itemHeight)) {
					
					if(item % 2 != 0) {
						
						y += itemHeight
					}
					
				}else{
					
					let indexPath = IndexPath(item: item, section: currentSection)
					let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
				
					if(item % 2 == 0) {
					
						itemAttributes.frame = CGRect(x: 24, y: y, width: currentItemViewWidth, height: itemHeight)
					}else{
					
						itemAttributes.frame = CGRect(x: itemRightXPos, y: y, width: currentItemViewWidth, height: itemHeight)
						y += itemHeight
					}
				
					itemAttributes.zIndex = 4
					cachedAttributes.append(itemAttributes)
				}
			}
			
			if(lastBounds.origin.y > (y + footerHeight)) {
				
				y += footerHeight
			}else{
				
				let footerIndexPath = IndexPath(item: 0, section: currentSection)
				let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: footerIndexPath)
				footerAttributes.frame = CGRect(x: 0, y: y, width: currentCollectionViewWidth, height: footerHeight)
				footerAttributes.zIndex = 7
				y += footerHeight
				cachedAttributes.append(footerAttributes)
			}
			
		}
	}
	
	// return stored attributes
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		return cachedAttributes
	}
	
	// Return true so that the layout is continuously invalidated as the user scrolls
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		
		self.lastBounds = newBounds
		return true
	}
}
