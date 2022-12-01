//
//  ElementType.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

/// The possible type-erased element types.
enum ElementType {
    
    case app(any SApp)
    case scene(any SScene)
    case content(any SContent)
    
    var type: Any.Type {
        switch self {
        case let .app(app): return getType(app)
        case let .scene(scene): return getType(scene)
        case let .content(content): return getType(content)
        }
    }
    
    /// The type constructor name, excluding generic parameters, of the hosted element.
    var typeConstructorName: String {
        switch self {
            
        case .app:
            fatalError()
            
        case .scene(let scene):
            return StellarFoundation.typeConstructorName(getType(scene))
            
        case .content(let anyContent):
            return StellarFoundation.typeConstructorName(getType(anyContent))
        }
    }
}
