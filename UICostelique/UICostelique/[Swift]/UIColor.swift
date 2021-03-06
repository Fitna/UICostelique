//
//  UIColor.swift
//  Jevelry AR
//
//  Created by Олег on 26.07.2018.
//  Copyright © 2018 Yegitov Aleksey. All rights reserved.
//

//swiftlint:disable identifier_name
import UIKit

public extension UIColor {
    convenience init(hex rgb: UInt32) {
        if rgb > 99999 && rgb < 1000000 {
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x00FF00) >> 8)  / 255.0
            let b = CGFloat(rgb & 0x0000FF)         / 255.0
            let a = CGFloat(1)
            self.init(red: r, green: g, blue: b, alpha: a)
        } else if rgb > 9999999 && rgb < 100000000 {
            let r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            let g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            let b = CGFloat((rgb & 0x0000FF00) >> 8)  / 255.0
            let a = CGFloat (rgb & 0x000000FF)        / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        } else {
            abort()
        }
    }

    convenience init(hex rgb: UInt32, alpha: Float) {
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        let a = CGFloat(alpha)
        self.init(red: r, green: g, blue: b, alpha: a)
    }

    convenience init(hexString string: String) {
        var trimmed = string.trimmingCharacters(in: CharacterSet(charactersIn: "# "))
        if trimmed.count == 6 {
            trimmed += "FF"
        }
        var rgba: UInt32 = 0
        guard Scanner(string: trimmed).scanHexInt32(&rgba) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
            return
        }
        self.init(hex: rgba >> 8, alpha: Float(rgba & 0x000000FF) / 255.0)
    }


    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        if r > 1 || g > 1 || b > 1 {
            self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
            return
        }
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
