//
//  BA_MatchDetailIndexCellData.swift
//  bahisadam
//
//  Created by ilker özcan on 30/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation
import UIKit

struct BA_MatchDetailIndexCellData {
	
	var cellHeights: [CGFloat]
	var cellId: [String]
	let hasResuableHeader: Bool
	let resuableTitle: String
	let hasResuableFooter: Bool
	var rowCount: Int
	let tabIdx: Int
	
	var isVisible: Bool
}
