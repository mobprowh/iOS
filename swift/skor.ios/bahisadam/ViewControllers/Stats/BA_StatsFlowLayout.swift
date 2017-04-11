//
//  BA_StatsLayout.swift
//  bahisadam
//
//  Created by ilker özcan on 03/10/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

class BA_StatsFlowLayout: UICollectionViewFlowLayout {

	private var expandedSection = -1
	private let cellEndHeight: CGFloat = 40
	private let sectionEndHeight: CGFloat = 46
	private let sectionFooterEndHeight: CGFloat = 14
	
	private var cachedAttributes = [UICollectionViewLayoutAttributes]()
	private var initialInsets: UIEdgeInsets!
	private var viewSize: CGFloat = 0
	
	func prepareLayout(insets: UIEdgeInsets) {
		
		self.initialInsets = insets
	}
	
	func expandSection(section: Int) {
		
		if(self.expandedSection == section) {
			self.expandedSection = -1
		}else{
			self.expandedSection = section
		}
		
		self.invalidateLayout()
	}
	
	override func prepare() {
		
		cachedAttributes.removeAll(keepingCapacity: false)
		var startY: CGFloat = 0
		viewSize = 0
		let headerSize = self.collectionView?.bounds.size
		
		for section in 0..<(collectionView?.numberOfSections)! {
			
			let indexPath = IndexPath(item: 0, section: section)
			let sectionAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
			sectionAttributes.frame = CGRect(x: 0, y: startY, width: headerSize!.width, height: sectionEndHeight)
			sectionAttributes.zIndex = 10
			cachedAttributes.append(sectionAttributes)
			startY += sectionEndHeight
			viewSize += sectionEndHeight
			
			if let cellCount = collectionView?.numberOfItems(inSection: section) {
				
				if(section != expandedSection) {
					startY -= (cellEndHeight * CGFloat(cellCount))
				}
				
				for item in 0..<cellCount {
					
					let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: item, section: section))
					cellAttributes.frame = CGRect(x: 8, y: startY, width: headerSize!.width - 16, height: cellEndHeight)
					cellAttributes.zIndex = 1
					startY += cellEndHeight
					
					if(section == expandedSection) {
						
						cellAttributes.alpha = 1
						viewSize += cellEndHeight
					}else{
						cellAttributes.alpha = 0
					}
					
					cachedAttributes.append(cellAttributes)
				}
			}
			
			let footerStarty = (section == expandedSection) ? startY : (startY - 12)
			let footerIndexPath = IndexPath(item: 0, section: section)
			let footerSectionAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: footerIndexPath)
			footerSectionAttributes.frame = CGRect(x: 0, y: footerStarty, width: headerSize!.width, height: sectionFooterEndHeight)
			footerSectionAttributes.zIndex = 5
			cachedAttributes.append(footerSectionAttributes)
			let sectionFooterCurrentHeight = (section == expandedSection) ? sectionFooterEndHeight : (sectionFooterEndHeight - 12)
			startY += sectionFooterCurrentHeight
			viewSize += sectionFooterCurrentHeight
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		var layoutAttributes = [UICollectionViewLayoutAttributes]()
		
		for cellAttributes in cachedAttributes {
			
			if cellAttributes.frame.intersects(rect) {
				
				layoutAttributes.append(cellAttributes)
			}
		}
		
		let contentSize = self.collectionView?.contentSize.height
		let insetBottom = viewSize - contentSize! + cellEndHeight + sectionFooterEndHeight + sectionEndHeight
		self.collectionView?.contentInset = UIEdgeInsetsMake(initialInsets.top, initialInsets.left, insetBottom, initialInsets.right)
		
		return layoutAttributes
	}
	
}
