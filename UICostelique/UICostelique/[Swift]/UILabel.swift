//
//  UILabel.swift
//  UICostelique
//
//  Created by Олег on 19.09.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import UIKit

extension UILabel {
    func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, forSubstring: String? = "[full_text]") {
        guard let substring = forSubstring else {
            return
        }

        var string: NSAttributedString? = self.attributedText
        if string == nil, let title = self.text {
            string = NSAttributedString(string: title)
        }

        guard let text = string else {
            return
        }

        let mutStr = text.mutableCopy() as! NSMutableAttributedString
        if substring == "[full_text]" {
            mutStr.setAttributes(attrs, range: NSRange(location: 0, length: text.length))
        } else if let range = text.string.lowercased().range(of: substring) {
            let start = range.lowerBound.encodedOffset
            let length = range.upperBound.encodedOffset - range.lowerBound.encodedOffset
            mutStr.setAttributes(attrs, range: NSRange(location: start, length: length))
        }
        self.attributedText = mutStr
    }
}
