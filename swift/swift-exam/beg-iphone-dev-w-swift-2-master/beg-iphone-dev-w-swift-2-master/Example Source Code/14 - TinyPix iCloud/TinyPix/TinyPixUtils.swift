//
//  TinyPixUtils.swift
//  TinyPix
//
//  Created by Kim Topley on 10/29/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class TinyPixUtils {
    class func getTintColorForIndex(index: Int) -> UIColor {
        let color: UIColor
        switch index {
        case 0:
            color = UIColor .redColor()
        
        case 1:
            color = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
        
        case 2:
            color = UIColor.blueColor()
        
        default:
            color = UIColor.redColor()
        }
        return color
    }
}
