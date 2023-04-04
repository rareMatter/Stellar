//
//  CollectionBox.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

public
protocol CollectionBox<Object> {
    associatedtype Object
    var children: [Object] { get }
}
