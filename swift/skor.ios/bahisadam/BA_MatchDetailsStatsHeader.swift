//
//  BA_MatchDetailsStatsHeader.swift
//  bahisadam
//
//  Created by Sergii Shulga on 3/2/17.
//  Copyright © 2017 ilkerozcan. All rights reserved.
//

import UIKit

class BA_MatchDetailsStatsHeader: UICollectionReusableView {
    
    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var triangleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let path = UIBezierPath()
        path.move(to: CGPoint())
        path.addLine(to: CGPoint(x: self.triangleView.bounds.size.width, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.triangleView.bounds.size.height))
        path.addLine(to: CGPoint())
        
        let shape = CAShapeLayer()
        shape.frame = self.triangleView.bounds
        shape.path = path.cgPath
        
        self.triangleView.layer.mask = shape
    }

}
