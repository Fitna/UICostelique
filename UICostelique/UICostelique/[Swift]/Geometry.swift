//
//  Geometry.swift
//  Action Camera Master
//
//  Created by Олег on 05.05.17.
//  Copyright © 2017 Олег. All rights reserved.
//

import UIKit.UIGeometry
import CoreGraphics.CGGeometry

public extension CGSize {
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(width: x, height: y)
    }

    func size(withWidth:CGFloat) -> CGSize {
        return CGSize.init(width: withWidth, height:self.height)
    }
    
    func round() -> CGSize {
        return CGSize.init(width: CGFloat(Darwin.round(Double(self.width))), height: CGFloat(Darwin.round(Double(self.height))))
    }
    
    func fill(_ size:CGSize) -> CGSize {
        return fill(width:size.width, height:size.height)
    }
    
    func fill(width:CGFloat, height:CGFloat) -> CGSize {
        if (self.width / width < self.height / height) {
            return CGSize.init(width: width, height: width * self.height / self.width)
        }
        else {
            return CGSize.init(width: height*self.width / self.height, height: height)
        }
    }
    
    func fit(_ size:CGSize) -> CGSize {
        return fit (width: size.width, height: size.height)
    }
    
    func fit(width:CGFloat, height:CGFloat) -> CGSize {
        if (self.width / width > self.height / height) {
            return CGSize.init(width: width, height: width * self.height / self.width)
        }
        else {
            return CGSize.init(width: height * self.width / self.height, height: height)
        }
    }
    
    func fitRect(_ size:CGSize) -> CGRect {
        let fitSize = fit(size)
        return CGRect(x: size.width/2 - fitSize.width/2, y: size.height/2 - fitSize.height/2, width: fitSize.width, height: fitSize.height)
    }

    func fitRect(_ rect:CGRect) -> CGRect {
        let size = rect.size
        let fitSize = fit(size)
        var out = CGRect(x: size.width/2 - fitSize.width/2, y: size.height/2 - fitSize.height/2, width: fitSize.width, height: fitSize.height)
        out.origin.x += rect.origin.x
        out.origin.y += rect.origin.y
        return out
    }
    
    
    func fillRect(_ size:CGSize) -> CGRect {
        let fillSize = fill(size)
        return CGRect(x: size.width/2 - fillSize.width/2, y: size.height/2 - fillSize.height/2, width: fillSize.width, height: fillSize.height)
    }
    
    func point() -> CGPoint {
        return CGPoint(x: self.width, y: self.height)
    }
    
    func scale(_ scale: CGFloat) -> CGSize {
        return CGSize(width: self.width * scale, height: self.height * scale)
    }


    //Math
    static func * (left: CGSize, right:CGFloat) -> CGSize {
        return CGSize(width:left.width * right, height: left.height * right)
    }

    static func / (left: CGSize, right:CGFloat) -> CGSize {
        return CGSize(width:left.width / right, height: left.height / right)
    }

    static func - (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width - right.width, height: left.height - right.height)
    }

    static func + (left: CGSize, right: CGSize) -> CGSize {
        return CGSize(width: left.width + right.width, height: left.height + right.height)
    }
}

public extension CGPoint {
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x: x, y: y)
    }
    func distance(to point:CGPoint) -> CGFloat {
        let x : Double = Double(point.x - self.x)
        let y : Double = Double(point.y - self.y)
        return CGFloat(sqrt(x * x) + sqrt(y * y))
    }
    func round() -> CGPoint {
        return CGPoint(CGFloat(Darwin.round(Double(x))), CGFloat(Darwin.round(Double(y))))
    }

    //Math
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }

    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x / right, y: left.y / right)
    }
}

public extension CGRect {

    init(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat) {
        self.init(x: x, y: y, width: w, height: h);
    }
    func shift(_ shift: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x + shift,
                      y: self.origin.y + shift,
                      width: self.size.width - 2 * shift,
                      height: self.size.height - 2 * shift)
    }
    
    func shift(_ insets: UIEdgeInsets) -> CGRect {
        return CGRect(x: self.origin.x + insets.left,
                      y: self.origin.y + insets.bottom,
                      width: self.size.width - insets.left - insets.right,
                      height: self.size.height - insets.top - insets.bottom)
    }
    
    func center () -> CGPoint {
        return CGPoint(x: self.origin.x + self.size.width / 2,
                       y: self.origin.y + self.size.height / 2)
    }
    
    func round() -> CGRect {
        let rx = CGFloat(Darwin.round(Double(self.origin.x)))
        let ry = CGFloat(Darwin.round(Double(self.origin.y)))
        let rwidth = CGFloat(Darwin.round(Double(self.size.width)))
        let rheight = CGFloat(Darwin.round(Double(self.size.height)))
        return CGRect(x:rx, y:ry, width:rwidth, height: rheight)
    }
}




