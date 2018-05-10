//
//  Math.swift
//  Karma and destiny
//
//  Created by Олег on 20.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

import CoreGraphics.CGBase

prefix operator √

prefix func √ (number: Double) -> Double {
    return sqrt(number)
}

prefix func √ (number: Float) -> Float {
    return sqrtf(number)
}

prefix func √ (number:CGFloat) -> CGFloat {
    return CGFloat(sqrt(Double(number)))
}


