//
//  BA_CircleProgressView.swift
//  bahisadam
//
//  Created by ilker özcan on 28/11/2016.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import UIKit

@IBDesignable
class BA_CircleProgressView: UIView {

	private var _currentProgress: Double = -1
	private var _lineWidth: CGFloat = 0
	
	@IBInspectable var trackBackgroundColor: UIColor!
	@IBInspectable var trackColor: UIColor!
	
	@IBInspectable var currentProgress: Double {
		set {
			_currentProgress = newValue
		}
		
		get {
			return _currentProgress
		}
	}
	
	@IBInspectable var lineWidth: CGFloat {
		
		set {
			_lineWidth = newValue
		}
		
		get {
			return _lineWidth
		}
	}
	
	private var progressCircle: CAShapeLayer?
	private var progressTrackCircle: CAShapeLayer?
	private var pathBounds: CGRect?
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
	*/
	
	override func draw(_ rect: CGRect) {
        // Drawing code
		
		if(self.pathBounds == nil) {
			
			self.calculatePathBounds(rect: rect)
		}
		
		self.progressCircle = CAShapeLayer()
		let circlePath = UIBezierPath(ovalIn: pathBounds!)
		//circlePath.stroke(with: CGBlendMode(rawValue: Int32(self.lineWidth))!, alpha: 1)
		
		self.progressCircle?.path = circlePath.cgPath
		self.progressCircle?.strokeColor = trackBackgroundColor?.cgColor
		self.progressCircle?.fillColor = UIColor.clear.cgColor
		self.progressCircle?.lineWidth = _lineWidth
		
		self.layer.addSublayer(self.progressCircle!)
		
		if(self._currentProgress >= 0) {
			
			let trackPath = UIBezierPath(ovalIn: pathBounds!)
			//trackPath.stroke(with: CGBlendMode(rawValue: Int32(self.lineWidth))!, alpha: 1)
			
			self.progressTrackCircle = CAShapeLayer()
			self.progressTrackCircle?.path = trackPath.cgPath
			self.progressTrackCircle?.strokeColor = trackColor?.cgColor
			self.progressTrackCircle?.lineWidth = _lineWidth
			self.progressTrackCircle?.fillColor = UIColor.clear.cgColor
			self.progressTrackCircle?.strokeStart = 0
			self.progressTrackCircle?.strokeEnd = CGFloat(self.currentProgress)
			self.layer.addSublayer(self.progressTrackCircle!)
		}

    }

	private func calculatePathBounds(rect: CGRect) {
		
		self.layoutIfNeeded()
		let progressSize: CGSize
		
		
		if(rect.size.width > rect.size.height) {
			
			progressSize = CGSize(width: rect.size.height - (self.lineWidth * 4) - 6, height: rect.size.height - (self.lineWidth * 4) - 6)

		}else if(rect.size.width > rect.size.height) {
			progressSize = CGSize(width: rect.size.width - (self.lineWidth * 4) - 6, height: rect.size.width - (self.lineWidth * 4) - 6)
		}else{
			
			progressSize = CGSize(width: rect.size.width - (self.lineWidth * 4) - 6, height: rect.size.width - (self.lineWidth * 4) - 6)
		}
		
		let progressPos = CGPoint(x: (self.lineWidth + 6), y: (self.lineWidth + 6))
		
		self.pathBounds = CGRect(x: progressPos.x, y: progressPos.y, width: progressSize.width, height: progressSize.height)
		
	}
	
	func setProgress(progress: Double, animationduration: CFTimeInterval) {
		
		if(self.progressTrackCircle != nil) {
			self.progressTrackCircle?.removeFromSuperlayer()
		}
		
		if(self.pathBounds == nil) {
			
			self.calculatePathBounds(rect: self.bounds)
		}
		
		let trackPath = UIBezierPath(ovalIn: pathBounds!)
		//trackPath.stroke(with: CGBlendMode(rawValue: Int32(_lineWidth))!, alpha: 1)
		
		self.currentProgress = progress
		self.progressTrackCircle = CAShapeLayer()
		self.progressTrackCircle?.path = trackPath.cgPath
		self.progressTrackCircle?.strokeColor = trackColor?.cgColor
		self.progressTrackCircle?.lineWidth = _lineWidth
		self.progressTrackCircle?.fillColor = UIColor.clear.cgColor
		self.layer.addSublayer(self.progressTrackCircle!)
		
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.fromValue = 0
		animation.toValue = Float(_currentProgress)
		animation.duration = animationduration
		animation.fillMode = kCAFillModeForwards
		animation.isRemovedOnCompletion = false
		self.progressTrackCircle?.add(animation, forKey: "trackAnimation")
	}
}
