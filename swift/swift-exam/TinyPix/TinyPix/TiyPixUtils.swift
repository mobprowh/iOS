//
//  TiyPixUtils.swift
//  TinyPix
//
//  Created by andrey on 2/19/17.
//  Copyright © 2017 andrey. All rights reserved.
//

//import Foundation

import UIKit

class TinyPixUtils {
    
    class func getTintColorForIndex(index: Int) -> UIColor {
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
