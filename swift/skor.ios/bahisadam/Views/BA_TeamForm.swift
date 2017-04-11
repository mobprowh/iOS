//
//  BA_TeamFormRight.swift
//  bahisadam
//
//  Created by ilker özcan on 12/12/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit
import QuartzCore

class BA_TeamForm: UIView {

	private var leftFormColor: UIColor?
	private var rightFormColor: UIColor?
	private var teamFormLeftShape: CAShapeLayer?
	private var teamFormRightShape: CAShapeLayer?
	private var isDrawCalled = false
	
	private let strokeColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
	
	// 100 x 125
	override func draw(_ rect: CGRect) {
		
		if (self.teamFormLeftShape != nil) {
			
			self.teamFormLeftShape?.removeFromSuperlayer()
		}
		
		if (self.teamFormRightShape != nil) {
			
			self.teamFormRightShape?.removeFromSuperlayer()
		}
		
		guard (self.leftFormColor != nil && self.rightFormColor != nil) else {
			
			self.isDrawCalled = true
			return
		}
		
		let scaleYVal = rect.size.height / 125.0
		let scaleXVal = rect.size.width / 100.0
		//let formWidth = rect.size.width / 2.0
		let topPosition: CGFloat = rect.size.width / -2.0
		let leftPosition: CGFloat = rect.size.height / -2.0
		
		self.teamFormLeftShape = CAShapeLayer()
		self.teamFormLeftShape?.path = self.getTeamFormLeftPath().cgPath
		self.teamFormLeftShape?.strokeColor = self.strokeColor.cgColor
		self.teamFormLeftShape?.fillColor = self.leftFormColor?.cgColor
		self.teamFormLeftShape?.lineWidth = 2.0
		self.teamFormLeftShape?.frame = CGRect(x: leftPosition, y: topPosition, width: rect.size.width, height: rect.size.height)
		self.teamFormLeftShape?.transform = CATransform3DMakeScale(scaleXVal, scaleYVal, 1)
		
		self.layer.addSublayer(self.teamFormLeftShape!)
		
		self.teamFormRightShape = CAShapeLayer()
		self.teamFormRightShape?.path = self.getTeamFormRightPath().cgPath
		self.teamFormRightShape?.strokeColor = self.strokeColor.cgColor
		self.teamFormRightShape?.fillColor = self.rightFormColor?.cgColor
		self.teamFormRightShape?.lineWidth = 2.0
		self.teamFormRightShape?.frame = CGRect(x: leftPosition, y: topPosition, width: rect.size.width, height: rect.size.height)
		self.teamFormRightShape?.transform = CATransform3DMakeScale(scaleXVal, scaleYVal, 1)
		
		self.layer.addSublayer(self.teamFormRightShape!)
		
	}
	
