//
//  HashableProxy.swift
//  
//
//  Created by Jesse Spencer on 11/23/22.
//

/// A container which allows a value to be stored and associated with another value that is hashable.
///
/// This is useful when a type itself isn't hashable but can be associated with a hashable value.
public
struct HashableProxy<T, H>: Hashable
where H: Hashable {
    
    public
    let value: T
    public
    let hashableValue: H
    
    public
    init(value: T, hashableValue: H) {
        self.value = value
        self.hashableValue = hashableValue
    }
    
    public
    static func == (lhs: HashableProxy<T, H>, rhs: HashableProxy<T, H>) -> Bool {
        lhs.hashableValue == rhs.hashableValue
    }
    
    public
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashableValue)
    }
}
