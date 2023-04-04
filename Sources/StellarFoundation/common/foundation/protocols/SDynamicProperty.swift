//
//  SDynamicProperty.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

/// Properties marked as dynamic will cause the UI to update when changed.
///
/// - Note: Dynamic properties can have nested dynamic properties.
public
protocol SDynamicProperty {
    mutating func update()
}

// MARK: - default empty implementation
public
extension SDynamicProperty {
    mutating func update() {}
}
