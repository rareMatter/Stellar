//
//  MutableReference.swift
//  
//
//  Created by Jesse Spencer on 2/20/23.
//

public
final
class MutableReference<Value>: Reference<Value> {
    
    public
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}
