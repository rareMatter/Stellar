//
//  _MutableCompositeElementHost.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

@dynamicMemberLookup
protocol _MutableCompositeElementHost: _CompositeElementHost {
    var mutableState: CompositeElementState { get set }
}
extension _MutableCompositeElementHost {
    subscript<T>(dynamicMember keypath: ReferenceWritableKeyPath<CompositeElementState, T>) -> T {
        get { mutableState[keyPath: keypath] }
        set { mutableState[keyPath: keypath] = newValue }
    }
}
