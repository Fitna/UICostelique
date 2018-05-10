//
//  NotificationName.swift
//  ScreenStitch
//
//  Created by Олег on 10.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import Foundation.NSString

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
