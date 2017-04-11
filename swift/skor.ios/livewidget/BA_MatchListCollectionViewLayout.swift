//
//  BA_MatchListCollectionViewLayout.swift
//  bahisadam
//
//  Created by ilker özcan on 10/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchListCollectionViewLayout: UICollectionViewFlowLayout {

	enum LAYOUT_MODE {
		case ONE_CELL
		case MULTIPLE_CELLS
	}
	
	var layoutMode = LAYOUT_MODE.ONE_CELL
	
	private var cachedAttributes = [UICollectionViewLayoutAttributes]()
	
	override func prepare() {
		
		cachedAttributes.removeAll(keepingCapacity: false)
		let yPos: CGFloat = self.minimumLineSpacing
		var xPos: CGFloat = self.minimumInteritemSpacing
		
		if(layoutMode == .MULTIPLE_CELLS) {
			
			let itemHeight = self.itemSize.height
			let itemWidth = self.itemSize.width
			
			for section in 0..<(collectionView?.numberOfSections)! {
			
				if let cellCount = collectionView?.numberOfItems(inSection: section) {
				
					for item in 0..<cellCount {
					
						let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
						cellAttributes.frame = CGRect(x: xPos, y: yPos, width: itemWidth, height: itemHeight)
						cellAttributes.zIndex = 1
						xPos += itemWidth + self.minimumInteritemSpacing
						cachedAttributes.append(cellAttributes)
					}
				}

			}
		
		}else if(layoutMode == .ONE_CELL) {
			
			let itemWith = (self.collectionView?.frame.size.width)! - (self.minimumInteritemSpacing * 2)
			let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: 0, section: 0))
			cellAttributes.frame = CGRect(x: self.minimumInteritemSpacing, y: self.minimumLineSpacing, width: itemWith, height: self.itemSize.height)
			cellAttributes.zIndex = 1
			cachedAttributes.append(cellAttributes)
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		var layoutAttributes = [UICollectionViewLayoutAttributes]()
		
		for cellAttributes in cachedAttributes {
			
			if cellAttributes.frame.intersects(rect) {
				
				layoutAttributes.append(cellAttributes)
			}
		}
		
		return layoutAttributes
	}
}
