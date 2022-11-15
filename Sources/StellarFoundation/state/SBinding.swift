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

// MARK: transactions
public
extension SBinding {
    // TODO:
}

// MARK: conditional conformances

extension SBinding: Identifiable
where Value : Identifiable {
    public var id: some Hashable { wrappedValue.id }
}

extension SBinding: Sequence
where Value : MutableCollection {
    public typealias Element = SBinding<Value.Element>
    public typealias Iterator = IndexingIterator<SBinding<Value>>
    public typealias SubSequence = Slice<SBinding<Value>>
}

extension SBinding: Collection
where Value : MutableCollection {
    public typealias Index = Value.Index
    public typealias Indices = Value.Indices
    public var startIndex: SBinding<Value>.Index { wrappedValue.startIndex }
    public var endIndex: SBinding<Value>.Index { wrappedValue.endIndex }
    public var indices: Value.Indices { wrappedValue.indices }
    
    public func index(after i: SBinding<Value>.Index) -> SBinding<Value>.Index {
        wrappedValue.index(after: i)
    }
    
    public func formIndex(after i: inout SBinding<Value>.Index) {
        wrappedValue.formIndex(after: &i)
    }
    
    public subscript(position: SBinding<Value>.Index) -> SBinding<Value>.Element {
        SBinding<Value.Element> {
            wrappedValue[position]
        } set: {
            wrappedValue[position] = $0
        }
    }
}

extension SBinding: BidirectionalCollection
where Value : BidirectionalCollection,
Value : MutableCollection {
    public func index(before i: SBinding<Value>.Index) -> SBinding<Value>.Index {
        wrappedValue.index(before: i)
    }
    
    public func formIndex(before i: inout SBinding<Value>.Index) {
        wrappedValue.formIndex(before: &i)
    }
}

extension SBinding: RandomAccessCollection
where Value : MutableCollection,
Value : RandomAccessCollection {}
