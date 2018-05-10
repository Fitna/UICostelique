//
//  EnumCollection.swift
//  Karma and destiny
//
//  Created by Олег on 01.12.2017.
//  Copyright © 2017 Олег. All rights reserved.
//

public protocol EnumCollection: Hashable {
    static func cases() -> AnySequence<Self>
    static var allValues: [Self] { get }
    static var count: Int { get }
    
    var index : Int { get }
    
    func nextValue() -> Self?
    func prevValue() -> Self?
}

public extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else {
                    return nil
                }
                raw += 1
                return current
            }
        }
    }
    
    static var allValues: [Self] {
        return Array(self.cases())
    }
    
    static var count: Int {
        return allValues.count
    }
    var index : Int {
        return Self.allValues.index(of: self)!
    }
    
    func nextValue() -> Self? {
        let index = self.index
        
        if index < Self.count - 1 {
            return Self.allValues[index + 1]
        }
        
        return nil
    }
    func prevValue() -> Self? {
        let index = self.index
        
        if index > 0 {
            return Self.allValues[index - 1]
        }
        
        return nil
    }
}


