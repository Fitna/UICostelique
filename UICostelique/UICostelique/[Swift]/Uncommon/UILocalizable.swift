//
//  UILocalizable.swift
//  Karma and destiny
//
//  Created by Олег on 01.12.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

import Foundation

@objc protocol UILocalizable {
    @objc optional func localizationTableName() -> String?
}

extension UILocalizable {
    func localizedString(forKey key: String) -> String {
        let table: String? = self.localizationTableName?()
        let string = Bundle.main.localizedString(forKey: key, value: nil, table: table)
        return string
    }
}
