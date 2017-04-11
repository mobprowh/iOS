//
//  QuartzFunView.swift
//  QuartzFun
//
//  Created by Kim Topley on 11/2/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

// Random color extension of UIColor
extension UIColor {
    class func randomColor() -> UIColor {
        let red = CGFloat(Double(arc4random_uniform(255))/255)
        let green = CGFloat(Double(arc4random_uniform(255))/255)
        let blue = CGFloat(Double(arc4random_uniform(255))/255)
        return UIColor(red: red, green: green, blue: blue, alpha:1.0)
    }
}

enum Shape : UInt {
    case Line = 0, Rect, Ellipse, Image
}

// The color tab indices
enum DrawingColor : UInt {
    case Red = 0, Blue, Yellow, Green, Random
}

class QuartzFunView: UIView {
    // Application-settable properties
    var shape = Shape.Line
    var currentColor = UIColor.redColor()
    var useRandomColor = false
    
    // Internal properties
    private let image = UIImage(named:"iphone")
    private var firstTouchLocation = CGPointZero
    private var lastTouchLocation = CGPointZero
    private var redrawRect = CGRectZero
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if useRandomColor {
                currentColor = UIColor.randomColor()
            }
            firstTouchLocation = touch.locationInView(self)
            lastTouchLocation = firstTouchLocation
            redrawRect = CGRectZero
            setNeedsDisplay()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            lastTouchLocation = touch.locationInView(self)
        
            if shape == .Image {
                let horizontalOffset = image!.size.width / 2
                let verticalOffset = image!.size.height / 2
                redrawRect = CGRectUnion(redrawRect,
                    CGRectMake(lastTouchLocation.x - horizontalOffset,
                        lastTouchLocation.y - verticalOffset,
                        image!.size.width, image!.size.height))
            } else {
                redrawRect = CGRectUnion(redrawRect, currentRect())
            }
            setNeedsDisplayInRect(redrawRect)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            lastTouchLocation = touch.locationInView(self)
        
            if shape == .Image {
                let horizontalOffset = image!.size.width / 2
                let verticalOffset = image!.size.height / 2
                redrawRect = CGRectUnion(redrawRect,
                    CGRectMake(lastTouchLocation.x - horizontalOffset,
                            lastTouchLocation.y - verticalOffset,
                            image!.size.width, image!.size.height))
            } else {
                redrawRect = CGRectUnion(redrawRect, currentRect())
            }
            setNeedsDisplayInRect(redrawRect)
        }
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 2.0)
        CGContextSetStrokeColorWithColor(context, currentColor.CGColor)
        CGContextSetFillColorWithColor(context, currentColor.CGColor)
       
        switch shape {
        case .Line:
            CGContextMoveToPoint(context, firstTouchLocation.x,
                                firstTouchLocation.y)
            CGContextAddLineToPoint(context, lastTouchLocation.x,
                                lastTouchLocation.y)
            CGContextStrokePath(context)
        
        case .Rect:
            CGContextAddRect(context,  currentRect())
            CGContextDrawPath(context, .FillStroke)
        
        case .Ellipse:
            CGContextAddEllipseInRect(context, currentRect())
            CGContextDrawPath(context, .FillStroke)
        
        case .Image:
            let horizontalOffset = image!.size.width / 2
            let verticalOffset = image!.size.height / 2
            let drawPoint =
                CGPointMake(lastTouchLocation.x - horizontalOffset,
                            lastTouchLocation.y - verticalOffset)
            image!.drawAtPoint(drawPoint)
        }
    }
    
    func currentRect() -> CGRect {
        return CGRectMake(firstTouchLocation.x,
            firstTouchLocation.y,
            lastTouchLocation.x - firstTouchLocation.x,
            lastTouchLocation.y - firstTouchLocation.y)
    }

}
