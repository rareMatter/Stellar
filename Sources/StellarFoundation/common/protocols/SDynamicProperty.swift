//
//  SDynamicProperty.swift
//  
//
//  Created by Jesse Spencer on 9/26/21.
//

import Foundation

public
protocol SDynamicProperty {
    mutating func update()
}

// MARK: - default empty implementation
public
extension SDynamicProperty {
    mutating func update() {}
}
