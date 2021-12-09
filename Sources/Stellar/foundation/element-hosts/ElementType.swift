//
//  ElementType.swift
//  
//
//  Created by Jesse Spencer on 10/24/21.
//

import Foundation

/// The possible type-erased element types.
enum ElementType {
    // TODO: Need other element types.
    case content(AnySContent)
    
    var type: Any.Type {
        switch self {
            case let .content(content): return content.type
        }
    }
}
