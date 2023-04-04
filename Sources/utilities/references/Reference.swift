//
//  Reference.swift
//  
//
//  Created by Jesse Spencer on 2/20/23.
//

@dynamicMemberLookup
public
class Reference<Value> {
    
    public
    var value: Value
    
    public
    init(_ value: Value) {
        self.value = value
    }
    
    public
    subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        value[keyPath: keyPath]
    }
}
extension Reference: Hashable, Equatable
where Value : Hashable & Equatable {
    
    public
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    public
    static
    func ==(lhs: Reference, rhs: Reference) -> Bool {
        lhs.value == rhs.value
    }
}
