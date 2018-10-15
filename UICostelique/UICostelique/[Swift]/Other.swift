//
//  Other.swift
//  PalmReadingScanner
//
//  Created by Олег on 12/10/2018.
//  Copyright © 2018 Digital Ecosystems. All rights reserved.
//

import Foundation
import UIKit

extension UIInterpolatingMotionEffect {
    convenience init(translationX dx: CGFloat) {
        self.init(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        self.minimumRelativeValue = -dx
        self.maximumRelativeValue = dx
    }

    convenience init(translationY dy: CGFloat) {
        self.init(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        self.minimumRelativeValue = -dy
        self.maximumRelativeValue = dy
    }
}