	func getTeamFormLeftPath() -> UIBezierPath {
		
		let leftFormPath = UIBezierPath()
		leftFormPath.move(to: CGPoint(x: 50.69, y: 28.09))
		leftFormPath.addLine(to: CGPoint(x: 50.63, y: 12.78))
		leftFormPath.addLine(to: CGPoint(x: 48.22, y: 12.63))
		leftFormPath.addCurve(to: CGPoint(x: 41, y: 8.53), controlPoint1: CGPoint(x: 45.58, y: 12.34), controlPoint2: CGPoint(x: 42.97, y: 10.86))
		leftFormPath.addCurve(to: CGPoint(x: 38.08, y: 3.86), controlPoint1: CGPoint(x: 40.17, y: 7.55), controlPoint2: CGPoint(x: 37.95, y: 4.01))
		leftFormPath.addCurve(to: CGPoint(x: 39.88, y: 4.36), controlPoint1: CGPoint(x: 38.1, y: 3.83), controlPoint2: CGPoint(x: 38.91, y: 4.06))
		leftFormPath.addCurve(to: CGPoint(x: 47.56, y: 5.8), controlPoint1: CGPoint(x: 42.22, y: 5.11), controlPoint2: CGPoint(x: 44.92, y: 5.61))
		leftFormPath.addLine(to: CGPoint(x: 49.74, y: 5.96))
		leftFormPath.addLine(to: CGPoint(x: 49.74, y: 4.67))
		leftFormPath.addLine(to: CGPoint(x: 49.74, y: 3.37))
		leftFormPath.addLine(to: CGPoint(x: 48.07, y: 3.21))
		leftFormPath.addCurve(to: CGPoint(x: 37.35, y: 0.36), controlPoint1: CGPoint(x: 45.18, y: 2.94), controlPoint2: CGPoint(x: 39.88, y: 1.52))
		leftFormPath.addLine(to: CGPoint(x: 36.58, y: 0))
		leftFormPath.addLine(to: CGPoint(x: 35.12, y: 1.28))
		leftFormPath.addCurve(to: CGPoint(x: 21.19, y: 9.51), controlPoint1: CGPoint(x: 30.46, y: 5.35), controlPoint2: CGPoint(x: 26.6, y: 7.63))
		leftFormPath.addCurve(to: CGPoint(x: 12.75, y: 13.96), controlPoint1: CGPoint(x: 17.67, y: 10.72), controlPoint2: CGPoint(x: 14.62, y: 12.33))
		leftFormPath.addCurve(to: CGPoint(x: 9.39, y: 18.71), controlPoint1: CGPoint(x: 11.69, y: 14.88), controlPoint2: CGPoint(x: 11.13, y: 15.67))
		leftFormPath.addCurve(to: CGPoint(x: 1.5, y: 40.13), controlPoint1: CGPoint(x: 5.36, y: 25.72), controlPoint2: CGPoint(x: 2.76, y: 32.79))
		leftFormPath.addCurve(to: CGPoint(x: 0.49, y: 44.69), controlPoint1: CGPoint(x: 1.21, y: 41.78), controlPoint2: CGPoint(x: 0.76, y: 43.83))
		leftFormPath.addLine(to: CGPoint(x: 0, y: 46.25))
		leftFormPath.addLine(to: CGPoint(x: 1.71, y: 48.11))
		leftFormPath.addCurve(to: CGPoint(x: 16.1, y: 56.89), controlPoint1: CGPoint(x: 5.41, y: 52.16), controlPoint2: CGPoint(x: 10.45, y: 55.23))
		leftFormPath.addCurve(to: CGPoint(x: 18.31, y: 57.48), controlPoint1: CGPoint(x: 17.19, y: 57.21), controlPoint2: CGPoint(x: 18.18, y: 57.48))
		leftFormPath.addCurve(to: CGPoint(x: 20.01, y: 53.51), controlPoint1: CGPoint(x: 18.51, y: 57.48), controlPoint2: CGPoint(x: 19.39, y: 55.44))
		leftFormPath.addCurve(to: CGPoint(x: 21.79, y: 49.45), controlPoint1: CGPoint(x: 20.4, y: 52.3), controlPoint2: CGPoint(x: 21.59, y: 49.6))
		leftFormPath.addCurve(to: CGPoint(x: 24.47, y: 77.56), controlPoint1: CGPoint(x: 22.3, y: 49.09), controlPoint2: CGPoint(x: 23.89, y: 65.71))
		leftFormPath.addCurve(to: CGPoint(x: 24.26, y: 98.75), controlPoint1: CGPoint(x: 24.74, y: 83.12), controlPoint2: CGPoint(x: 24.6, y: 96.88))
		leftFormPath.addCurve(to: CGPoint(x: 23.24, y: 102.25), controlPoint1: CGPoint(x: 24.13, y: 99.42), controlPoint2: CGPoint(x: 23.68, y: 101))
		leftFormPath.addCurve(to: CGPoint(x: 19.8, y: 118.93), controlPoint1: CGPoint(x: 21.4, y: 107.58), controlPoint2: CGPoint(x: 19.81, y: 115.29))
		leftFormPath.addLine(to: CGPoint(x: 19.8, y: 120.96))
		leftFormPath.addLine(to: CGPoint(x: 21.17, y: 121.41))
		leftFormPath.addCurve(to: CGPoint(x: 45.84, y: 124.85), controlPoint1: CGPoint(x: 27.05, y: 123.37), controlPoint2: CGPoint(x: 34.46, y: 124.4))
		leftFormPath.addLine(to: CGPoint(x: 49.74, y: 125))
		leftFormPath.addCurve(to: CGPoint(x: 50.69, y: 28.09), controlPoint1: CGPoint(x: 50.28, y: 92.28), controlPoint2: CGPoint(x: 50.84, y: 55.99))
		leftFormPath.addLine(to: CGPoint(x: 50.69, y: 28.09))
		leftFormPath.close()

		return leftFormPath
	}
	
