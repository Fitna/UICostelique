//
//  BezierCostelique.swift
//  Akciz
//
//  Created by Олег on 17.04.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import UIKit.UIBezierPath

extension CGPath {
    func getY(forX x: CGFloat) -> [CGFloat] {
        var array: [CGFloat] = [CGFloat]()
        var prevPoint: CGPoint?
        self.forEach { (element) in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                prevPoint = element.points[0]
            case .addLineToPoint:
                if let prev = prevPoint {
                    let next = element.points[0]
                    let t = (x - prev.x)/(next.x - prev.x)
                    if t >= 0 && t <= 1 {
                        let y = (1 - t) * prev.y + t * next.y
                        array.append(y)
                    }
                }
                prevPoint = element.points[0]
            case .addQuadCurveToPoint:
                if let prev = prevPoint {
                    let endPoint = element.points[1]
                    let controlPoint = element.points[0]
                    let f = prev.x + endPoint.x - 2 * controlPoint.x
                    if f != 0 {
                        let d = sqrt(x * (f) + square(controlPoint.x) - prev.x * endPoint.x)
                        let t1 = (prev.x - controlPoint.x + d) / f
                        if t1 >= 0 && t1 <= 1 {
                            let t  = t1
                            let y = square(1 - t) * prev.y + 2 * t * (1 - t) * controlPoint.y + square(t) * endPoint.y
                            array.append(y)
                        }
                        let t2 = (prev.x - controlPoint.x - d) / (prev.x - 2 * controlPoint.x + endPoint.x)
                        if t2 >= 0 && t2 <= 1 {
                            let t  = t2
                            let y = square(1 - t) * prev.y + 2 * t * (1 - t) * controlPoint.y + square(t) * endPoint.y
                            array.append(y)
                        }
                    } else if prev.x != controlPoint.x {
                        let t = (x - prev.x) / (2 * (controlPoint.x - prev.x))
                        if t >= 0 && t <= 1 {
                            let y = square(1 - t) * prev.y + 2 * t * (1 - t) * controlPoint.y + square(t) * endPoint.y
                            array.append(y)
                        }
                    } else if prev.x != endPoint.x {
                        let t = sqrt((x - prev.x) / (endPoint.x - controlPoint.x))
                        if t >= 0 && t <= 1 {
                            let y = square(1 - t) * prev.y + 2 * t * (1 - t) * controlPoint.y + square(t) * endPoint.y
                            array.append(y)
                        }
                    }
                }
                prevPoint = element.points[1]
            case .addCurveToPoint:
                prevPoint = element.points[2]
            default:
                break
            }
        }
        return array
    }

    private func forEach( body:@escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        //print(MemoryLayout.size(ofValue: body))
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
}

fileprivate func square(_ x: CGFloat) -> CGFloat {
    return x*x
}

