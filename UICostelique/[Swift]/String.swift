//
//  String.swift
//  ScreenStitch
//
//  Created by Олег on 10.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import UIKit

extension String {
    func trimWhitespacesAndNewlines() -> String {
        let nsstr = self as NSString
        return nsstr.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func substring(from:Int, length:Int) -> String {
        let range = NSRange(location: from, length: length)
        let newstr = (self as NSString).substring(with: range)
        return newstr
    }

    func containsNumbers() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }

    func contains(string: String) -> Bool {
        return self.range(of: string) != nil
    }

    func isNumber() -> Bool {
        if let range = self.rangeOfCharacter(from: CharacterSet.decimalDigits) {
            if range.upperBound.encodedOffset - range.lowerBound.encodedOffset == self.count {
                return true
            }
        }
        return false
    }
}

func LocalizedString(inTable table:String?, forKey key:String) -> String {
    return Bundle.main.localizedString(forKey: key, value: nil, table: table)
}

protocol RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpression.Options) throws -> Bool
}

extension String: RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpression.Options = []) throws -> Bool {
        let regex = try NSRegularExpression(pattern: pattern, options: options)
        return regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: 0.distance(to: utf16.count))) != 0
    }
}

infix operator =~
func =~ <T: RegularExpressionMatchable> (left: T, right: String) -> Bool {
    return try! left.match(pattern: right, options: [])
}
