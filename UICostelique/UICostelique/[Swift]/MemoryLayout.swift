//
//  UICosteliqueSwift.swift
//  Kirakira
//
//  Created by Олег on 05.10.17.
//  Copyright © 2017 Олег. All rights reserved.
//

import Swift

func sizeof <T> (_ : T.Type) -> Int {
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ : T) -> Int {
    return (MemoryLayout<T>.size)
}

func sizeof <T> (_ value : [T]) -> Int {
    return (MemoryLayout<T>.size * value.count)
}


//func isEqual<T: Equatable>(type: T.Type, a: Any, b: Any) -> Bool {
//    guard let a = a as? T, let b = b as? T else {
//        return false
//    }
//
//    return a == b
//}