	func getTeamFormRightPath() -> UIBezierPath {
		
		let rightFormPath = UIBezierPath()
		rightFormPath.move(to: CGPoint(x: 50.31, y: 28.09))
		rightFormPath.addLine(to: CGPoint(x: 50.37, y: 12.78))
		rightFormPath.addLine(to: CGPoint(x: 51.78, y: 12.63))
		rightFormPath.addCurve(to: CGPoint(x: 59, y: 8.53), controlPoint1: CGPoint(x: 54.42, y: 12.34), controlPoint2: CGPoint(x: 57.03, y: 10.86))
		rightFormPath.addCurve(to: CGPoint(x: 61.92, y: 3.86), controlPoint1: CGPoint(x: 59.83, y: 7.55), controlPoint2: CGPoint(x: 62.05, y: 4.01))
		rightFormPath.addCurve(to: CGPoint(x: 60.12, y: 4.36), controlPoint1: CGPoint(x: 61.9, y: 3.83), controlPoint2: CGPoint(x: 61.09, y: 4.06))
		rightFormPath.addCurve(to: CGPoint(x: 52.44, y: 5.8), controlPoint1: CGPoint(x: 57.78, y: 5.11), controlPoint2: CGPoint(x: 55.08, y: 5.61))
		rightFormPath.addLine(to: CGPoint(x: 49.26, y: 5.96))
		rightFormPath.addLine(to: CGPoint(x: 49.26, y: 4.67))
		rightFormPath.addLine(to: CGPoint(x: 49.26, y: 3.37))
		rightFormPath.addLine(to: CGPoint(x: 51.93, y: 3.21))
		rightFormPath.addCurve(to: CGPoint(x: 62.65, y: 0.36), controlPoint1: CGPoint(x: 54.82, y: 2.94), controlPoint2: CGPoint(x: 60.12, y: 1.52))
		rightFormPath.addLine(to: CGPoint(x: 63.42, y: 0))
		rightFormPath.addLine(to: CGPoint(x: 64.88, y: 1.28))
		rightFormPath.addCurve(to: CGPoint(x: 78.81, y: 9.51), controlPoint1: CGPoint(x: 69.54, y: 5.35), controlPoint2: CGPoint(x: 73.4, y: 7.63))
		rightFormPath.addCurve(to: CGPoint(x: 87.25, y: 13.96), controlPoint1: CGPoint(x: 82.33, y: 10.72), controlPoint2: CGPoint(x: 85.38, y: 12.33))
		rightFormPath.addCurve(to: CGPoint(x: 90.61, y: 18.71), controlPoint1: CGPoint(x: 88.31, y: 14.88), controlPoint2: CGPoint(x: 88.87, y: 15.67))
		rightFormPath.addCurve(to: CGPoint(x: 98.5, y: 40.13), controlPoint1: CGPoint(x: 94.64, y: 25.72), controlPoint2: CGPoint(x: 97.24, y: 32.79))
		rightFormPath.addCurve(to: CGPoint(x: 99.51, y: 44.69), controlPoint1: CGPoint(x: 98.79, y: 41.78), controlPoint2: CGPoint(x: 99.24, y: 43.83))
		rightFormPath.addLine(to: CGPoint(x: 100, y: 46.25))
		rightFormPath.addLine(to: CGPoint(x: 98.29, y: 48.11))
		rightFormPath.addCurve(to: CGPoint(x: 83.9, y: 56.89), controlPoint1: CGPoint(x: 94.59, y: 52.16), controlPoint2: CGPoint(x: 89.55, y: 55.23))
		rightFormPath.addCurve(to: CGPoint(x: 81.69, y: 57.48), controlPoint1: CGPoint(x: 82.81, y: 57.21), controlPoint2: CGPoint(x: 81.82, y: 57.48))
		rightFormPath.addCurve(to: CGPoint(x: 79.99, y: 53.51), controlPoint1: CGPoint(x: 81.49, y: 57.48), controlPoint2: CGPoint(x: 80.61, y: 55.44))
		rightFormPath.addCurve(to: CGPoint(x: 78.21, y: 49.45), controlPoint1: CGPoint(x: 79.6, y: 52.3), controlPoint2: CGPoint(x: 78.41, y: 49.6))
		rightFormPath.addCurve(to: CGPoint(x: 75.53, y: 77.56), controlPoint1: CGPoint(x: 77.7, y: 49.09), controlPoint2: CGPoint(x: 76.11, y: 65.71))
		rightFormPath.addCurve(to: CGPoint(x: 75.74, y: 98.75), controlPoint1: CGPoint(x: 75.26, y: 83.12), controlPoint2: CGPoint(x: 75.4, y: 96.88))
		rightFormPath.addCurve(to: CGPoint(x: 76.76, y: 102.25), controlPoint1: CGPoint(x: 75.87, y: 99.42), controlPoint2: CGPoint(x: 76.32, y: 101))
		rightFormPath.addCurve(to: CGPoint(x: 80.2, y: 118.93), controlPoint1: CGPoint(x: 78.6, y: 107.58), controlPoint2: CGPoint(x: 80.19, y: 115.29))
		rightFormPath.addLine(to: CGPoint(x: 80.2, y: 120.96))
		rightFormPath.addLine(to: CGPoint(x: 78.83, y: 121.41))
		rightFormPath.addCurve(to: CGPoint(x: 54.16, y: 124.85), controlPoint1: CGPoint(x: 72.95, y: 123.37), controlPoint2: CGPoint(x: 65.54, y: 124.4))
		rightFormPath.addLine(to: CGPoint(x: 49.26, y: 125))
		rightFormPath.addCurve(to: CGPoint(x: 50.31, y: 28.09), controlPoint1: CGPoint(x: 48.72, y: 92.28), controlPoint2: CGPoint(x: 50.16, y: 55.99))
		rightFormPath.addLine(to: CGPoint(x: 50.31, y: 28.09))
		rightFormPath.close()

		
		return rightFormPath
	}

	func setTeamFormColors(leftFormColor: UIColor, rightFormColor: UIColor) {
		
        if self.leftFormColor != leftFormColor || self.rightFormColor != rightFormColor {
            self.leftFormColor = leftFormColor
            self.rightFormColor = rightFormColor
            
            self.draw(self.bounds)
        }
	}
}
