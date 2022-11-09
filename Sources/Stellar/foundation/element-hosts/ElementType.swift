//
//  ElementType.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// The possible type-erased element types.
enum ElementType {
    
    case app(AnySApp)
    case scene(AnySScene)
    case content(AnySContent)
    
    var type: Any.Type {
        switch self {
        case let .app(app): return app.type
        case let .scene(scene): return scene.type
        case let .content(content): return content.type
        }
    }
    
    /// The type constructor name, excluding generic parameters, of the hosted element.
    var typeConstructorName: String {
        switch self {
            
        case .app:
            fatalError()
            
        case .scene(let scene):
            return scene.typeConstructorName
            
        case .content(let anySContent):
            return anySContent.typeConstructorName
        }
    }
}
