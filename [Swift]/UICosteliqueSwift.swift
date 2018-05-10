//
//  UICosteliqueSwift.swift
//  Kirakira
//
//  Created by Олег on 05.10.17.
//  Copyright © 2017 Олег. All rights reserved.
//

import CoreMedia.CMSampleBuffer
import UIKit.UIView

extension CMSampleBuffer {

    func size() -> CGSize {
        if let imageBuffer = CMSampleBufferGetImageBuffer(self) {
            return CGSize(width: CVPixelBufferGetWidth(imageBuffer), height: CVPixelBufferGetHeight(imageBuffer))
        } else {
            abort()
        }
    }
}

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

extension DispatchQueue {
    class func mainSyncWLD (execute block: () -> Swift.Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute:block)
        }
    }
}

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

func printAllFontNames(){
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

func sizeof <T> (_ : T.Type) -> Int {
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ : T) -> Int {
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ value : [T]) -> Int {
    return (MemoryLayout<T>.size * value.count)
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
