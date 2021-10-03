//
//  SBinding.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation
import SwiftUI

@propertyWrapper
@dynamicMemberLookup
public
struct SBinding<Value>: SDynamicProperty {
    
    public
    var wrappedValue: Value {
        get { get() }
        nonmutating set { set(newValue) }
    }
    
    private
    let get: () -> Value
    private
    let set: (Value) -> ()
    
    public
    var projectedValue: SBinding<Value> { self }
    
    public
    init(get: @escaping () -> Value, set: @escaping (Value) -> ()) {
        self.get = get
        self.set = set
    }
    
    public
    subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> SBinding<Subject> {
        .init {
            self.wrappedValue[keyPath: keyPath]
        } set: {
            self.wrappedValue[keyPath: keyPath] = $0
        }
    }
}

// MARK: constant bindings
public
extension SBinding {
    
    static
    func constant(_ value: Value) -> Self {
        .init(get: { value }, set: { _ in })
    }
}
