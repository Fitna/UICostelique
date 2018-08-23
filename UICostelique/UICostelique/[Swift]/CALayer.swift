//
//  CALayer.swift
//  UICostelique
//
//  Created by Олег on 14.08.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import UIKit

public extension CALayer {
    class func animate(withDuration time: CFTimeInterval, animations: () -> Swift.Void) {
        CATransaction.begin()
        if time == 0 {
            CATransaction.setDisableActions(true)
        } else {
            CATransaction.setAnimationDuration(time)
        }
        animations()
        CATransaction.commit()
    }
}
