//
//  _CompositeElementHost.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

@dynamicMemberLookup
protocol _CompositeElementHost: _Host {
    func updateEnvironment()
    var state: CompositeElementState { get }
}
extension _CompositeElementHost {
    subscript<T>(dynamicMember keypath: ReferenceWritableKeyPath<CompositeElementState, T>) -> T {
        get { state[keyPath: keypath] }
    }
}
