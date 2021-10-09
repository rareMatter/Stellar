//
//  SHashableClosure.swift
//  
//
//  Created by Jesse Spencer on 4/29/21.
//

import Foundation

/// A wrapper for a closure which conforms to `Hashable` and uses a `UUID` for equality comparison and hashing.
///
/// Due to the non-comparable nature of closures in Swift,
/// this wrapper associates a `UUID` with the provided closure.
///
/// - Warning: This wrapper cannot guarantee equality will always resolve as expected. Be sure to consider your use case and remember that,
/// ultimately, equality is only determined by the associated `UUID`.
public
struct SHashableClosure {
    
    let uuid: UUID
    let handler: () -> Void
    
    public
    init(uuid: UUID = .init(), _ handler: @escaping () -> Void) {
        self.uuid = uuid
        self.handler = handler
    }
    
    func callAsFunction() {
        handler()
    }
}

extension SHashableClosure: Hashable, Identifiable {
    
    public var id: UUID {
        uuid
    }
    
    public
    static
    func ==(lhs: SHashableClosure, rhs: SHashableClosure) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    public
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
