//
//  _PrimitiveElementHost.swift
//  
//
//  Created by Jesse Spencer on 4/3/23.
//

protocol _PrimitiveElementHost: _Host {
    var renderedElement: PlatformContent? { get set }
}
