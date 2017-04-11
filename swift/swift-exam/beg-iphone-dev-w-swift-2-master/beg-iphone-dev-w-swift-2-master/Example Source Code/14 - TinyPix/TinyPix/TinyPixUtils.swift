//
//  TinyPixUtils.swift
//  TinyPix
//
//  Created by Kim Topley on 10/29/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class TinyPixUtils {
    class func getTintColorForIndex(_ index: Int) -> UIColor {
        let color: UIColor
        switch index {
        case 0:
            color = UIColor.red
        
        case 1:
            color = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        case 2:
            color = UIColor.blue
        
        default:
            color = UIColor.red
        }
        return color
    }
}
