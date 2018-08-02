//
//  UIColor.swift
//  Jevelry AR
//
//  Created by Олег on 26.07.2018.
//  Copyright © 2018 Yegitov Aleksey. All rights reserved.
//

import UIKit

extension UIColor {
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
}
