//
//  CustomKrutilka.swift
//  ScreenStitch
//
//  Created by Олег on 06.06.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import UIKit
#if COSTELIQUE
class CustomKrutilka: UIView {
    let replicatorLayer = CAReplicatorLayer()
    var fillColor: UIColor = UIColor.init(widthHexString: "6F26B1")
    var strokeColor: UIColor = UIColor.init(widthHexString: "6F26B1")

    override func awakeFromNib() {
        self.layer.addSublayer(replicatorLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        NSLog("layoutSubviews")
        self.updateKrutilka()
    }

    private struct parameters {
        static let opaciryAnimation: Double = 0.9
        static let rotationAnimation: Double = 10
        static let count: Int = 6
    }

    func updateKrutilka() {
        self.replicatorLayer.frame = self.layer.bounds
        self.layer.contentsScale = UIScreen.main.scale
        replicatorLayer.contentsScale = UIScreen.main.scale
        replicatorLayer.removeAllSublayers()

        let circleLayer = CAShapeLayer()
        circleLayer.contentsScale = UIScreen.main.scale
        circleLayer.frame = replicatorLayer.bounds
        circleLayer.path = segmentPath(withRadius: circleLayer.frame.size.width/2).cgPath
        circleLayer.fillColor = fillColor.cgColor
        circleLayer.add(opacityAnimation(), forKey: "krutilka.opac")
        circleLayer.opacity = 0

        circleLayer.add(scaleAnimation(), forKey: "krutilka.scale")
        replicatorLayer.addSublayer(circleLayer)

        replicatorLayer.instanceCount = parameters.count
        replicatorLayer.instanceDelay = parameters.opaciryAnimation / Double(parameters.count)
        let trans = CATransform3DMakeRotation(2 * CGFloat.pi/CGFloat(parameters.count), 0, 0, 1)
        replicatorLayer.instanceTransform = trans
//
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.replicatorLayer.add(self.rotationAnimation(), forKey: "krutilka.1")
        }
        self.replicatorLayer.add(self.rotationAnimation1(), forKey: "krutilka.3")
        CATransaction.commit()
        self.replicatorLayer.add(scaleAnimation1(), forKey: "krutilka.2")

        dispatch_after_main(5) {

            let animation = CAKeyframeAnimation(keyPath: "fillColor")
            animation.values = [self.fillColor.cgColor,
                                UIColor(widthHexString: "B73ABB").cgColor,
                                UIColor(widthHexString: "FF54B3").cgColor,
                                UIColor(widthHexString: "EE34F4").cgColor,
                                self.fillColor.cgColor,
                                self.fillColor.cgColor,
                                UIColor(widthHexString: "373DC6").cgColor,
                                UIColor(widthHexString: "548AFF").cgColor,
                                UIColor(widthHexString: "2F37F1").cgColor,
                                self.fillColor.cgColor
            ]
            animation.duration = 30
            animation.repeatCount = 100*100*100
//            animation.autoreverses = true
            circleLayer.add(animation, forKey: "asdlhbaslidasbk")
        }
    }

    func segmentPath(withRadius radius: CGFloat) -> UIBezierPath {
        let endAngle = 2 * CGFloat.pi/CGFloat(parameters.count) * 0.7
        let innerRadius = radius * 0.67
        let path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 0, endAngle: endAngle, clockwise: true)
        path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: innerRadius, startAngle: endAngle, endAngle: 0, clockwise: false)
        path.close()
        return path
    }

    func rotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = parameters.rotationAnimation
        animation.fromValue = 0
        animation.toValue = -Double.pi * 2
        animation.repeatCount = 100*100*100
        return animation
    }

    func opacityAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = parameters.opaciryAnimation
        animation.fromValue = 1
        animation.toValue = 0
        animation.repeatCount = .infinity
        return animation
    }

    func scaleAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = parameters.opaciryAnimation
        animation.fromValue = 1
        animation.toValue = 0.85
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        return animation
    }

    func scaleAnimation1() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.5
        animation.fromValue = 0.3
        animation.toValue = 1
        animation.repeatCount = 1
        animation.timingFunction  = CAMediaTimingFunction(controlPoints: 0.5, 1, 1, 1.2)
        return animation
    }

    func rotationAnimation1() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 5
        animation.fromValue = -Double.pi * 3
        animation.toValue = 0
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.8, 0.5, 1.2)
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        return animation
    }
}
#endif
