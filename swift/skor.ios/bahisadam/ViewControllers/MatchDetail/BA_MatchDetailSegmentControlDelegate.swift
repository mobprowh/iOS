//
//  BA_MatchDetailSegmentControlDelegate.swift
//  bahisadam
//
//  Created by ilker özcan on 06/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

protocol BA_MatchDetailSegmentControlDelegate {

	func matchDetailSegmentChanged(selectedIdx: Int, section: Int, invalidate: Bool)
}
