//
//  SDynamicProperty.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

public
protocol SDynamicProperty {
    mutating func update()
}

// MARK: - default empty implementation
public
extension SDynamicProperty {
    mutating func update() {}
}
