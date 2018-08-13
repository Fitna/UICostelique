//
//  DispatchQueue.swift
//  ScreenStitch
//
//  Created by Олег on 10.05.2018.
//  Copyright © 2018 Олег. All rights reserved.
//

import Foundation.NSThread

extension DispatchQueue {
    class func mainSyncWLD (execute block: () -> Swift.Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute:block)
        }
    }
}
