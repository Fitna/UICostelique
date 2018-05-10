//
//  UIFont.swift
//  ScreenStitch
//
//  Created by Олег on 10.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import UIKit.UIFont

extension UIFont {
    class func printAllFontsNames(){
        let fonts = UIFont.familyNames.sorted { (s1, s2) -> Bool in return
            s1 > s2
        }

        for family in fonts {
            print("family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family).sorted(by: { (s1, s2) -> Bool in
                return s1 > s2
            }) {
                print("      -> \(name)")
            }
        }
    }
}
