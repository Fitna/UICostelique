//
//  Math.swift
//  Karma and destiny
//
//  Created by Олег on 20.11.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

//swiftlint:disable identifier_name
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

@discardableResult postfix func ++(number: inout Int) -> Int {
    number += 1
    return (number - 1)
}

@discardableResult prefix func ++(number: inout Int) -> Int {
    number += 1
    return number
}
