//
//  Synchronization.swift
//  SimpleFFPlayer
//
//  Created by tranvanloc on 4/20/17.
//  Copyright © 2017 jefby. All rights reserved.
//

import UIKit

class Synchronization: NSObject {
    override init() {
        super.init()
        let state = Synchronized<State>(State())
//        let message = state.read { $0.statusMessage }
//        state.write { state in
//            state.items.append(Item())
//        }
//        
//        let message = state.use { $0.statusMessage }
//        state.update { state in
//            state.items.append(Item())
//        }
        
        let criticalState = Synchronized<CriticalState>(CriticalState.init(title: "xyz", things: [], sublteDerivedValue: 0))
        let criticalString = Synchronized("test")
//        // This doesn't work:
//        print(criticalString.value)
        
        let uppercasedString = criticalString.use { string in
            return string.uppercased()
        }
        print(uppercasedString)

        
//        let criticalState = Synchronized<CriticalState>(CriticalState.init(title: "xyz", things: [], sublteDerivedValue: 0))
        let unsafeReference = criticalState.use { $0 }
//        unsafeReference.mutate()  // <-- This is bad!
    }
}


class Synchronized<T> {
    private var value: T
    private let lock = DispatchSemaphore(value: 1)
    
    init(_ value: T) {
        self.value  = value
        
    }
    
    
    /// The unwrapped value is passed in to the given closure, as a read-only value.  And, you can
    /// then calculate some value from it (the <code>R</code>), and return it from the closure, and
    /// it's returned from the <code>.use()</code> method.
    func use<R>(block: (T) throws -> R) rethrows -> R {
        lock.wait()
        defer { lock.signal() }
        return try block(value)
    }
    
    /// This method lets you pass a closure that takes the old value as an `inout` argument, so
    /// you can use that when determining the new value (which you set by just mutating that
    /// closure parameter.
    /// - note: The lock is held during the whole execution of the closure.
    func update(block: (inout T) throws -> Void) rethrows {
        lock.wait()
        defer { lock.signal() }
        try block(&value)
    }
    
    /// - note: If the wrapped type a reference type, you shouldn't use the return
    /// value it to modify it, because that won't be synchronized after this methods returns.
    func unsafeGet() -> T {
        lock.wait()
        defer { lock.signal() }
        return value
    }
}

//It only holds a single value, but you can put multiple things in there by putting them all in a struct. And, then you know they will always be updated together.
struct CriticalState {
    let title: String // = "xyz"
    var things: [String] = []
    var sublteDerivedValue: Int = 0  // for example, this is the length of the things array
}

struct Item {
    
}

struct State {
    var statusMessage: String = "abc"
    var items: [Item] = []
}
